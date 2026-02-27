import 'dart:io';
import 'package:Balkano/data/models/product.dart';
import 'package:Balkano/features/listing/data/datasource/listing_remote_datasource.dart';
import 'package:Balkano/features/listing/widgets/description_field.dart';
import 'package:Balkano/features/listing/widgets/listing_action_buttons.dart';
import 'package:Balkano/features/listing/widgets/listing_dropdown_field.dart';
import 'package:Balkano/features/listing/widgets/listing_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditListingPage extends StatefulWidget {
  final Product product;

  const EditListingPage({super.key, required this.product});

  @override
  State<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _colorController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;

  String _selectedCondition = "condition_very_good".tr();

  final ImagePicker _picker = ImagePicker();

  final List<File> _newImages = [];
  List<String> _existingImages = [];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.product.name);

    _descriptionController = TextEditingController(
      text: widget.product.description,
    );

    _colorController = TextEditingController(text: widget.product.color);

    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );

    _locationController = TextEditingController(text: widget.product.location);

    /// 👇 تبدیل enum به متن صحیح dropdown
    switch (widget.product.condition.name) {
      case "veryGood":
        _selectedCondition = "condition_very_good".tr();
        break;
      case "good":
        _selectedCondition = "condition_good".tr();
        break;
      case "fair":
        _selectedCondition = "condition_fair".tr();
        break;
    }

    _existingImages = List.from(widget.product.imageUrls);
  }

  Future<File> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
    );

    return result == null ? file : File(result.path);
  }

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isEmpty) return;

    final remaining = 8 - (_existingImages.length + _newImages.length);
    if (remaining <= 0) return;

    setState(() {
      _newImages.addAll(images.take(remaining).map((e) => File(e.path)));
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  Future<void> _updateListing() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final datasource = ListingRemoteDatasource(Supabase.instance.client);

      final compressed = <File>[];

      for (final img in _newImages) {
        compressed.add(await _compressImage(img));
      }

      final uploadedUrls = compressed.isNotEmpty
          ? await datasource.uploadImages(compressed)
          : <String>[];

      final finalImages = [..._existingImages, ...uploadedUrls];

      await Supabase.instance.client
          .from('products')
          .update({
            'title': _titleController.text.trim(),
            'description': _descriptionController.text.trim(),
            'color': _colorController.text.trim(),
            'condition': _selectedCondition,
            'price': double.parse(_priceController.text.trim()),
            'location': _locationController.text.trim(),
            'images': finalImages,
          })
          .eq('id', widget.product.id);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("update_listing_failed".tr())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildImageGrid() {
    final totalCount = _existingImages.length + _newImages.length;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCount + (totalCount < 8 ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        if (index == totalCount && totalCount < 8) {
          return GestureDetector(
            onTap: _pickImages,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add),
            ),
          );
        }

        /// Existing images (network)
        if (index < _existingImages.length) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _existingImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => _removeExistingImage(index),
                  child: const Icon(Icons.close, color: Colors.red),
                ),
              ),
            ],
          );
        }

        /// New images (file)
        final newIndex = index - _existingImages.length;

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_newImages[newIndex], fit: BoxFit.cover),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeNewImage(newIndex),
                child: const Icon(Icons.close, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("edit_listing".tr()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageGrid(),
              const SizedBox(height: 24),

              Text("title".tr()),
              const SizedBox(height: 8),
              ListingTextField(
                controller: _titleController,
                hint: "title".tr(),
              ),

              const SizedBox(height: 24),

              Text("description".tr()),
              const SizedBox(height: 8),
              DescriptionField(controller: _descriptionController),

              const SizedBox(height: 24),

              Text("color".tr()),
              const SizedBox(height: 8),
              ListingTextField(
                controller: _colorController,
                hint: "color".tr(),
              ),

              const SizedBox(height: 24),

              Text("condition".tr()),
              const SizedBox(height: 8),
              ListingDropdownField(
                value: _selectedCondition,
                items: [
                  "condition_very_good".tr(),
                  "condition_good".tr(),
                  "condition_fair".tr(),
                ],
                onChanged: (v) {
                  setState(() {
                    _selectedCondition = v!;
                  });
                },
              ),

              const SizedBox(height: 24),

              const Text("Price"),
              const SizedBox(height: 8),
              ListingTextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                hint: "0",
              ),

              const SizedBox(height: 24),

              Text("location".tr()),
              const SizedBox(height: 8),
              ListingTextField(
                controller: _locationController,
                hint: "location".tr(),
              ),

              const SizedBox(height: 32),

              ListingActionButtons(
                onPost: _updateListing,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
