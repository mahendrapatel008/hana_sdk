import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_qr_generator/dynamic_qr_generator_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DynamicQrGenerator extends StatefulWidget {
  final DynamicQrGeneratorModel controller;
  final FormController formController;

  const DynamicQrGenerator({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicQrGenerator> createState() => _DynamicQrGeneratorState();
}

class _DynamicQrGeneratorState extends State<DynamicQrGenerator> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: resolveDynamicValue(
        widget.controller.dataKey,
        'No data Found',
        widget.formController,
      ),
      builder: (context, snapshot) {
        final resolvedText = snapshot.data ?? 'No data Found';

        return QrImageView(
          data: resolvedText,
          version: widget.controller.version ?? QrVersions.auto,
          size: widget.controller.size ?? 200.0,
          backgroundColor: widget.controller.backgroundColor ?? Colors.white,
          embeddedImage: NetworkImage(widget.controller.embeddedImage ?? ''),
          padding: EdgeInsets.only(
              left: widget.controller.padding?.left?.toDouble() ?? 0,
              right: widget.controller.padding?.right?.toDouble() ?? 0,
              top: widget.controller.padding?.top?.toDouble() ?? 0,
              bottom: widget.controller.padding?.bottom?.toDouble() ?? 0),
          semanticsLabel: widget.controller.semanticsLabel ?? 'QR code',
          eyeStyle: widget.controller.eyeStyle ??
              QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
          embeddedImageStyle:
              widget.controller.embeddedImageStyle ?? QrEmbeddedImageStyle(),
          gapless: widget.controller.gapless ?? false,
          errorStateBuilder: (cxt, err) {
            return Center(
              child: Text(
                widget.controller.errorMessage ?? "Unable to generate QR code",
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      },
    );
  }
}
