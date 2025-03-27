import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_rating_system/dynamic_rating_system_model.dart';

class RatingHandler extends StatefulWidget {
  final FormController formController;
  final DynamicRatingSystemModel controller;

  const RatingHandler({
    super.key,
    required this.formController,
    required this.controller,
  });

  @override
  State<RatingHandler> createState() => _RatingHandlerState();
}

class _RatingHandlerState extends State<RatingHandler> {
  double _currentRating = 0;
  String? errorMessage; // Validation error message

  @override
  void initState() {
    super.initState();
    _currentRating = widget.controller.initialRating ?? 0;

    if (widget.controller.required == true && _currentRating == 0) {
      errorMessage = widget.controller.validator ?? 'Rating is required';
      widget.formController.setValidationState(
        widget.controller.name ?? '',
        errorMessage,
      );
    }
  }

  void _validate(double rating) {
    if (widget.controller.required == true) {
      if (rating == 0) {
        errorMessage = widget.controller.validator ??
            '${widget.controller.name} is required';
      } else {
        errorMessage = null; // No error
      }
      widget.formController.setValidationState(
        widget.controller.name ?? '',
        errorMessage,
      );
    }
  }

  void _saveRating(double rating) {
    setState(() {
      _currentRating = rating;
    });

    // Save rating value in FormController
    widget.formController.saveFieldValue(
      widget.controller.name ?? '',
      rating.toString(),
    );

    // Validate after saving
    _validate(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBar.builder(
          initialRating: _currentRating,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: widget.controller.itemCount ?? 5,
          itemSize: widget.controller.itemSize ?? 40,
          itemPadding: EdgeInsets.symmetric(horizontal: 4),
          itemBuilder: (context, index) {
            return Icon(
              Icons.star,
              color: index < _currentRating.ceil() ? Colors.amber : Colors.grey,
            );
          },
          onRatingUpdate: _saveRating,
        ),
        // Display validation error if needed
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
