class LoggedUser {
  String key;
  final UserType type;

  LoggedUser(this.key, this.type);

  LoggedUser.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        type = UserType.values.elementAt(json['type']);

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'type': type.index,
    };
  }
}

enum UserType {
  NPC,
  PLAYER,
}
