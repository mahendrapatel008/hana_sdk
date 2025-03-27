import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hana_sdk/core/model/gradient_model.dart';

Axis? stringToAxis(String? direction) {
  if (direction == null) return null;
  switch (direction) {
    case 'horizontal':
      return Axis.horizontal;
    case 'vertical':
      return Axis.vertical;
    default:
      return Axis.horizontal;
  }
}

CrossAxisAlignment? stringCrossAxis(String? direction) {
  if (direction == null) return null;
  switch (direction) {
    case 'start':
      return CrossAxisAlignment.start;
    case 'center':
      return CrossAxisAlignment.center;
    case 'end':
      return CrossAxisAlignment.end;
    default:
      return CrossAxisAlignment.start;
  }
}

WrapCrossAlignment? stringToWrapCrossAlignment(String? alignment) {
  if (alignment == null) return null;
  switch (alignment) {
    case 'start':
      return WrapCrossAlignment.start;
    case 'center':
      return WrapCrossAlignment.center;
    case 'end':
      return WrapCrossAlignment.end;
    default:
      return WrapCrossAlignment.start;
  }
}

MainAxisAlignment? stringMainAxis(String? direction) {
  if (direction == null) return null;
  switch (direction) {
    case 'start':
      return MainAxisAlignment.start;
    case 'center':
      return MainAxisAlignment.center;
    case 'end':
      return MainAxisAlignment.end;
    case 'spaceEvenly':
      return MainAxisAlignment.spaceEvenly;
    case 'spaceBetween':
      return MainAxisAlignment.spaceBetween;
    case 'spaceAround':
      return MainAxisAlignment.spaceAround;
    default:
      return MainAxisAlignment.start;
  }
}

WrapAlignment? stringToWrapAlignment(String? alignment) {
  if (alignment == null) return null;
  switch (alignment) {
    case 'start':
      return WrapAlignment.start;
    case 'end':
      return WrapAlignment.end;
    case 'center':
      return WrapAlignment.center;
    case 'spaceBetween':
      return WrapAlignment.spaceBetween;
    case 'spaceAround':
      return WrapAlignment.spaceAround;
    case 'spaceEvenly':
      return WrapAlignment.spaceEvenly;
    default:
      return WrapAlignment.start;
  }
}

Widget stringToLayout(String? direction, List<Widget> children) {
  if (direction == null) return Row(children: children);
  switch (direction) {
    case 'row':
      return Row(children: children);
    case 'column':
      return Column(children: children);
    default:
      return Row(children: children);
  }
}

MapType? stringToMapType(String? type) {
  if (type == null) return null;
  switch (type) {
    case 'satellite':
      return MapType.satellite;
    case 'terrain':
      return MapType.terrain;
    case 'hybrid':
      return MapType.hybrid;
    default:
      return MapType.normal;
  }
}

Alignment? stringToAlign(String? alignment) {
  if (alignment == null) return null;
  switch (alignment) {
    case 'topLeft':
      return Alignment.topLeft;
    case 'topRight':
      return Alignment.topRight;
    case 'topCenter':
      return Alignment.topCenter;
    case 'bottomRight':
      return Alignment.bottomRight;
    case 'bottomLeft':
      return Alignment.bottomLeft;
    case 'bottomCenter':
      return Alignment.bottomCenter;
    case 'center':
      return Alignment.center;
    case 'centerLeft':
      return Alignment.centerLeft;
    case 'centerRight':
      return Alignment.centerRight;
    default:
      return Alignment.center;
  }
}

TextAlign? stringToTextAlign(String? alignment) {
  if (alignment == null) return null;
  switch (alignment) {
    case 'left':
      return TextAlign.left;
    case 'right':
      return TextAlign.right;
    case 'center':
      return TextAlign.center;
    case 'justify':
      return TextAlign.justify;
    case 'start':
      return TextAlign.start;
    case 'end':
      return TextAlign.end;
    default:
      return TextAlign.left;
  }
}

TextOverflow? stringToTextOverflow(String? overflow) {
  if (overflow == null) return null;
  switch (overflow) {
    case 'clip':
      return TextOverflow.clip;
    case 'ellipsis':
      return TextOverflow.ellipsis;
    case 'fade':
      return TextOverflow.fade;
    case 'visible':
      return TextOverflow.visible;
    default:
      return TextOverflow.clip; // Default fallback
  }
}

FontWeight? stringToFontWeight(String? weight) {
  if (weight == null) return null;
  switch (weight) {
    case 'normal':
      return FontWeight.normal;
    case 'bold':
      return FontWeight.bold;
    case 'w100':
      return FontWeight.w100;
    case 'w200':
      return FontWeight.w200;
    case 'w300':
      return FontWeight.w300;
    case 'w400':
      return FontWeight.w400;
    case 'w500':
      return FontWeight.w500;
    case 'w600':
      return FontWeight.w600;
    case 'w700':
      return FontWeight.w700;
    case 'w800':
      return FontWeight.w800;
    case 'w900':
      return FontWeight.w900;
    default:
      return FontWeight.normal;
  }
}

