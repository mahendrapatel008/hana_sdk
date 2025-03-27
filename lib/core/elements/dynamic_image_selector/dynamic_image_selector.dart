import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_image_selector/dynamic_image_selector_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:image_picker/image_picker.dart';

class DynamicImageSelector extends StatefulWidget {
  final DynamicImageSelectorModel controller;
  final FormController formController;

  const DynamicImageSelector({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicImageSelector> createState() => _DynamicImageSelectorState();
}

class _DynamicImageSelectorState extends State<DynamicImageSelector> {
  String imageUrl = '';
  File? selectedImage;

  @override
  void initState() {
    widget.formController.saveFieldName(widget.controller.name);
    fetchImage();
    super.initState();
  }

  void fetchImage() {
    // Fetch image URL based on dynamic data
    setState(() {
      String? val = getDynamicValue(
          widget.controller.imgUrl?.replaceAll('{', '').replaceAll('}', ''));
      imageUrl = widget.controller.imgUrl ??
          widget.formController.dynamicData[val]?.toString() ??
          widget.formController.dynamicData[widget.controller.dataKey]
              ?.toString() ??
          ''; // Fallback to empty if no URL is found
    });
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        imageUrl = ''; // Clear existing URL if a new image is selected
      });
      // Save the selected image path to the form controller
      // widget.formController.dynamicData[widget.controller.name ?? ''] =
      //     pickedFile.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        selectedImage != null
            ? ClipOval(
                child: Image.file(
                  selectedImage!,
                  fit: widget.controller.fit ?? BoxFit.cover,
                  height: widget.controller.height?.toDouble() ?? 100.0,
                  width: widget.controller.width?.toDouble() ?? 100.0,
                ),
              )
            : imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: widget.controller.fit ?? BoxFit.cover,
                    height: widget.controller.height?.toDouble() ?? 100.0,
                    width: widget.controller.width?.toDouble() ?? 100.0,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image,
                          size: 50, color: Colors.red);
                    },
                  )
                : Center(
                    child: Text(
                      widget.controller.placeholder ?? 'No Image Selected',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: pickImageFromGallery,
          icon: const Icon(Icons.image),
          label: const Text('Select Image'),
        ),
      ],
    );
  }
}
