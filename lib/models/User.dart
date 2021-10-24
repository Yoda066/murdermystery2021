class LoggedUser {
  String key;
  String name;
  final UserType type;

  LoggedUser(this.key, this.name, this.type);

  LoggedUser.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        name = json['name'],
        type = UserType.values.elementAt(json['type']);

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'type': type.index,
    };
  }
}

enum UserType {
  NPC,
  PLAYER,
}
