import 'package:client/core/utils.dart';
import 'package:client/core/widget/loader.dart';
import 'package:client/features/auth/view/login_page.dart';
import 'package:client/features/auth/viewmodels/user_viewmodel.dart';
import 'package:client/features/quizify/view/question_page.dart';
import 'package:client/features/quizify/viewmodel/questions_viewmodal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/quizify/repository/questions_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final topicController = TextEditingController();
  final numberController = TextEditingController();
  final QuestionsRepository questionsRepository = QuestionsRepository();

  String difficulty = 'Easy';
  String questionType = 'Theoretical';

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(questionsViewmodelProvider)?.isLoading == true;
    ref.listen(questionsViewmodelProvider, (_, next) {
      next!.when(
        data: (data) {
          showSnackBar(context, data.toString());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => QuestionPage(
                    int.parse(numberController.text),
                    data.toMap(),
                  ),
            ),
          );
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Quiz'),
        actions: [
          IconButton(
            onPressed: () {
              ref.watch(authViewModelProvider.notifier).signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
                (_) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body:
          isLoading
              ? Loader()
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Topic TextField
                      TextFormField(
                        controller: topicController,
                        decoration: const InputDecoration(labelText: 'Topic'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a topic';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Difficulty Radio Buttons
                      const Text('Difficulty'),
                      Column(
                        children:
                            ['Easy', 'Medium', 'Hard'].map((level) {
                              return RadioListTile(
                                title: Text(level),
                                value: level,
                                groupValue: difficulty,
                                onChanged: (value) {
                                  setState(() {
                                    difficulty = value!;
                                  });
                                },
                              );
                            }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Dropdown for question type
                      DropdownButtonFormField<String>(
                        value: questionType,
                        decoration: const InputDecoration(
                          labelText: 'Question Type',
                        ),
                        items:
                            ['Theoretical', 'Problematic', 'Both'].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            questionType = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Number of Questions TextField
                      TextFormField(
                        controller: numberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'No. of Questions',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of questions';
                          }
                          final number = int.tryParse(value);
                          if (number == null || number <= 0) {
                            return 'Enter a valid number > 0';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Generate Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .watch(questionsViewmodelProvider.notifier)
                                .getQuestions(
                                  topic: topicController.text,
                                  difficulty: difficulty,
                                  params: questionType,
                                  noOfQuestions: int.parse(
                                    numberController.text,
                                  ),
                                );
                          } else {
                            showSnackBar(context, "invalid form input");
                          }
                        },
                        child: const Text('Generate'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
