import 'dart:convert';

GoogleAutocompleteModel autocompletePlaceFromJson(String str) =>
    GoogleAutocompleteModel.fromJson(json.decode(str));

String autocompletePlaceToJson(GoogleAutocompleteModel data) =>
    json.encode(data.toJson());

class GoogleAutocompleteModel {
  List<GoogleAutocompletePredictionModel> predictions;
  String status;

  GoogleAutocompleteModel({this.predictions = const [], this.status = ""});

  factory GoogleAutocompleteModel.fromJson(Map<String, dynamic> json) =>
      GoogleAutocompleteModel(
        predictions: json["predictions"] == null
            ? []
            : List<GoogleAutocompletePredictionModel>.from(
                json["predictions"]!.map(
                  (x) => GoogleAutocompletePredictionModel.fromJson(x),
                ),
              ),
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "predictions": predictions.isEmpty
        ? []
        : List<dynamic>.from(predictions.map((x) => x.toJson())),
    "status": status,
  };
}

class GoogleAutocompletePredictionModel {
  String description;
  String placeId;
  String reference;
  GoogleAutocompleteStructuredFormattingModel structuredFormatting;
  List<String> types;

  GoogleAutocompletePredictionModel({
    this.description = "",
    this.placeId = "",
    this.reference = "",
    GoogleAutocompleteStructuredFormattingModel? structuredFormatting,
    this.types = const [],
  }) : structuredFormatting =
           structuredFormatting ??
           GoogleAutocompleteStructuredFormattingModel();

  factory GoogleAutocompletePredictionModel.fromJson(
    Map<String, dynamic> json,
  ) => GoogleAutocompletePredictionModel(
    description: json["description"] ?? "",
    placeId: json["place_id"] ?? "",
    reference: json["reference"] ?? "",
    structuredFormatting: json["structured_formatting"] == null
        ? GoogleAutocompleteStructuredFormattingModel()
        : GoogleAutocompleteStructuredFormattingModel.fromJson(
            json["structured_formatting"],
          ),
    types: json["types"] == null
        ? []
        : List<String>.from(json["types"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "place_id": placeId,
    "reference": reference,
    "structured_formatting": structuredFormatting.toJson(),
    "types": types.isEmpty ? [] : List<dynamic>.from(types.map((x) => x)),
  };
}

class GoogleAutocompleteStructuredFormattingModel {
  String mainText;
  String secondaryText;

  GoogleAutocompleteStructuredFormattingModel({
    this.mainText = "",
    this.secondaryText = "",
  });

  factory GoogleAutocompleteStructuredFormattingModel.fromJson(
    Map<String, dynamic> json,
  ) => GoogleAutocompleteStructuredFormattingModel(
    mainText: json["main_text"] ?? "",
    secondaryText: json["secondary_text"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "main_text": mainText,
    "secondary_text": secondaryText,
  };
}
