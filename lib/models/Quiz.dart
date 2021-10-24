import 'package:firebase_database/firebase_database.dart';

class Quiz {
  String key;
  final List<String> questions;
  final List<String> answers;

  Quiz.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        questions = snapshot.value['questions'],
        answers = snapshot.value['answers'];
}
