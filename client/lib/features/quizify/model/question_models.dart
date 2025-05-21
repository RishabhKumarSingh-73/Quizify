// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Questions {
  final List<Map<String, dynamic>> questions;

  Questions({required this.questions});

  List<Map<String, dynamic>> toMap() {
    return questions;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Questions(questions: $questions)';

  @override
  bool operator ==(covariant Questions other) {
    if (identical(this, other)) return true;

    return listEquals(other.questions, questions);
  }

  @override
  int get hashCode => questions.hashCode;
}
