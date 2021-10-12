import 'package:firebase_database/firebase_database.dart';

class Scene {
  String key;
  final String description;
  final String title;

  Scene(this.description, this.title);

  Scene.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        description = snapshot.value['description'],
        title = snapshot.value['title'];

  toJson() {
    return {"description": description, "title": title};
  }
}
