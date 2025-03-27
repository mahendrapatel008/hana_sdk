
import 'package:hana_sdk/core/model/prerequisite_model.dart';

class CommonModel {
  final String? id;
  final String? name;
  final PrerequisiteModel? prerequisite;

  CommonModel({
    this.id = '',
    this.name = '',
    this.prerequisite,
  });

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    PrerequisiteModel? prerequisiteData;
    if (json['prerequisite'] != null) {
      var margin = json["prerequisite"];
      prerequisiteData = margin == null
          ? PrerequisiteModel()
          : PrerequisiteModel.fromJson(margin);
    }
    return CommonModel(
      id: json['id'].toString(),
      name: json['name'],
      prerequisite: prerequisiteData,
    );
  }
}
