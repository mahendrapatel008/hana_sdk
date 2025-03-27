import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_map/dynamic_map_model.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';

class GoogleMapScreen extends StatefulWidget {
  final DynamicMapModel model;
  final FormController formController;

  const GoogleMapScreen({
    super.key,
    required this.model,
    required this.formController,
  });

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late map.GoogleMapController mapController;

  // Default latitude and longitude
  late final double latitude = widget.model.latitude ?? 37.42796133580664;
  late final double longitude = widget.model.longitude ?? -122.085749655962;

  late final map.LatLng _center;
  final Set<map.Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _center = map.LatLng(latitude, longitude);
  }

  void _onMapCreated(map.GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    // Set<map.Marker> markers = {};
    if (widget.model.markers != null) {
      for (var marker in widget.model.markers!) {
        _markers.add(
          map.Marker(
            markerId:
                map.MarkerId(marker.title), // Unique identifier for the marker
            position: map.LatLng(marker.latitude, marker.longitude),
            infoWindow: map.InfoWindow(title: marker.title), // Dynamic title
          ),
        );
      }
    }

    // Save markers to SharedPreferences
    Future<void> saveMarkersToPrefs() async {
      // final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> markersJson = _markers.map((marker) {
        return {
          'id': marker.markerId.value,
          'latitude': marker.position.latitude,
          'longitude': marker.position.longitude,
          'title': marker.infoWindow.title,
        };
      }).toList();
      SharedPrefs().markers = markersJson;
    }

    void removeMarker(String markerId) {
      setState(() {
        _markers.removeWhere((marker) => marker.markerId.value == markerId);
      });
      saveMarkersToPrefs();
    }

    void addMarker(LatLng tappedPoint) {
      setState(() {
        _markers.add(
          map.Marker(
            markerId: map.MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            infoWindow: map.InfoWindow(
              title: 'New Marker',
              snippet:
                  'Lat: ${tappedPoint.latitude}, Lng: ${tappedPoint.longitude}',
            ),
            onTap: () {
              removeMarker(tappedPoint.toString());
            },
          ),
        );
      });
      saveMarkersToPrefs();
    }

    Set<map.Circle> circles = {};
    if (widget.model.circles != null) {
      for (var circle in widget.model.circles!) {
        circles.add(
          map.Circle(
            circleId: map.CircleId(circle.circleId ?? ''),
            center: map.LatLng(
                circle.latitude ?? latitude, circle.longitude ?? longitude),
            radius: circle.radius ?? 0,
            fillColor: circle.fillColor ?? Colors.white,
            strokeColor: circle.strokeColor ?? Colors.black,
            strokeWidth: circle.strokeWidth ?? 10,
          ),
        );
      }
    }

    WeightedLatLng createWeightedLatLng(double lat, double lng, int weight) {
      return WeightedLatLng(LatLng(lat, lng), weight: weight.toDouble());
    }

    List<WeightedLatLng> createPoints(LatLng location) {
      final List<WeightedLatLng> points = <WeightedLatLng>[];
      //Can create multiple points here
      points
          .add(createWeightedLatLng(location.latitude, location.longitude, 1));
      points.add(
          createWeightedLatLng(location.latitude - 1, location.longitude, 1));
      return points;
    }

    Set<map.Heatmap> heatMaps = {};
    if (widget.model.heatmaps != null) {
      for (var heatmap in widget.model.heatmaps!) {
        LatLng heatmapLocation = LatLng(heatmap.latitude ?? 37.42796133580664,
            heatmap.longitude ?? -122.085749655962);
        heatMaps.add(
          map.Heatmap(
            heatmapId: map.HeatmapId(heatmap.heatMapId ?? ''),
            data: createPoints(heatmapLocation),
            radius: HeatmapRadius.fromPixels(heatmap.radius?.toInt() ?? 1),
            // gradient: map.HeatmapGradient( [heatmap.gradientColor]), // Color for the heat map
          ),
        );
      }
    }

    map.CameraTargetBounds? cameraBounds;
    if (widget.model.cameraTargetBounds != null) {
      cameraBounds = map.CameraTargetBounds(
        map.LatLngBounds(
          southwest: map.LatLng(
              widget.model.cameraTargetBounds!.southwest.latitude,
              widget.model.cameraTargetBounds!.southwest.longitude),
          northeast: map.LatLng(
              widget.model.cameraTargetBounds!.northeast.latitude,
              widget.model.cameraTargetBounds!.northeast.longitude),
        ),
      );
    }

    Set<map.Polygon> polygons = {};
    if (widget.model.polygons != null) {
      for (var polygon in widget.model.polygons!) {
        polygons.add(
          map.Polygon(
            polygonId: map.PolygonId(polygon.polygonId ?? ''),
            points: polygon.points ?? [],
            fillColor: polygon.fillColor ?? Colors.black,
            strokeColor: polygon.strokeColor ?? Colors.black,
            strokeWidth: polygon.strokeWidth ?? 1,
          ),
        );
      }
    }

    Set<map.Polyline> polylines = {};
    if (widget.model.polylines != null) {
      for (var polyline in widget.model.polylines!) {
        polylines.add(
          map.Polyline(
            polylineId: map.PolylineId(polyline.polylineId ?? ''),
            points: polyline.points ?? [],
            color: polyline.color ?? Colors.black,
            width: polyline.width ?? 1,
          ),
        );
      }
    }

    return map.GoogleMap(
      buildingsEnabled: widget.model.buildingsEnabled ?? true,
      myLocationButtonEnabled: widget.model.myLocationButtonEnabled ?? true,
      compassEnabled: true,
      myLocationEnabled: widget.model.myLocationEnabled ?? false,
      indoorViewEnabled: widget.model.indoorViewEnabled ?? false,
      mapToolbarEnabled: widget.model.mapToolbarEnabled ?? true,
      trafficEnabled: widget.model.trafficEnabled ?? false,
      liteModeEnabled: widget.model.liteModeEnabled ?? false,
      rotateGesturesEnabled: widget.model.rotateGesturesEnabled ?? true,
      scrollGesturesEnabled: widget.model.scrollGesturesEnabled ?? true,
      tiltGesturesEnabled: widget.model.tiltGesturesEnabled ?? true,
      zoomControlsEnabled: widget.model.zoomControlsEnabled ?? true,
      zoomGesturesEnabled: widget.model.zoomGesturesEnabled ?? true,
      heatmaps: heatMaps,
      cameraTargetBounds: cameraBounds ?? CameraTargetBounds.unbounded,
      circles: circles,
      onTap: addMarker,
      polygons: polygons,
      polylines: polylines,
      fortyFiveDegreeImageryEnabled:
          widget.model.fortyFiveDegreeImageryEnabled ?? false,
      layoutDirection: widget.model.layoutDirection,
      mapType: widget.model.mapType ?? map.MapType.normal,
      onMapCreated: _onMapCreated,
      initialCameraPosition: map.CameraPosition(
        target: _center,
        zoom: widget.model.zoom ?? 11.0,
        tilt: widget.model.tilt ?? 0.0,
        bearing: widget.model.bearing ?? 0.0,
      ),
      markers: _markers,
    );
  }
}
