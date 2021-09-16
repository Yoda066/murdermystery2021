import 'package:firebase_database/firebase_database.dart';

class Npc {
  String key;
  final String name;
  final String backstory;
  final String image;

  Npc(this.name, this.backstory, this.image);

  Npc.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'],
        backstory = snapshot.value['backstory'],
        image = snapshot.value['image'];

  toJson() {
    return {"name": name, "description": backstory, "image": image};
  }
}
