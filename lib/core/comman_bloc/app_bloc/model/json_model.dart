// class FormModel {
//   final bool status;
//   final String message;
//   final String code;
//   final String title;
//   final String subtitle;
//   final String collectionToSubmit;
//   final bool displayImportExportBtn;
//   final bool displayAddEditBtn;
//   final List<String> displayType;
//   final List<SectionModel> form;

//   FormModel({
//     required this.status,
//     required this.message,
//     required this.code,
//     required this.title,
//     required this.subtitle,
//     required this.collectionToSubmit,
//     required this.displayImportExportBtn,
//     required this.displayAddEditBtn,
//     required this.displayType,
//     required this.form,
//   });

//   factory FormModel.fromJson(Map<String, dynamic> json) {
//     return FormModel(
//       status: json['status'],
//       message: json['message'],
//       code: json['code'],
//       title: json['title'],
//       subtitle: json['subtitle'],
//       collectionToSubmit: json['collectionToSubmit'],
//       displayImportExportBtn: json['displayImportExportBtn'],
//       displayAddEditBtn: json['displayAddEditBtn'],
//       displayType: List<String>.from(json['displayType']),
//       form: (json['form'] as List)
//           .map((section) => SectionModel.fromJson(section['section']))
//           .toList(),
//     );
//   }
// }

// class SectionModel {
//   final String name;
//   final int order;
//   final int noOfClmn;
//   final List<FieldModel> fields;

//   SectionModel({
//     required this.name,
//     required this.order,
//     required this.noOfClmn,
//     required this.fields,
//   });

//   factory SectionModel.fromJson(Map<String, dynamic> json) {
//     return SectionModel(
//       name: json['name'],
//       order: json['order'],
//       noOfClmn: json['noOfClmn'],
//       fields: (json['fields'] as List)
//           .map((field) => FieldModel.fromJson(field))
//           .toList(),
//     );
//   }
// }

// class FieldModel {
//   final String label;
//   final String type;
//   final String name;
//   final String id;
//   final bool show;
//   final bool required;
//   final int order;
//   final dynamic items; // Handle different field types (slider, dropdown, etc.)

//   FieldModel({
//     required this.label,
//     required this.type,
//     required this.name,
//     required this.id,
//     required this.show,
//     required this.required,
//     required this.order,
//     this.items,
//   });

//   factory FieldModel.fromJson(Map<String, dynamic> json) {
//     return FieldModel(
//       label: json['label'],
//       type: json['type'],
//       name: json['name'],
//       id: json['id'],
//       show: json['show'],
//       required: json['required'],
//       order: json['order'],
//       items: json.containsKey('items') ? json['items'] : null,
//     );
//   }
// }
