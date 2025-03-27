
import 'package:hana_sdk/core/elements/dynamic_image/dynamic_image_model.dart';
import 'package:hana_sdk/core/elements/dynamic_text/dynamic_text_model.dart';

class DynamicAppbarModel {
  final String? id;
  final String? name;
  final DynamicTextModel? title;
  final DynamicImageModel? backImgUrl;
  final List<dynamic>? items;

  DynamicAppbarModel({
    this.id,
    this.name,
    this.title,
    this.backImgUrl,
    this.items,
  });

 // Correct toJson() method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title?.toJson(), // Ensure you call toJson on title
      'backImgUrl': backImgUrl?.toJson(), // Ensure you call toJson on backImgUrl
      'items': items,
    };
  }

  factory DynamicAppbarModel.fromJson(Map<String, dynamic> json) {
   
    return DynamicAppbarModel(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      title: json["title"] != null
          ? DynamicTextModel.fromJson(json["title"] as Map<String, dynamic>)
          : DynamicTextModel(label: 'Home', type: 'text'),
      backImgUrl: json["backImgUrl"] != null
          ? DynamicImageModel.fromJson(
              json["backImgUrl"] as Map<String, dynamic>)
          : null,
      items: json.containsKey('items') ? json['items'] : null,
    );
  }
}
