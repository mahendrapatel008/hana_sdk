import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_slider/dynamic_slider_model.dart';

class DynamicSlider extends StatelessWidget {
  final DynamicSliderModel controller;
  final FormController formController;
  final VoidCallback onPressed;
  final List<Widget> formWidgets;

  const DynamicSlider({
    super.key,
    required this.controller,
    required this.formController,
    required this.onPressed,
    required this.formWidgets,
  });

  @override
  Widget build(BuildContext context) {
    CarouselSliderController carouselSliderController =
        CarouselSliderController();
    return CarouselSlider(
      items: formWidgets,
      disableGesture: controller.interactable,
      carouselController: carouselSliderController,
      options: CarouselOptions(
        initialPage: controller.initialPage ?? 0,
        autoPlay: controller.autoPlay ?? true,
        autoPlayInterval:
            controller.autoPlayInterval ?? const Duration(milliseconds: 3000),
        enableInfiniteScroll: controller.enableInfiniteScroll ?? true,
        enlargeCenterPage: controller.enlargeCenterPage ?? false,
        viewportFraction: controller.viewportFraction ?? 0.8,
        aspectRatio: controller.aspectRatio ?? 2.0,
        reverse: controller.reverse ?? false,
        pauseAutoPlayOnTouch: controller.pauseAutoPlayOnTouch ?? true,
        pauseAutoPlayInFiniteScroll:
            controller.pauseAutoPlayInFiniteScroll ?? true,
        scrollDirection: controller.scrollDirection ?? Axis.horizontal,
        pageSnapping: controller.pageSnapping ?? true,
        height: controller.height ?? 200,
        clipBehavior: controller.clipBehavior ?? Clip.hardEdge,
      ),
    );
  }
}
