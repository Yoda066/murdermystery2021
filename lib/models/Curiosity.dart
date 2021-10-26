import 'package:firebase_database/firebase_database.dart';

class Curiosity {
  String key;
  final String title;
  final String description;
  final String picture;

  Curiosity.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value['title'],
        description = snapshot.value['description'],
        picture = snapshot.value['picture'];

  toJson() {
    return {"title": title, "description": description, "picture": picture};
  }
}
