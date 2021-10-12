import 'package:firebase_database/firebase_database.dart';

class Npc {
  String key;
  final String name;
  final String backstory;
  final String image;
  final String occupation;
  final int age;
  bool unavailable = false;

  /// Contains od of palyer calling for this NPC
  String calledBy;

  Npc.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'],
        backstory = snapshot.value['backstory'],
        calledBy = snapshot.value['calledBy'],
        image = snapshot.value['image'],
        occupation = snapshot.value['occupation'],
        age = snapshot.value['age'],
        unavailable = snapshot.value['unavailable'] ?? false;

  toJson() {
    return {"name": name, "description": backstory, "image": image};
  }
}
