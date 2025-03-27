import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_onboarding/dynamic_onboarding_model.dart';

class DynamicOnboardingSlider extends StatelessWidget {
  final DynamicOnboardingSlideModel controller;
  final FormController formController;
  final VoidCallback onPressed;
  final List<Widget> formWidgets;

  const DynamicOnboardingSlider({
    super.key,
    required this.controller,
    required this.formController,
    required this.onPressed,
    required this.formWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
        finishButtonText: controller.finishButtonText,
        onFinish: onPressed,
        skipFunctionOverride: onPressed,
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: controller.controllerColor,
        ),
        skipTextButton: controller.skipButtonText == null
            ? null
            : Text(
                controller.skipButtonText ?? 'Skip',
                style: TextStyle(
                  fontSize: controller.skipTextSize?.toDouble() ?? 12,
                  color: controller.skipTextColor,
                  fontWeight: controller.skipFontWeight,
                ),
              ),
        // trailing: Text(
        //   'Login',
        //   style: TextStyle(
        //     fontSize: controller.loginTextSize?.toDouble() ?? 12,
        //     color: controller.loginTextColor,
        //     fontWeight: controller.loginFontWeight,
        //   ),
        // ),
        // // trailingFunction: controller.onLogin,

        controllerColor: controller.controllerColor,
        totalPage: controller.items?.length ?? 0,
        headerBackgroundColor: controller.headerBackgroundColor ?? Colors.black,
        pageBackgroundColor: controller.pageBackgroundColor,
        speed: controller.speed?.toDouble() ?? 1,
        background: List.generate(
          formWidgets.length,
          (index) => Container(), // Creating a plain container
        ),
        pageBodies: formWidgets
        // controller.slides
        //     .map((slide) => buildSlidePage(slide, context))
        //     .toList(),
        );
  }

//   Widget buildSlidePage(OnboardingSlide slide, BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.symmetric(horizontal: 40),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.network(
//               slide.imageUrl,
//               height: 400,
//               width: 400,
//               fit: BoxFit.cover,
//             ),
//             Text(
//               slide.title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: controller.controllerColor,
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               slide.description,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.black26,
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Image.network(
//               slide.imageUrl,
//               height: 400,
//               width: 400,
//               fit: BoxFit.cover,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}
