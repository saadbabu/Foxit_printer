import 'dart:convert';

class GetFormById {
  final String? formId;
  final int? formTypeId;
  final int? formNumber;
  final dynamic? isResubmitted;
  final bool? isApproved;
  final bool? isRejected;
  final bool? isFinished;
  final bool? isActive;
  final dynamic? isDeleted;
  final String? details;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<FormCollection>? formCollection;

  GetFormById({
    required this.formId,
    required this.formTypeId,
    required this.formNumber,
    required this.isResubmitted,
    required this.isApproved,
    required this.isRejected,
    required this.isFinished,
    required this.isActive,
    required this.isDeleted,
    required this.details,
    required this.fromDate,
    required this.toDate,
    required this.formCollection,
  });

  GetFormById copyWith({
    String? formId,
    int? formTypeId,
    int? formNumber,
    dynamic isResubmitted,
    bool? isApproved,
    bool? isRejected,
    bool? isFinished,
    bool? isActive,
    dynamic isDeleted,
    String? details,
    DateTime? fromDate,
    DateTime? toDate,
    List<FormCollection>? formCollection,
  }) =>
      GetFormById(
        formId: formId ?? this.formId,
        formTypeId: formTypeId ?? this.formTypeId,
        formNumber: formNumber ?? this.formNumber,
        isResubmitted: isResubmitted ?? this.isResubmitted,
        isApproved: isApproved ?? this.isApproved,
        isRejected: isRejected ?? this.isRejected,
        isFinished: isFinished ?? this.isFinished,
        isActive: isActive ?? this.isActive,
        isDeleted: isDeleted ?? this.isDeleted,
        details: details ?? this.details,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        formCollection: formCollection ?? this.formCollection,
      );

  factory GetFormById.fromRawJson(String str) =>
      GetFormById.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetFormById.fromJson(Map<String, dynamic> json) => GetFormById(
        formId: json["FormId"],
        formTypeId: json["FormTypeId"],
        formNumber: json["FormNumber"],
        isResubmitted: json["IsResubmitted"],
        isApproved: json["IsApproved"],
        isRejected: json["IsRejected"],
        isFinished: json["IsFinished"],
        isActive: json["IsActive"],
        isDeleted: json["IsDeleted"],
        details: json["Details"],
        fromDate: json["FromDate"] != null ? DateTime.parse(json["FromDate"]) : null,
        toDate: json["ToDate"] != null ? DateTime.parse(json["ToDate"]) : null,
        formCollection: json["FormCollection"] != null
            ? List<FormCollection>.from(
                json["FormCollection"].map((x) => FormCollection.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "FormId": formId,
        "FormTypeId": formTypeId,
        "FormNumber": formNumber,
        "IsResubmitted": isResubmitted,
        "IsApproved": isApproved,
        "IsRejected": isRejected,
        "IsFinished": isFinished,
        "IsActive": isActive,
        "IsDeleted": isDeleted,
        "Details": details,
        "FromDate": fromDate?.toIso8601String(),
        "ToDate": toDate?.toIso8601String(),
        "FormCollection": formCollection != null
            ? List<dynamic>.from(formCollection!.map((x) => x.toJson()))
            : null,
      };
}

class FormCollection {
  final String? key;
  final String? value;

  FormCollection({
    required this.key,
    required this.value,
  });

  FormCollection copyWith({
    String? key,
    String? value,
  }) =>
      FormCollection(
        key: key ?? this.key,
        value: value ?? this.value,
      );

  factory FormCollection.fromRawJson(String str) =>
      FormCollection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FormCollection.fromJson(Map<String, dynamic> json) => FormCollection(
        key: json["Key"],
        value: json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "Key": key,
        "Value": value,
      };
}
