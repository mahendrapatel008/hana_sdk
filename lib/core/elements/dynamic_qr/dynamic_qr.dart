import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_qr/dynamic_qr_model.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRViewScreen extends StatefulWidget {
  final DynamicQRModel model;
  final VoidCallback? onPressed;
  final FormController formController;

  const QRViewScreen({
    super.key,
    required this.model,
    this.onPressed,
    required this.formController,
  });

  @override
  State<QRViewScreen> createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRViewScreen> {
  MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: controller,
              onDetect: _onQRCodeScanned, // Call with single argument
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRCodeScanned(BarcodeCapture capture) {
    final String? code = capture.barcodes.first.rawValue;
    if (code != null) {
      controller.stop(); // Stop the scanner once the QR code is scanned
      widget.formController.saveFieldValue(widget.model.name ?? '', code);
      // context.pop(); // Pop the QR scanner screen
      if (widget.onPressed != null) {
        widget.onPressed!();
      }
    }
  }
}
