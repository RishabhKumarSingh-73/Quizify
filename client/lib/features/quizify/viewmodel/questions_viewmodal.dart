import 'dart:io';

import 'package:client/core/failure/failure.dart';
import 'package:client/features/quizify/model/question_models.dart';
import 'package:client/features/quizify/repository/questions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'questions_viewmodal.g.dart';

@riverpod
class QuestionsViewmodel extends _$QuestionsViewmodel {
  late QuestionsRepository questionsRepository;
  @override
  AsyncValue<Questions>? build() {
    questionsRepository = ref.watch(questionsRepositoryProvider);
    return null;
  }

  Future<void> getQuestions({
    required String topic,
    required String difficulty,
    required String params,
    required int noOfQuestions,
  }) async {
    state = AsyncValue.loading();
    final res = await questionsRepository.getQuestions(
      topic: topic,
      difficulty: difficulty,
      params: params,
      noOfQuestions: noOfQuestions,
    );
    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncError(AppFailure(l.message), StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  Future<void> generateQuizPDF(List<Map<String, dynamic>> questions) async {
    final pdf = pw.Document();
    final status = await Permission.photos.request();

    // Section 1: Questions + Options
    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              pw.Text(
                "Quiz Questions",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              ...questions.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final q = entry.value;
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Q$index. ${q['question']}",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text("a) ${q['options']['a']}"),
                    pw.SizedBox(height: 8),
                    pw.Text("b) ${q['options']['b']}"),
                    pw.SizedBox(height: 8),
                    pw.Text("c) ${q['options']['c']}"),
                    pw.SizedBox(height: 8),
                    pw.Text("d) ${q['options']['d']}"),
                    pw.SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ],
      ),
    );

    // Section 2: Answers + Explanation
    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              pw.Text(
                "Answers & Explanations",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              ...questions.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final q = entry.value;
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Q$index. ${q['question']}",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text("Answer: ${q['correctOption']}"),
                    pw.Text("Explanation: ${q['explanation']}"),
                    pw.SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ],
      ),
    );

    // Save and open PDF

    if (status.isGranted) {
      final dir = await getExternalStorageDirectory();
      final file = File("${dir!.path}/quiz_output.pdf");
      await file.writeAsBytes(await pdf.save());
      OpenFile.open(file.path);
    }
  }
}
