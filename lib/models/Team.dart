import 'package:firebase_database/firebase_database.dart';

class Team {
  // String key;
  final String name;

  Team.fromSnapshot(DataSnapshot snapshot)
      : /*key = snapshot.key,*/
        name = snapshot.value['name'];

  toJson() {
    return {"name": name};
  }
}
