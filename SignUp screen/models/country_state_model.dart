
import 'dart:convert';

List<CountryStateModel> countryStateModelFromJson(String str) => List<CountryStateModel>.from(json.decode(str).map((x) => CountryStateModel.fromJson(x)));

String countryStateModelToJson(List<CountryStateModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryStateModel {
  int? id;
  String? name;
  String? emoji;
  String? emojiU;
  List<CountryStateInfo>? state;

  CountryStateModel({
    this.id,
    this.name,
    this.emoji,
    this.emojiU,
    this.state,
  });

  factory CountryStateModel.fromJson(Map<String, dynamic> json) => CountryStateModel(
    id: json["id"],
    name: json["name"],
    emoji: json["emoji"],
    emojiU: json["emojiU"],
    state: json["state"] == null ? [] : List<CountryStateInfo>.from(json["state"]!.map((x) => CountryStateInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "emoji": emoji,
    "emojiU": emojiU,
    "state": state == null ? [] : List<dynamic>.from(state!.map((x) => x.toJson())),
  };
}

class CountryStateInfo {
  int? id;
  String? name;
  int? countryId;
  List<City>? city;

  CountryStateInfo({
    this.id,
    this.name,
    this.countryId,
    this.city,
  });

  factory CountryStateInfo.fromJson(Map<String, dynamic> json) => CountryStateInfo(
    id: json["id"],
    name: json["name"],
    countryId: json["country_id"],
    city: json["city"] == null ? [] : List<City>.from(json["city"]!.map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_id": countryId,
    "city": city == null ? [] : List<dynamic>.from(city!.map((x) => x.toJson())),
  };
}

class City {
  int? id;
  String? name;
  int? stateId;

  City({
    this.id,
    this.name,
    this.stateId,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    stateId: json["state_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state_id": stateId,
  };
}
