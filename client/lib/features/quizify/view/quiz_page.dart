import 'dart:async';
import 'package:flutter/material.dart';
import 'score_page.dart';

class QuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  const QuizPage({super.key, required this.questions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentTime = 0;
  late Timer timer;
  Map<int, String> selectedAnswers = {};
  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    currentTime = widget.questions.length * 60;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (currentTime == 0) {
        submitQuiz();
      } else {
        setState(() => currentTime--);
      }
    });
  }

  void submitQuiz() {
    if (isSubmitted) return;
    timer.cancel();
    isSubmitted = true;
    int score = 0;
    List<Map<String, dynamic>> wrongAnswers = [];

    for (int i = 0; i < widget.questions.length; i++) {
      final question = widget.questions[i];
      final selected = selectedAnswers[i];
      if (selected == question['correct_answer']) {
        score++;
      } else {
        wrongAnswers.add({
          'question': question['question'],
          'selected': selected,
          'correct': question['correct_answer'],
          'explanation': question['explanation'],
        });
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => ScorePage(
              score: score,
              total: widget.questions.length,
              wrongAnswers: wrongAnswers,
            ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int sec = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(formatTime(currentTime))),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          final question = widget.questions[index];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Q${index + 1}: ${question['question']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ...(question['options'] as Map<String, dynamic>).entries
                    .map<Widget>((entry) {
                      return RadioListTile<String>(
                        title: Text('${entry.key}. ${entry.value}'),
                        value: entry.key,
                        groupValue: selectedAnswers[index],
                        onChanged: (val) {
                          setState(() {
                            selectedAnswers[index] = val!;
                          });
                        },
                      );
                    })
                    .toList(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: submitQuiz,
          child: const Text('Submit Quiz'),
        ),
      ),
    );
  }
}
