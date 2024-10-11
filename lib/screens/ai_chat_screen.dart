import 'package:expenses_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:groq/groq.dart';

import '../main.dart';

class AIChatScreen extends StatefulWidget {
  final List<Expense> expenses;
  const AIChatScreen({Key? key, required this.expenses}) : super(key: key);

  @override
  _AIChatScreenState createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final List<String> predefinedQuestions = [
    "What are the main categories of my expenses?",
    "How can I reduce my spending?",
    "What was my highest expense this month?",
    "Can you provide a summary of my expenses?",
  ];
  String userQuestion = '';
  final _groq = Groq(
    apiKey: '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',
    model: GroqModel.llama3_8b_8192,
  );

  @override
  void initState() {
    super.initState();
    _groq.startChat();
  }

  void _sendToAi() async {
    _groq.startChat();
    try {
      if (userQuestion.isNotEmpty) {
        // Prepare the expenses list to be sent with the question
        String expensesData = widget.expenses.map((expense) {
          return 'Title: ${expense.title}, Amount: ${expense.amount}, Date: ${expense.date}, Category: ${expense.category.name}';
        }).join('\n');

        // Combine the question and the expenses data
        String message = "$userQuestion\n\nHere are my expenses:\n$expensesData";
        print(message);

        GroqResponse response = await _groq.sendMessage(message);

        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('AI Response'),
              content: SingleChildScrollView(
                  child: Text(response.choices.first.message.content)
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        print("Sending to AI: ${widget.expenses}, Question: $userQuestion");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Question sent to AI: $userQuestion')),
        );
      }
    } on GroqException catch (error) {
      print(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask AI'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Predefined Questions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...predefinedQuestions.map((question) => Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(question),
                  onTap: () {
                    userQuestion = question; // Update the user question
                    _sendToAi(); // Automatically send the predefined question to AI
                  },
                ),
              )),
              const SizedBox(height: 20),
              const Text(
                'Or write your own question:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    userQuestion = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  hintText: 'Type your question here',
                  filled: true,
                  // fillColor: Theme.of(context).backgroundColor, // Match background color
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _sendToAi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary, // Match with your app theme
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                  ),
                  child: const Text('Send to AI', style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
