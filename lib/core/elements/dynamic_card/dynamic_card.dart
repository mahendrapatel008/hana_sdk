import 'package:flutter/material.dart';
import 'package:hana_sdk/core/elements/dynamic_card/dynamic_card_model.dart';

class DynamicCard extends StatelessWidget {
  final DynamicCardModel model;
  final Widget? formWidgets;

  const DynamicCard({
    super.key,
    required this.model,
    required this.formWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: model.elevation ?? 1.0,
      shadowColor: model.shadowColor ?? Colors.black54,
      color: model.cardColor,
      clipBehavior: model.clipBehavior ?? Clip.none,
      borderOnForeground: model.borderOnForeground ?? true,
      semanticContainer: model.semanticContainer ?? true,
      surfaceTintColor: model.surfaceTintColor ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(model.borderRadius?.topLeft.toDouble() ?? 0),
          topRight:
              Radius.circular(model.borderRadius?.topRight.toDouble() ?? 0),
          bottomLeft:
              Radius.circular(model.borderRadius?.bottomLeft.toDouble() ?? 0),
          bottomRight:
              Radius.circular(model.borderRadius?.bottomRight.toDouble() ?? 0),
        ),
      ),
      margin: EdgeInsets.only(
          left: model.margin?.left?.toDouble() ?? 0,
          right: model.margin?.right?.toDouble() ?? 0,
          top: model.margin?.top?.toDouble() ?? 0,
          bottom: model.margin?.bottom?.toDouble() ?? 0),
      child: Padding(
        padding: EdgeInsets.only(
            left: model.padding?.left?.toDouble() ?? 0,
            right: model.padding?.right?.toDouble() ?? 0,
            top: model.padding?.top?.toDouble() ?? 0,
            bottom: model.padding?.bottom?.toDouble() ?? 0),
        child: formWidgets,
      ),
    );
  }
}
