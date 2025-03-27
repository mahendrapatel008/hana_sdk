import 'package:flutter/material.dart';
import 'dynamic_flex_model.dart';

class DynamicFlex extends StatelessWidget {
  final DynamicFlexModel model;
  final List<Widget> children;

  const DynamicFlex({
    super.key,
    required this.model,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (model.isHideAndShow == true) {
      return const SizedBox.shrink();
    }

    return Flex(
      direction: model.direction ?? Axis.horizontal,
      mainAxisAlignment: model.mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: model.crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisSize: model.mainAxisSize ?? MainAxisSize.max,
      verticalDirection: model.verticalDirection ?? VerticalDirection.down,
      textDirection: model.textDirection,
      clipBehavior: model.clipBehavior ?? Clip.none,
      children: children,
    );
  }
}
