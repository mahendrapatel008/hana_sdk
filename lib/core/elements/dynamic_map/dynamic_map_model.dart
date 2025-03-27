import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hana_sdk/core/conversion_helper/string_to_style.dart';
import 'package:hana_sdk/core/model/hana_prerequisite_model.dart';
import 'package:hana_sdk/core/model/prerequisite_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicMapModel {
  final double? latitude;
  final double? longitude;
  final double? zoom;
  final double? tilt;
  final double? bearing;
  final String? title;
  final String? name;
  final MapType? mapType;
  final bool? buildingsEnabled;
  final bool? fortyFiveDegreeImageryEnabled;
  final bool? myLocationButtonEnabled;
  final bool? compassEnabled;
  final bool? myLocationEnabled;
  final bool? indoorViewEnabled;
  final bool? mapToolbarEnabled;
  final bool? trafficEnabled;
  final bool? liteModeEnabled;
  final bool? rotateGesturesEnabled;
  final bool? scrollGesturesEnabled;
  final bool? tiltGesturesEnabled;
  final bool? zoomControlsEnabled;
  final bool? zoomGesturesEnabled;
  final List<MarkerData>? markers;
  final List<Circle>? circles;
  final List<HeatMap>? heatmaps;
  final LatLngBounds? cameraTargetBounds;
  final TextDirection? layoutDirection;
  final List<PolygonData>? polygons;
  final List<PolylineData>? polylines;
  final bool? clusterManagers;
  final bool? isHideAndShow;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicMapModel({
    required this.latitude,
    required this.longitude,
    this.zoom,
    this.tilt,
    this.bearing,
    this.title,
    this.name,
    this.mapType,
    this.buildingsEnabled,
    this.fortyFiveDegreeImageryEnabled,
    this.myLocationButtonEnabled,
    this.compassEnabled,
    this.myLocationEnabled,
    this.indoorViewEnabled,
    this.mapToolbarEnabled,
    this.trafficEnabled,
    this.liteModeEnabled,
    this.rotateGesturesEnabled,
    this.scrollGesturesEnabled,
    this.tiltGesturesEnabled,
    this.zoomControlsEnabled,
    this.zoomGesturesEnabled,
    this.markers,
    this.circles,
    this.heatmaps,
    this.cameraTargetBounds,
    this.layoutDirection,
    this.polygons,
    this.polylines,
    this.clusterManagers,
    this.isHideAndShow,
    this.prerequisite,
    this.hanaPrerequisiteDesign,
  });

  factory DynamicMapModel.fromJson(Map<String, dynamic> json) {
    List<MarkerData> markersList = [];
    if (json['markers'] != null) {
      markersList = List<MarkerData>.from(
        json['markers'].map((marker) => MarkerData.fromJson(marker)),
      );
    }

    // Parse circles, heatmaps, polygons, and polylines if present
    List<Circle>? circlesList = json['circles'] != null
        ? List<Circle>.from(
            json['circles'].map((circle) => Circle.fromJson(circle)),
          )
        : null;

    List<HeatMap>? heatmapsList = json['heatmaps'] != null
        ? List<HeatMap>.from(
            json['heatmaps'].map((heatmap) => HeatMap.fromJson(heatmap)),
          )
        : null;

    List<PolygonData>? polygonsList = json['polygons'] != null
        ? List<PolygonData>.from(
            json['polygons'].map((polygon) => PolygonData.fromJson(polygon)),
          )
        : null;

    List<PolylineData>? polylinesList = json['polylines'] != null
        ? List<PolylineData>.from(
            json['polylines']
                .map((polyline) => PolylineData.fromJson(polyline)),
          )
        : null;

    LatLngBounds? cameraBounds;
    if (json['cameraTargetBounds'] != null) {
      cameraBounds = LatLngBounds(
        southwest: LatLng(
          double.parse(
              (json['cameraTargetBounds']['southwest']['lat']).toString()),
          double.parse(
              (json['cameraTargetBounds']['southwest']['lng']).toString()),
        ),
        northeast: LatLng(
          double.parse(
              (json['cameraTargetBounds']['northeast']['lat']).toString()),
          double.parse(
              (json['cameraTargetBounds']['northeast']['lng']).toString()),
        ),
      );
    }
    List<PrerequisiteModel>? prerequisiteList;
    if (json['prerequisite'] != null) {
      var prerequisites = json['prerequisite'] as List;
      prerequisiteList = prerequisites
          .map((item) => PrerequisiteModel.fromJson(item))
          .toList();
    }
    List<HanaPrerequisiteModel>? hanaPrerequisiteDesignList;
    if (json['hanaPrerequisiteDesign'] != null) {
      var hanaPrerequisiteDesigns = json['hanaPrerequisiteDesign'] as List;
      hanaPrerequisiteDesignList = hanaPrerequisiteDesigns
          .map((item) => HanaPrerequisiteModel.fromJson(item))
          .toList();
    }
    return DynamicMapModel(
      latitude: double.parse((json['latitude']).toString()),
      longitude: double.parse((json['longitude']).toString()),
      zoom: double.parse((json['zoom']).toString()),
      tilt: double.parse((json['tilt']).toString()),
      bearing: double.parse((json['bearing']).toString()),
      title: json['title'],
      name: json['name'],
      mapType: stringToMapType(json['mapType']),
      buildingsEnabled: json['buildingsEnabled'],
      fortyFiveDegreeImageryEnabled: json['fortyFiveDegreeImageryEnabled'],
      myLocationButtonEnabled: json['myLocationButtonEnabled'],
      compassEnabled: json['compassEnabled'],
      myLocationEnabled: json['myLocationEnabled'],
      indoorViewEnabled: json['indoorViewEnabled'],
      mapToolbarEnabled: json['mapToolbarEnabled'],
      trafficEnabled: json['trafficEnabled'],
      liteModeEnabled: json['liteModeEnabled'],
      rotateGesturesEnabled: json['rotateGesturesEnabled'],
      scrollGesturesEnabled: json['scrollGesturesEnabled'],
      tiltGesturesEnabled: json['tiltGesturesEnabled'],
      zoomControlsEnabled: json['zoomControlsEnabled'],
      zoomGesturesEnabled: json['zoomGesturesEnabled'],
      markers: markersList,
      circles: circlesList,
      heatmaps: heatmapsList,
      cameraTargetBounds: cameraBounds,
      layoutDirection: stringToTextDirection(json['layoutDirection']),
      polygons: polygonsList,
      polylines: polylinesList,
      isHideAndShow: json["isHideAndShow"],
      clusterManagers: json['clusterManagers'],
      prerequisite: prerequisiteList,
      hanaPrerequisiteDesign: hanaPrerequisiteDesignList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
      'name': name,
      'markers': markers?.map((marker) => marker.toJson()).toList(),
      'polygons': polygons?.map((polygon) => polygon.toJson()).toList(),
      'polylines': polylines?.map((polyline) => polyline.toJson()).toList(),
      'clusterManagers': clusterManagers,
      // Add other necessary fields
    };
  }
}