TextInputType? getType({required String? string}) {
  if (string == null) return null;
  switch (string) {
    case "email":
      return TextInputType.emailAddress;
    case "number":
      return TextInputType.number;
    case "text":
      return TextInputType.text;
    case "name":
      return TextInputType.name;
    case "phone":
      return TextInputType.phone;
    case "visiblePassword":
      return TextInputType.visiblePassword;
    default:
      return TextInputType.text;
  }
}

TextInputAction? stringToTextInputAction(String? action) {
  if (action == null) return null;
  switch (action) {
    case 'none':
      return TextInputAction.none;
    case 'unspecified':
      return TextInputAction.unspecified;
    case 'done':
      return TextInputAction.done;
    case 'go':
      return TextInputAction.go;
    case 'search':
      return TextInputAction.search;
    case 'send':
      return TextInputAction.send;
    case 'next':
      return TextInputAction.next;
    case 'previous':
      return TextInputAction.previous;
    case 'continue':
      return TextInputAction.continueAction;
    case 'join':
      return TextInputAction.join;
    case 'route':
      return TextInputAction.route;
    case 'emergencyCall':
      return TextInputAction.emergencyCall;
    case 'newLine':
      return TextInputAction.newline;
    default:
      return TextInputAction.unspecified;
  }
}

BoxFit? stringToBoxFit(String? fit) {
  if (fit == null) return null;
  switch (fit) {
    case 'contain':
      return BoxFit.contain;
    case 'cover':
      return BoxFit.cover;
    case 'fill':
      return BoxFit.fill;
    case 'fitHeight':
      return BoxFit.fitHeight;
    case 'fitWidth':
      return BoxFit.fitWidth;
    case 'none':
      return BoxFit.none;
    case 'scaleDown':
      return BoxFit.scaleDown;
    default:
      return BoxFit.cover;
  }
}

GradientModel? parseGradientFromJson(Map<String, dynamic>? json) {
  if (json == null || json.isEmpty) return null;
  return GradientModel.fromJson(json);
}

Clip? stringToClip(String? clipBehavior) {
  if (clipBehavior == null) return null;
  switch (clipBehavior) {
    case 'none':
      return Clip.none;
    case 'hardEdge':
      return Clip.hardEdge;
    case 'antiAlias':
      return Clip.antiAlias;
    case 'antiAliasWithSaveLayer':
      return Clip.antiAliasWithSaveLayer;
    default:
      return Clip.none;
  }
}

TextDirection? stringToTextDirection(String? direction) {
  if (direction == null) return null;
  switch (direction) {
    case 'ltr':
      return TextDirection.ltr;
    case 'rtl':
      return TextDirection.rtl;
    default:
      return TextDirection.ltr;
  }
}

VerticalDirection? stringToVerticalDirection(String? direction) {
  if (direction == null) return null;
  switch (direction) {
    case 'up':
      return VerticalDirection.up;
    case 'down':
      return VerticalDirection.down;
    default:
      return VerticalDirection.down;
  }
}

StackFit? stringToStackFit(String? fit) {
  if (fit == null) return null;
  switch (fit) {
    case 'expand':
      return StackFit.expand;
    case 'loose':
      return StackFit.loose;
    case 'passThrough':
      return StackFit.passthrough;
    default:
      return StackFit.loose;
  }
}

Duration stringToDuration(String? duration) {
  if (duration == null) return const Duration(milliseconds: 3000);
  return Duration(milliseconds: int.tryParse(duration) ?? 3000);
}

BottomNavigationBarType? getBottomNavigationBarType(String? type) {
  if (type == null) return null;
  switch (type) {
    case "fixed":
      return BottomNavigationBarType.fixed;
    case "shifting":
      return BottomNavigationBarType.shifting;
    default:
      return BottomNavigationBarType.fixed;
  }
}

BottomNavigationBarLandscapeLayout? stringToBottomNavigationBarLayout(
    String? layout) {
  if (layout == null) return null;
  switch (layout) {
    case "centered":
      return BottomNavigationBarLandscapeLayout.centered;
    case "spread":
      return BottomNavigationBarLandscapeLayout.spread;
    case "linear":
      return BottomNavigationBarLandscapeLayout.linear;
    default:
      return BottomNavigationBarLandscapeLayout.spread;
  }
}

String formatMapData(Map<String, dynamic>? mapData) {
  if (mapData == null || mapData.isEmpty) return "";
  String mapDataString = mapData.toString();
  if (mapDataString.startsWith('{') && mapDataString.endsWith('}')) {
    mapDataString = mapDataString.substring(1, mapDataString.length - 1);
  }
  return mapDataString;
}
