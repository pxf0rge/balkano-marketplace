import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ImagePickerBox extends StatelessWidget {
  final List<File> images;
  final VoidCallback onPickImages;
  final Function(int index) onRemove;

  const ImagePickerBox({
    super.key,
    required this.images,
    required this.onPickImages,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return GestureDetector(
        onTap: onPickImages,
        child: DottedBorder(
          options: const RoundedRectDottedBorderOptions(
            radius: Radius.circular(12),
            strokeWidth: 1.3,
            dashPattern: [6, 4],
          ),
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 40),
                const SizedBox(height: 10),
                Text(
                  "upload_images_hint".tr(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // وقتی عکس داریم
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length + (images.length < 8 ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        if (index == images.length && images.length < 8) {
          return GestureDetector(
            onTap: onPickImages,
            child: const DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: Radius.circular(12),
                dashPattern: [6, 4],
              ),
              child: Center(child: Icon(Icons.add)),
            ),
          );
        }

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                images[index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
