import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_map/dynamic_map.dart';
import 'package:hana_sdk/core/elements/dynamic_map/dynamic_map_model.dart';
import 'package:hana_sdk/core/model/query_dependent_widget.dart';

class DynamicMapController extends StatefulWidget {
  final DynamicMapModel controller;
  final FormController formController;

  const DynamicMapController({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicMapController> createState() => _DynamicMapControllerState();
}

class _DynamicMapControllerState extends State<DynamicMapController> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool containsAllPrerequisites = false;
    if (widget.formController.dynamicData
        .containsKey("dependentInvisibleFields")) {
      try {
        // Directly pass the Map if it's already a parsed JSON object
        final dependentInvisibleFields = DependentInvisibleFields.fromJson(
          widget.formController.dynamicData["dependentInvisibleFields"],
        );
        // Check if any of the dependentInvisibleFields contains the name
        containsAllPrerequisites = dependentInvisibleFields.fieldNames
            .contains(widget.controller.name);
      } catch (e) {
        print("Error parsing dependentInvisibleFields: $e");
      }
    }
    if (widget.controller.isHideAndShow ?? false) {
      containsAllPrerequisites = widget.controller.prerequisite != null &&
          widget.controller.prerequisite!.every((prerequisite) => widget
              .formController.savePrerequisitesNameData
              .contains(prerequisite.name));
    }
    DynamicMapModel? containsAllPrerequisitesDesign;
    // Handle hanaPrerequisiteDesign if no prerequisites matched
    if (!containsAllPrerequisites) {
      if (widget.controller.hanaPrerequisiteDesign != null &&
          widget.controller.hanaPrerequisiteDesign!.isNotEmpty) {
        final matchingPrerequisites = widget
            .formController.savePrerequisitesNameData
            .where((name) => widget.controller.hanaPrerequisiteDesign!
                .any((prerequisite) => prerequisite.name == name))
            .map((name) => widget.controller.hanaPrerequisiteDesign!
                .firstWhere((prerequisite) => prerequisite.name == name))
            .toList();

        // Check if any matching prerequisites should remove others
        for (var prerequisite in matchingPrerequisites) {
          if (prerequisite.isOtherRemove == true) {
            widget.formController.savePrerequisitesNameData
                .where((name) =>
                    name != prerequisite.name &&
                    widget.controller.hanaPrerequisiteDesign!.any(
                        (otherPrerequisite) => otherPrerequisite.name == name))
                .toList()
                .forEach((name) => widget.formController
                    .removePrerequisitesName(context, name as String?));

            final remainingPrerequisites = widget
                .controller.hanaPrerequisiteDesign!
                .where((prerequisite) => widget
                    .formController.savePrerequisitesNameData
                    .contains(prerequisite.name))
                .toList();

            if (remainingPrerequisites.isNotEmpty) {
              var style = remainingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicMapModel.fromJson(style);
              } else if (style is DynamicMapModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
            break;
          } else {
            if (matchingPrerequisites.isNotEmpty) {
              var style = matchingPrerequisites.last.style;

              if (style is Map<String, dynamic>) {
                containsAllPrerequisitesDesign =
                    DynamicMapModel.fromJson(style);
              } else if (style is DynamicMapModel) {
                containsAllPrerequisitesDesign = style;
              }
            }
          }
        }
      }
    }
    final displayController = DynamicMapModel(
      latitude: containsAllPrerequisitesDesign?.latitude ??
          widget.controller.latitude,
      longitude: containsAllPrerequisitesDesign?.longitude ??
          widget.controller.longitude,
      zoom: containsAllPrerequisitesDesign?.zoom ?? widget.controller.zoom,
      tilt: containsAllPrerequisitesDesign?.tilt ?? widget.controller.tilt,
      bearing:
          containsAllPrerequisitesDesign?.bearing ?? widget.controller.bearing,
      title: containsAllPrerequisitesDesign?.title ?? widget.controller.title,
      mapType:
          containsAllPrerequisitesDesign?.mapType ?? widget.controller.mapType,
      buildingsEnabled: containsAllPrerequisitesDesign?.buildingsEnabled ??
          widget.controller.buildingsEnabled,
      fortyFiveDegreeImageryEnabled:
          containsAllPrerequisitesDesign?.fortyFiveDegreeImageryEnabled ??
              widget.controller.fortyFiveDegreeImageryEnabled,
      myLocationButtonEnabled:
          containsAllPrerequisitesDesign?.myLocationButtonEnabled ??
              widget.controller.myLocationButtonEnabled,
      compassEnabled: containsAllPrerequisitesDesign?.compassEnabled ??
          widget.controller.compassEnabled,
      myLocationEnabled: containsAllPrerequisitesDesign?.myLocationEnabled ??
          widget.controller.myLocationEnabled,
      indoorViewEnabled: containsAllPrerequisitesDesign?.indoorViewEnabled ??
          widget.controller.indoorViewEnabled,
      mapToolbarEnabled: containsAllPrerequisitesDesign?.mapToolbarEnabled ??
          widget.controller.mapToolbarEnabled,
      trafficEnabled: containsAllPrerequisitesDesign?.trafficEnabled ??
          widget.controller.trafficEnabled,
      liteModeEnabled: containsAllPrerequisitesDesign?.liteModeEnabled ??
          widget.controller.liteModeEnabled,
      rotateGesturesEnabled:
          containsAllPrerequisitesDesign?.rotateGesturesEnabled ??
              widget.controller.rotateGesturesEnabled,
      scrollGesturesEnabled:
          containsAllPrerequisitesDesign?.scrollGesturesEnabled ??
              widget.controller.scrollGesturesEnabled,
      tiltGesturesEnabled:
          containsAllPrerequisitesDesign?.tiltGesturesEnabled ??
              widget.controller.tiltGesturesEnabled,
      zoomControlsEnabled:
          containsAllPrerequisitesDesign?.zoomControlsEnabled ??
              widget.controller.zoomControlsEnabled,
      zoomGesturesEnabled:
          containsAllPrerequisitesDesign?.zoomGesturesEnabled ??
              widget.controller.zoomGesturesEnabled,
      markers:
          containsAllPrerequisitesDesign?.markers ?? widget.controller.markers,
      circles:
          containsAllPrerequisitesDesign?.circles ?? widget.controller.circles,
      heatmaps: containsAllPrerequisitesDesign?.heatmaps ??
          widget.controller.heatmaps,
      cameraTargetBounds: containsAllPrerequisitesDesign?.cameraTargetBounds ??
          widget.controller.cameraTargetBounds,
      layoutDirection: containsAllPrerequisitesDesign?.layoutDirection ??
          widget.controller.layoutDirection,
      polygons: containsAllPrerequisitesDesign?.polygons ??
          widget.controller.polygons,
      polylines: containsAllPrerequisitesDesign?.polylines ??
          widget.controller.polylines,
      clusterManagers: containsAllPrerequisitesDesign?.clusterManagers ??
          widget.controller.clusterManagers,
      isHideAndShow: containsAllPrerequisitesDesign?.isHideAndShow ??
          widget.controller.isHideAndShow,
      prerequisite: containsAllPrerequisitesDesign?.prerequisite ??
          widget.controller.prerequisite,
      hanaPrerequisiteDesign:
          containsAllPrerequisitesDesign?.hanaPrerequisiteDesign ??
              widget.controller.hanaPrerequisiteDesign,
    );

    return !containsAllPrerequisites
        ? GoogleMapScreen(
            model: displayController,
            formController: widget.formController,
          )
        : SizedBox.shrink();
  }
}
