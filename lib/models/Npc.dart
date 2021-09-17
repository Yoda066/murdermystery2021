import 'package:firebase_database/firebase_database.dart';

class Npc {
  String key;
  final String name;
  final String backstory;
  final String image;

  /// Contains od of palyer calling for this NPC
  String calledBy;

  Npc(this.name, this.backstory, this.image);

  Npc.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'],
        backstory = snapshot.value['backstory'],
        calledBy = snapshot.value['calledBy'],
        image = snapshot.value['image'];

  toJson() {
    return {"name": name, "description": backstory, "image": image};
  }
}
