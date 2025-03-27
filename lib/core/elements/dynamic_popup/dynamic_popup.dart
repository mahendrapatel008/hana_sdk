import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_popup/dynamic_popup_model.dart';

class DynamicPopup extends StatelessWidget {
  final DynamicPopupModel model;
  final FormController formController;
  const DynamicPopup(
      {super.key, required this.model, required this.formController});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Initialize controller and show popup
        showDialog(
          context: context,
          barrierDismissible: true, // Can dismiss by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: model.backgroundColor ?? Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(model.borderRadius ?? 15.0),
              ),
              title: model.title != null && model.title!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        model.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : null,
              content: model.content != null
                  ? Text(
                      model.content!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.start,
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    model.cancelButtonText != null &&
                            model.cancelButtonText!.isNotEmpty
                        ? TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            child: Text(model.cancelButtonText ?? "Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        : Container(),
                    model.confirmButtonText != null &&
                            model.confirmButtonText!.isNotEmpty
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: model.buttonColor ??
                                  Colors.blue, // Button background color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              model.confirmButtonText ?? "OK",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Handle confirmation logic here
                            },
                          )
                        : Container(),
                  ],
                ),
              ],
            );
          },
        );
      },
      child: const Text('Show Popup'),
    );
  }
}
