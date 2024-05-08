
import 'dart:convert';
import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? message;
  int? statusCode;
  LoginDetail? data;

  LoginModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    message: json["message"],
    statusCode: json["statusCode"],
    data: json["data"] == null ? null : LoginDetail.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "statusCode": statusCode,
    "data": data?.toJson(),
  };
}

class LoginDetail {
  String? token;
  String? email;

  LoginDetail({
    this.token,
    this.email,
  });

  factory LoginDetail.fromJson(Map<String, dynamic> json) => LoginDetail(
    token: json["token"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "email": email,
  };
}


class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error(
  );

  Map<String, dynamic> toJson() => {
  };
}
