class NotificationModel {
  String? message;
  int? statusCode;
  NotificationDetailModel? data;

  NotificationModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        message: json["message"],
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : NotificationDetailModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "statusCode": statusCode,
        "data": data?.toJson(),
      };
}

class NotificationDetailModel {
  List<NotificationListItem>? list;
  Pagination? pagination;

  NotificationDetailModel({
    this.list,
    this.pagination,
  });

  factory NotificationDetailModel.fromJson(Map<String, dynamic> json) => NotificationDetailModel(
        list: json["list"] == null
            ? []
            : List<NotificationListItem>.from(json["list"]!.map((x) => NotificationListItem.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class NotificationListItem {
  int? notificationId;
  int? gameId;
  String? title;
  String? description;
  String? leagueName;
  int? type;
  int? leagueId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Game? game;

  NotificationListItem({
    this.notificationId,
    this.gameId,
    this.title,
    this.description,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.game,
    this.leagueId,
    this.leagueName,
  });

  factory NotificationListItem.fromJson(Map<String, dynamic> json) => NotificationListItem(
        notificationId: json["notificationId"],
        gameId: json["gameId"],
        title: json["title"],
        description: json["description"],
        type: json["type"],
        leagueId: json["leagueId"],
        leagueName: json["leagueName"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        game: json["game"] == null ? null : Game.fromJson(json["game"]),
      );

  Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "gameId": gameId,
        "title": title,
        "description": description,
        "type": type,
        "leagueId": leagueId,
        "leagueName": leagueName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "game": game?.toJson(),
      };
}

class Game {
  int? id;
  String? profileImage;
  String? name;
  String? difficulty;
  dynamic gameLength;
  int? gameId;
  String? eliminationType;
  String? gameType;
  String? gameRule;
  String? raceTo;
  List<Player>? player;

  Game({
    this.id,
    this.profileImage,
    this.name,
    this.gameId,
    this.eliminationType,
    this.gameType,
    this.gameRule,
    this.difficulty,
    this.gameLength,
    this.raceTo,
    this.player,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json["id"],
        name: json["name"],
        profileImage: json["profileImage"],
        difficulty: json["difficulty"],
        gameLength: json["gameLength"],
        gameId: json["gameId"],
        eliminationType: json["eliminationType"],
        gameType: json["gameType"],
        gameRule: json["gameRule"],
        raceTo: json["raceTo"],
        player: json["player"] == null ? [] : List<Player>.from(json["player"]!.map((x) => Player.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gameId": gameId,
        "difficulty": difficulty,
        "gameLength": gameLength,
        "eliminationType": eliminationType,
        "gameType": gameType,
        "gameRule": gameRule,
        "raceTo": raceTo,
        "player": player == null ? [] : List<dynamic>.from(player!.map((x) => x.toJson())),
      };
}

class Player {
  String? name;
  String? email;
  String? profileImage;

  Player({
    this.name,
    this.email,
    this.profileImage,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        name: json["name"],
        email: json["email"],
        profileImage: json["profileImage"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "profileImage": profileImage,
      };
}

class Pagination {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Pagination({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        count: json["count"],
        perPage: json["perPage"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "count": count,
        "perPage": perPage,
        "currentPage": currentPage,
        "totalPages": totalPages,
      };
}
