import 'dart:convert';

List<PayloadModel> payloadModelFromJson(String str) => List<PayloadModel>.from(json.decode(str).map((x) => PayloadModel.fromJson(x)));

String payloadModelToJson(List<PayloadModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PayloadModel {
  final String? formName;
  final int? formId;
  final List<FormTemplate>? formTemplate;
  final List<FormPage>? formPages;

  PayloadModel({
    required this.formName,
    required this.formId,
    required this.formTemplate,
    required this.formPages,
  });

  PayloadModel copyWith({
    String? formName,
    int? formId,
    List<FormTemplate>? formTemplate,
    List<FormPage>? formPages,
  }) => 
      PayloadModel(
        formName: formName ?? this.formName,
        formId: formId ?? this.formId,
        formTemplate: formTemplate ?? this.formTemplate,
        formPages: formPages ?? this.formPages,
      );

  factory PayloadModel.fromJson(Map<String, dynamic> json) => PayloadModel(
    formName: json["FormName"],
    formId: json["FormId"],
    formTemplate: json["FormTemplate"] != null ? List<FormTemplate>.from(json["FormTemplate"].map((x) => FormTemplate.fromJson(x))) : null,
    formPages: json["FormPages"] != null ? List<FormPage>.from(json["FormPages"].map((x) => FormPage.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "FormName": formName,
    "FormId": formId,
    "FormTemplate": formTemplate != null ? List<dynamic>.from(formTemplate!.map((x) => x.toJson())) : null,
    "FormPages": formPages != null ? List<dynamic>.from(formPages!.map((x) => x.toJson())) : null,
  };
}

class FormPage {
  final String? link;
  final String? name;
  final dynamic actionId;
  final String? count;

  FormPage({
    required this.link,
    required this.name,
    required this.actionId,
    required this.count,
  });

  FormPage copyWith({
    String? link,
    String? name,
    dynamic actionId,
    String? count,
  }) => 
      FormPage(
        link: link ?? this.link,
        name: name ?? this.name,
        actionId: actionId ?? this.actionId,
        count: count ?? this.count,
      );

  factory FormPage.fromJson(Map<String, dynamic> json) => FormPage(
    link: json["Link"],
    name: json["Name"],
    actionId: json["ActionId"],
    count: json["Count"],
  );

  Map<String, dynamic> toJson() => {
    "Link": link,
    "Name": name,
    "ActionId": actionId,
    "Count": count,
  };
}

class FormTemplate {
  final int? id;
  final int? formId;
  final String? controlName;
  final String? placeHolder;
  final ControlType? controlType;
  final String? controlClass;
  final dynamic controlDefaultValue;
  final String? value;
  final bool? isRequired;
  final int? sequenceOrder;
  final bool? showInGrid;
  final bool? isDetail;
  final bool? isCardApplicable;
  final String? controlViewText;
  final bool? dependor;
  final bool? isDependent;
  final String? dependentUpon;
  final String? dependencyValue;

  FormTemplate({
    required this.id,
    required this.formId,
    required this.controlName,
    required this.placeHolder,
    required this.controlType,
    required this.controlClass,
    required this.controlDefaultValue,
    required this.value,
    required this.isRequired,
    required this.sequenceOrder,
    required this.showInGrid,
    required this.isDetail,
    required this.isCardApplicable,
    required this.controlViewText,
    required this.dependor,
    required this.isDependent,
    required this.dependentUpon,
    required this.dependencyValue,
  });

  FormTemplate copyWith({
    int? id,
    int? formId,
    String? controlName,
    String? placeHolder,
    ControlType? controlType,
    String? controlClass,
    dynamic controlDefaultValue,
    String? value,
    bool? isRequired,
    int? sequenceOrder,
    bool? showInGrid,
    bool? isDetail,
    bool? isCardApplicable,
    String? controlViewText,
    bool? dependor,
    bool? isDependent,
    String? dependentUpon,
    String? dependencyValue,
  }) => 
      FormTemplate(
        id: id ?? this.id,
        formId: formId ?? this.formId,
        controlName: controlName ?? this.controlName,
        placeHolder: placeHolder ?? this.placeHolder,
        controlType: controlType ?? this.controlType,
        controlClass: controlClass ?? this.controlClass,
        controlDefaultValue: controlDefaultValue ?? this.controlDefaultValue,
        value: value ?? this.value,
        isRequired: isRequired ?? this.isRequired,
        sequenceOrder: sequenceOrder ?? this.sequenceOrder,
        showInGrid: showInGrid ?? this.showInGrid,
        isDetail: isDetail ?? this.isDetail,
        isCardApplicable: isCardApplicable ?? this.isCardApplicable,
        controlViewText: controlViewText ?? this.controlViewText,
        dependor: dependor ?? this.dependor,
        isDependent: isDependent ?? this.isDependent,
        dependentUpon: dependentUpon ?? this.dependentUpon,
        dependencyValue: dependencyValue ?? this.dependencyValue,
      );

  factory FormTemplate.fromJson(Map<String, dynamic> json) => FormTemplate(
    id: json["Id"],
    formId: json["FormId"],
    controlName: json["ControlName"],
    placeHolder: json["PlaceHolder"],
    controlType: controlTypeValues.map[json["ControlType"]],
    controlClass: json["ControlClass"],
    controlDefaultValue: json["ControlDefaultValue"],
    value: json["Value"],
    isRequired: json["IsRequired"],
    sequenceOrder: json["SequenceOrder"],
    showInGrid: json["ShowInGrid"],
    isDetail: json["IsDetail"],
    isCardApplicable: json["IsCardApplicable"],
    controlViewText: json["ControlViewText"],
    dependor: json["Dependor"],
    isDependent: json["IsDependent"],
    dependentUpon: json["DependentUpon"],
    dependencyValue: json["DependencyValue"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "FormId": formId,
    "ControlName": controlName,
    "PlaceHolder": placeHolder,
    "ControlType": controlTypeValues.reverse[controlType],
    "ControlClass": controlClass,
    "ControlDefaultValue": controlDefaultValue,
    "Value": value,
    "IsRequired": isRequired,
    "SequenceOrder": sequenceOrder,
    "ShowInGrid": showInGrid,
    "IsDetail": isDetail,
    "IsCardApplicable": isCardApplicable,
    "ControlViewText": controlViewText,
    "Dependor": dependor,
    "IsDependent": isDependent,
    "DependentUpon": dependentUpon,
    "DependencyValue": dependencyValue,
  };
}

enum ControlType {
  DATE,
  DROPDOWN,
  NUMBER,
  TEXT
}

final controlTypeValues = EnumValues({
  "date": ControlType.DATE,
  "dropdown": ControlType.DROPDOWN,
  "number": ControlType.NUMBER,
  "text": ControlType.TEXT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
