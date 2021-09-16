import 'package:firebase_database/firebase_database.dart';

class Npc {
  String key;
  final String name;
  final String description;
  final String image;

  Npc(this.name, this.description, this.image);

  Npc.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'],
        description = snapshot.value['description'],
        image = snapshot.value['image'];

  toJson() {
    return {"name": name, "description": description, "image": image};
  }

  static List<Npc> fetchAll() {
    return [
      Npc("Serif", 'Serif je vladca', "image"),
      Npc("Serif", 'Serif je vladca', "image"),
      Npc("Serif", 'Serif je vladca', "image"),
    ];
  }
}
