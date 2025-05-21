import 'package:flutter/material.dart';

class ScorePage extends StatelessWidget {
  final int score;
  final int total;
  final List<Map<String, dynamic>> wrongAnswers;

  const ScorePage({
    super.key,
    required this.score,
    required this.total,
    required this.wrongAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Score')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score: $score / $total',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Wrong Answers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: wrongAnswers.length,
                itemBuilder: (context, index) {
                  final wrong = wrongAnswers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q${index + 1}: ${wrong['question']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Your Answer: ${wrong['selected'] ?? "Not Answered"}',
                            style: const TextStyle(color: Colors.red),
                          ),
                          Text(
                            'Correct Answer: ${wrong['correct']}',
                            style: const TextStyle(color: Colors.green),
                          ),
                          Text('Explanation: ${wrong['explanation']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