// Polygon Data Model
class PolygonData {
  final String? polygonId;
  final List<LatLng>? points;
  final Color? fillColor;
  final Color? strokeColor;
  final int? strokeWidth;

  PolygonData({
    this.polygonId,
    this.points,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth,
  });

  factory PolygonData.fromJson(Map<String, dynamic> json) {
    return PolygonData(
      polygonId: json['polygonId'],
      points: (json['points'] as List)
          .map((p) => LatLng(p['lat'], p['lng']))
          .toList(),
      fillColor: hexToColor(json['fillColor']),
      strokeColor: hexToColor(json['strokeColor']),
      strokeWidth: json['strokeWidth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'polygonId': polygonId,
      // 'points': points
      //     .map((point) => {'lat': point.latitude, 'lng': point.longitude})
      //     .toList(),
      'fillColor': fillColor,
      'strokeColor': strokeColor,
      'strokeWidth': strokeWidth,
    };
  }
}

// Polyline Data Model
class PolylineData {
  final String? polylineId;
  final List<LatLng>? points;
  final Color? color;
  final int? width;

  PolylineData({
    this.polylineId,
    this.points,
    this.color,
    this.width,
  });

  factory PolylineData.fromJson(Map<String, dynamic> json) {
    return PolylineData(
      polylineId: json['polylineId'],
      points: (json['points'] as List)
          .map((p) => LatLng(p['lat'], p['lng']))
          .toList(),
      color: hexToColor(json['color']),
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'polylineId': polylineId,
      // 'points': points
      //     .map((point) => {'lat': point.latitude, 'lng': point.longitude})
      //     .toList(),
      'color': color,
      'width': width,
    };
  }
}

// HeatMap and Circle classes are already defined

class MarkerData {
  final double latitude;
  final double longitude;
  final String title;

  MarkerData({
    required this.latitude,
    required this.longitude,
    required this.title,
  });

  factory MarkerData.fromJson(Map<String, dynamic> json) {
    return MarkerData(
      latitude: json['latitude'],
      longitude: json['longitude'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
    };
  }
}

class Circle {
  final String? circleId;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final Color? fillColor;
  final Color? strokeColor;
  final int? strokeWidth;

  Circle({
    required this.circleId,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.fillColor,
    required this.strokeColor,
    required this.strokeWidth,
  });

  factory Circle.fromJson(Map<String, dynamic> json) {
    return Circle(
      circleId: json['circleId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: double.parse((json['radius']).toString()),
      fillColor: hexToColor(json['fillColor']),
      strokeColor: hexToColor(json['strokeColor']),
      strokeWidth: int.parse((json['strokeWidth']).toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circleId': circleId,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'fillColor': fillColor,
      'strokeColor': strokeColor,
      'strokeWidth': strokeWidth,
    };
  }
}

class HeatMap {
  final String? heatMapId;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final Color? gradientColor;

  HeatMap({
    required this.heatMapId,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.gradientColor,
  });

  factory HeatMap.fromJson(Map<String, dynamic> json) {
    return HeatMap(
      heatMapId: json['heatMapId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: double.parse((json['radius']).toString()),
      gradientColor: hexToColor(json['gradientColor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heatMapId': heatMapId,
      'radius': radius,
      // 'gradientColor': gradientColor.value,
    };
  }
}
