import 'package:flutter/material.dart';

import '../../model/hana_prerequisite_model.dart';
import '../../model/prerequisite_model.dart';

class DynamicFlexModel {
  final String? name;
  final String? id;
  final Axis?  direction;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final VerticalDirection? verticalDirection;
  final TextDirection? textDirection;
  final Clip? clipBehavior;
  final bool? isHideAndShow;
  final dynamic items;
  final List<PrerequisiteModel>? prerequisite;
  final List<HanaPrerequisiteModel>? hanaPrerequisiteDesign;

  DynamicFlexModel( {
    required this.direction,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.textDirection,
    this.clipBehavior,
    this.isHideAndShow,
    this.items,
    this.hanaPrerequisiteDesign,
    this.prerequisite,
    this.id,
    this.name,
  });

  factory DynamicFlexModel.fromJson(Map<String, dynamic> json) {
    return DynamicFlexModel(
      direction: json['direction'] == 'horizontal' ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: json['mainAxisAlignment'] != null
          ? MainAxisAlignment.values[json['mainAxisAlignment']]
          : MainAxisAlignment.start,
      crossAxisAlignment: json['crossAxisAlignment'] != null
          ? CrossAxisAlignment.values[json['crossAxisAlignment']]
          : CrossAxisAlignment.center,
      mainAxisSize: json['mainAxisSize'] != null
          ? MainAxisSize.values[json['mainAxisSize']]
          : MainAxisSize.max,
      verticalDirection: json['verticalDirection'] != null
          ? VerticalDirection.values[json['verticalDirection']]
          : VerticalDirection.down,
      textDirection: json['textDirection'] != null
          ? (json['textDirection'] == "rtl" ? TextDirection.rtl : TextDirection.ltr)
          : null,
      clipBehavior: json['clipBehavior'] != null
          ? Clip.values[json['clipBehavior']]
          : Clip.none,
      isHideAndShow: json['isHideAndShow'] ?? false,
      items: json['items'] ?? [],
      name: json['name'] ?? "",
      id: json['id'] ?? "",

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direction': direction == Axis.horizontal ? 'horizontal' : 'vertical',
      'mainAxisAlignment': mainAxisAlignment?.index,
      'crossAxisAlignment': crossAxisAlignment?.index,
      'mainAxisSize': mainAxisSize?.index,
      'verticalDirection': verticalDirection?.index,
      'textDirection': textDirection == TextDirection.rtl ? "rtl" : "ltr",
      'clipBehavior': clipBehavior?.index,
      'isHideAndShow': isHideAndShow,
      'items': items,
      'name': name,
      'id': id
    };
  }
}
