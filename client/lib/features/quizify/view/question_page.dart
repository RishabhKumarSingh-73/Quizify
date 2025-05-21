import 'package:client/features/quizify/view/quiz_page.dart';
import 'package:client/features/quizify/viewmodel/questions_viewmodal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionPage extends ConsumerStatefulWidget {
  final int noOfQuestions;
  final List<Map<String, dynamic>> questions;
  const QuestionPage(this.noOfQuestions, this.questions, {super.key});

  @override
  ConsumerState<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends ConsumerState<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Preview")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.noOfQuestions,
              itemBuilder: (context, index) {
                final question = widget.questions[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q${index + 1}: ${question['question']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text("a) ${question['options']['a']}"),
                        const SizedBox(height: 8),
                        Text("b) ${question['options']['b']}"),
                        const SizedBox(height: 8),
                        Text("c) ${question['options']['c']}"),
                        const SizedBox(height: 8),
                        Text("d) ${question['options']['d']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to actual quiz page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => QuizPage(questions: widget.questions),
                      ),
                    );
                  },
                  child: const Text("Start Quiz"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .watch(questionsViewmodelProvider.notifier)
                        .generateQuizPDF(widget.questions);
                  },
                  child: const Text("Download Questions"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
