import 'package:Balkano/features/listing/data/datasource/listing_remote_datasource.dart';
import 'package:Balkano/features/listing/widgets/description_field.dart';
import 'package:Balkano/features/listing/widgets/image_picker_box.dart';
import 'package:Balkano/features/listing/widgets/listing_action_buttons.dart';
import 'package:Balkano/features/listing/widgets/listing_dropdown_field.dart';
import 'package:Balkano/features/listing/widgets/listing_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  String _selectedCondition = "condition_very_good".tr();
  String? _selectedCategory;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      format: CompressFormat.jpeg,
    );

    if (result == null) {
      return file; // fallback
    }

    return File(result.path);
  }

  Future<void> _postListing() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text("please_select_listing_type".tr()),
        ),
      );
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("select_at_least_one_image".tr())));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final datasource = ListingRemoteDatasource(Supabase.instance.client);

      // ✅ Compress before upload
      final compressedImages = <File>[];

      for (final image in _selectedImages) {
        final compressed = await compressImage(image);
        compressedImages.add(compressed);
      }

      final imageUrls = await datasource.uploadImages(compressedImages);

      await datasource.createListing(
        title: _titleController.text.trim(),
        color: _colorController.text.trim(),
        condition: _selectedCondition,
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        location: _locationController.text.trim(),
        imageUrls: imageUrls,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("listing_created_success".tr())));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("listing_create_failed".tr())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  final List<File> _selectedImages = [];

  // void _submit() {
  //   if (_formKey.currentState!.validate()) {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 147),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "create_new_listing".tr(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("product_image".tr()),
              const SizedBox(height: 8),
              ImagePickerBox(
                images: _selectedImages,
                onPickImages: _pickImages,
                onRemove: _removeImage,
              ),

              const SizedBox(height: 24),

              Text("title".tr()),
              const SizedBox(height: 8),
              ListingTextField(
                hint: "title_example".tr(),
                controller: _titleController,
              ),

              const SizedBox(height: 24),

              Text("description".tr()),
              const SizedBox(height: 8),
              DescriptionField(controller: _descriptionController),

              const SizedBox(height: 24),

              Text("listing_type".tr()),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    hint: Text("select_listing_type".tr()),
                    items: [
                      DropdownMenuItem(
                        value: 'product',
                        child: Text("category_products".tr()),
                      ),
                      DropdownMenuItem(
                        value: 'service',
                        child: Text("category_services".tr()),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text("color".tr()),
              const SizedBox(height: 8),
              ListingTextField(
                hint: "color_example".tr(),
                controller: _colorController,
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
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value!;
                  });
                },
              ),

              const SizedBox(height: 24),

              Text("price_pkr".tr()),
              const SizedBox(height: 8),
              ListingTextField(
                hint: "price_zero".tr(),
                keyboardType: TextInputType.number,
                controller: _priceController,
              ),

              const SizedBox(height: 24),

              Text("location".tr()),
              const SizedBox(height: 8),
              ListingTextField(
                hint: "location_example".tr(),
                controller: _locationController,
              ),

              const SizedBox(height: 32),

              ListingActionButtons(onPost: _postListing, isLoading: _isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();

    if (images.isEmpty) return;

    final remainingSlots = 8 - _selectedImages.length;

    final newImages = images.take(remainingSlots).map((x) => File(x.path));

    setState(() {
      _selectedImages.addAll(newImages);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }
}
