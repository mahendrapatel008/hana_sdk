import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_container/dynamic_container_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicContainer extends StatelessWidget {
  final DynamicContainerModel model;
  final Widget? formWidgets;
  final VoidCallback? onPressed;
  final FormController formController;

  const DynamicContainer({
    super.key,
    required this.model,
    required this.formWidgets,
    this.onPressed,
    required this.formController,
  });

  @override
  Widget build(BuildContext context) {
    if (model.dataKey != null && model.dataKey!.isNotEmpty) {
      return FutureBuilder<String>(
          future: resolveDynamicValue(
            model.dataKey,
            model.imgUrl ?? model.url,
            formController,
          ),
          builder: (context, snapshot) {
            final resolvedText = snapshot.data ?? model.imgUrl ?? '...';

            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;
            double? width = model.width?.toDouble();
            double? height = model.height?.toDouble();
            width = width == 2000 ? screenWidth : width;
            height = height == 2000 ? screenHeight : height;

            return Container(
              width: width,
              height: height,
              margin: EdgeInsets.only(
                  left: model.margin?.left?.toDouble() ?? 0,
                  right: model.margin?.right?.toDouble() ?? 0,
                  top: model.margin?.top?.toDouble() ?? 0,
                  bottom: model.margin?.bottom?.toDouble() ?? 0),
              padding: EdgeInsets.only(
                  left: model.padding?.left?.toDouble() ?? 0,
                  right: model.padding?.right?.toDouble() ?? 0,
                  top: model.padding?.top?.toDouble() ?? 0,
                  bottom: model.padding?.bottom?.toDouble() ?? 0),
              decoration: BoxDecoration(
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.greenAccent,
                //     offset: const Offset(
                //       5.0,
                //       5.0,
                //     ),
                //     blurRadius: 10.0,
                //     spreadRadius: 2.0,
                //   ), //BoxShadow
                //   BoxShadow(
                //     color: Colors.white,
                //     offset: const Offset(0.0, 0.0),
                //     blurRadius: 0.0,
                //     spreadRadius: 0.0,
                //   ), //BoxShadow
                // ],
                image: model.imgUrl != null && model.imgUrl!.isNotEmpty
                    ? DecorationImage(
                        fit: model.fit,
                        image:
                            model.dataKey != null && model.dataKey!.isNotEmpty
                                ? NetworkImage(resolvedText)
                                : (model.imgUrl ?? '').isEmpty
                                    ? const AssetImage('assets/images/Logo.png')
                                        as ImageProvider
                                    : NetworkImage(model.imgUrl ?? ''),
                        opacity: model.imageOpacity ?? 1,
                      )
                    : null,
                gradient: model.gradient != null
                    ? model.gradient?.type == 'sweep'
                        ? SweepGradient(
                            colors: model.gradient?.colors
                                    ?.whereType<Color>()
                                    .toList() ??
                                [hexToColor("#FFFFFF") ?? Colors.black],
                            center: model.gradient?.begin ??
                                Alignment.center, // Center of the sweep
                            startAngle: model.gradient?.startAngle ??
                                0.0, // Start angle of the sweep
                            endAngle: model.gradient?.endAngle ??
                                3.14, // End angle of the sweep (π for half-circle)
                          )
                        : model.gradient?.type == 'radial'
                            ? RadialGradient(
                                colors: model.gradient?.colors
                                        ?.whereType<Color>()
                                        .toList() ??
                                    [hexToColor("#FFFFFF") ?? Colors.black],
                                center: model.gradient?.center ??
                                    Alignment
                                        .center, // Center point of the radial gradient
                                radius: model.gradient?.radius ??
                                    0.8, // Size of the radial gradient
                              )
                            : LinearGradient(
                                colors: model.gradient?.colors
                                        ?.whereType<Color>()
                                        .toList() ??
                                    [hexToColor("#FFFFFF") ?? Colors.black],
                                begin: model.gradient?.begin ??
                                    Alignment
                                        .topLeft, // Starting point of the gradient
                                end: model.gradient?.end ??
                                    Alignment
                                        .bottomRight, // Ending point of the gradient
                              )
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(model.radius?.topLeft.toDouble() ?? 0),
                  topRight:
                      Radius.circular(model.radius?.topRight.toDouble() ?? 0),
                  bottomLeft:
                      Radius.circular(model.radius?.bottomLeft.toDouble() ?? 0),
                  bottomRight: Radius.circular(
                      model.radius?.bottomRight.toDouble() ?? 0),
                ),
                color: model.gradient != null
                    ? null
                    : model.backGroundColor ?? Colors.transparent,
                border: model.showBorder ?? false
                    ? Border.all(
                        color: model.borderColor ??
                            hexToColor("#FFFFFF") ??
                            Colors.black,
                        width: model.borderWidth?.toDouble() ?? 1)
                    : null,
              ),
              child: model.isCenter ?? false
                  ? Center(child: formWidgets)
                  : formWidgets,
            );
          });
    } else {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      double? width = model.width?.toDouble();
      double? height = model.height?.toDouble();
      width = width == 2000 ? screenWidth : width;
      height = height == 2000 ? screenHeight : height;

      return Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(
            left: model.margin?.left?.toDouble() ?? 0,
            right: model.margin?.right?.toDouble() ?? 0,
            top: model.margin?.top?.toDouble() ?? 0,
            bottom: model.margin?.bottom?.toDouble() ?? 0),
        padding: EdgeInsets.only(
            left: model.padding?.left?.toDouble() ?? 0,
            right: model.padding?.right?.toDouble() ?? 0,
            top: model.padding?.top?.toDouble() ?? 0,
            bottom: model.padding?.bottom?.toDouble() ?? 0),
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.greenAccent,
          //     offset: const Offset(
          //       5.0,
          //       5.0,
          //     ),
          //     blurRadius: 10.0,
          //     spreadRadius: 2.0,
          //   ), //BoxShadow
          //   BoxShadow(
          //     color: Colors.white,
          //     offset: const Offset(0.0, 0.0),
          //     blurRadius: 0.0,
          //     spreadRadius: 0.0,
          //   ), //BoxShadow
          // ],
          image: model.imgUrl != null && model.imgUrl!.isNotEmpty
              ? DecorationImage(
                  fit: model.fit,
                  image: model.dataKey != null && model.dataKey!.isNotEmpty
                      ? NetworkImage(model.imgUrl ?? '')
                      : (model.imgUrl ?? '').isEmpty
                          ? const AssetImage('assets/images/Logo.png')
                              as ImageProvider
                          : NetworkImage(model.imgUrl!),
                  opacity: model.imageOpacity ?? 1,
                )
              : null,
          gradient: model.gradient != null
              ? model.gradient?.type == 'sweep'
                  ? SweepGradient(
                      colors:
                          model.gradient?.colors?.whereType<Color>().toList() ??
                              [hexToColor("#FFFFFF") ?? Colors.black],
                      center: model.gradient?.begin ??
                          Alignment.center, // Center of the sweep
                      startAngle: model.gradient?.startAngle ??
                          0.0, // Start angle of the sweep
                      endAngle: model.gradient?.endAngle ??
                          3.14, // End angle of the sweep (π for half-circle)
                    )
                  : model.gradient?.type == 'radial'
                      ? RadialGradient(
                          colors: model.gradient?.colors
                                  ?.whereType<Color>()
                                  .toList() ??
                              [hexToColor("#FFFFFF") ?? Colors.black],
                          center: model.gradient?.center ??
                              Alignment
                                  .center, // Center point of the radial gradient
                          radius: model.gradient?.radius ??
                              0.8, // Size of the radial gradient
                        )
                      : LinearGradient(
                          colors: model.gradient?.colors
                                  ?.whereType<Color>()
                                  .toList() ??
                              [hexToColor("#FFFFFF") ?? Colors.black],
                          begin: model.gradient?.begin ??
                              Alignment
                                  .topLeft, // Starting point of the gradient
                          end: model.gradient?.end ??
                              Alignment
                                  .bottomRight, // Ending point of the gradient
                        )
              : null,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(model.radius?.topLeft.toDouble() ?? 0),
            topRight: Radius.circular(model.radius?.topRight.toDouble() ?? 0),
            bottomLeft:
                Radius.circular(model.radius?.bottomLeft.toDouble() ?? 0),
            bottomRight:
                Radius.circular(model.radius?.bottomRight.toDouble() ?? 0),
          ),
          color: model.gradient != null
              ? null
              : model.backGroundColor ?? Colors.transparent,
          border: model.showBorder ?? false
              ? Border.all(
                  color: model.borderColor ??
                      hexToColor("#FFFFFF") ??
                      Colors.black,
                  width: model.borderWidth?.toDouble() ?? 1)
              : null,
        ),
        child:
            model.isCenter ?? false ? Center(child: formWidgets) : formWidgets,
      );
    }
  }
}
