import 'dart:convert';

import 'package:client/core/constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/quizify/model/question_models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'questions_repository.g.dart';

@riverpod
QuestionsRepository questionsRepository(Ref ref) {
  return QuestionsRepository();
}

class QuestionsRepository {
  Future<Either<AppFailure, Questions>> getQuestions({
    required String topic,
    required String difficulty,
    required String params,
    required int noOfQuestions,
  }) async {
    try {
      final Uri uri = Uri.parse("${QUIZ_GENERATOR_URL}/getQuiz");
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'topic': topic,
          'questions': noOfQuestions,
          'difficulty': difficulty,
          'param': params,
        }),
      );
      if (res.statusCode == 200) {
        return Right(
          Questions(
            questions:
                (jsonDecode(res.body) as List<dynamic>)
                    .map((e) => e as Map<String, dynamic>)
                    .toList(),
          ),
        );
      } else {
        return Left(AppFailure(res.body));
      }
    } on Exception catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
