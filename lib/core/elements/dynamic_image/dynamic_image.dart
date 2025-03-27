import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_image/dynamic_image_model.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicImage extends StatelessWidget {
  final DynamicImageModel controller;
  final VoidCallback onPressed;
  final FormController formController;

  const DynamicImage({
    super.key,
    required this.controller,
    required this.onPressed,
    required this.formController,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: resolveDynamicValue(
            controller.dataKey, controller.imgUrl, formController),
        builder: (context, snapshot) {
          final resolvedImg = snapshot.data ??
              controller.imgUrl ??
              controller.placeholder ??
              '...';
          double screenWidth = MediaQuery.of(context).size.width;
          double? width = controller.width
              ?.toDouble(); // Full screen width if width is null
          width = width == 2000
              ? screenWidth
              : width; // Ensures 2000 is treated as full screen width

          ImageProvider imageProvider;

          if (controller.imgFromGallery == true) {
            File? fileImage = SharedPrefs().galleryImage;
            imageProvider = fileImage!.existsSync()
                ? FileImage(fileImage)
                : const AssetImage('assets/images/Logo.png');
          } else if (controller.dataKey != null &&
              controller.dataKey!.isNotEmpty) {
            imageProvider = NetworkImage(resolvedImg);
          } else if ((controller.imgUrl ?? '').isEmpty) {
            imageProvider = (controller.placeholder ?? '').isNotEmpty
                ? NetworkImage(controller.placeholder ?? '')
                : const AssetImage('assets/images/Logo.png');
          } else {
            imageProvider = NetworkImage(controller.imgUrl ?? '');
          }
          return controller.onClickData != null
              ? IconButton(
                  onPressed: onPressed,
                  icon: Container(
                    height: controller.height?.toDouble(),
                    width: width,
                    margin: EdgeInsets.only(
                        left: controller.margin?.left?.toDouble() ?? 0,
                        right: controller.margin?.right?.toDouble() ?? 0,
                        top: controller.margin?.top?.toDouble() ?? 0,
                        bottom: controller.margin?.bottom?.toDouble() ?? 0),
                    padding: EdgeInsets.only(
                        left: controller.padding?.left?.toDouble() ?? 0,
                        right: controller.padding?.right?.toDouble() ?? 0,
                        top: controller.padding?.top?.toDouble() ?? 0,
                        bottom: controller.padding?.bottom?.toDouble() ?? 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            controller.radius?.toDouble() ?? 0),
                        color: controller.backGroundColor,
                        border: controller.showBorder ?? false
                            ? Border.all(
                                color: controller.borderColor ??
                                    hexToColor("#FFFFFF") ??
                                    Colors.black,
                                width: controller.borderWidth?.toDouble() ?? 0)
                            : null,
                        image: DecorationImage(
                            fit: controller.fit, image: imageProvider)),
                  ),
                )
              : Container(
                  height: controller.height?.toDouble(),
                  width: width,
                  margin: EdgeInsets.only(
                      left: controller.margin?.left?.toDouble() ?? 0,
                      right: controller.margin?.right?.toDouble() ?? 0,
                      top: controller.margin?.top?.toDouble() ?? 0,
                      bottom: controller.margin?.bottom?.toDouble() ?? 0),
                  padding: EdgeInsets.only(
                      left: controller.padding?.left?.toDouble() ?? 0,
                      right: controller.padding?.right?.toDouble() ?? 0,
                      top: controller.padding?.top?.toDouble() ?? 0,
                      bottom: controller.padding?.bottom?.toDouble() ?? 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          controller.radius?.toDouble() ?? 0),
                      color: controller.backGroundColor,
                      border: controller.showBorder ?? false
                          ? Border.all(
                              color: controller.borderColor ??
                                  hexToColor("#FFFFFF") ??
                                  Colors.black,
                              width: controller.borderWidth?.toDouble() ?? 0)
                          : null,
                      image: DecorationImage(
                        fit: controller.fit,
                        image: imageProvider,
                      )),
                );
        });
  }
}
