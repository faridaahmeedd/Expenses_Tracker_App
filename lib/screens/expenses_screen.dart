import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:groq/groq.dart';
import 'package:http/http.dart' as http;
import 'package:expenses_tracker_app/models/expense.dart';
import 'package:expenses_tracker_app/screens/add_item_screen.dart';
import 'package:expenses_tracker_app/widgets/chart/chart.dart';
import 'package:expenses_tracker_app/widgets/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  String errorMsg = '';
  var isLoading = true;
  final List<Expense> _expenses = [];
  final TextEditingController _textController = TextEditingController();
  final List<String> predefinedQuestions = [
    "Generate a budget plan for me",
    "How can I save more money?",
    "Analyze my expenses and suggest improvements",
    "What categories are my biggest spendings?"
  ];


  final _groq = Groq(
    apiKey: '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',
    model: GroqModel.llama3_8b_8192,
  );

  @override
  void initState() {
    super.initState();
    _groq.startChat();
    _loadExpenses();
  }

  void _loadExpenses() async {
    final url = Uri.https(
        'flutter-expenses-app-51adc-default-rtdb.firebaseio.com',
        'expenses-list.json');
    try {
      final response = await http.get(url);
      setState(() {
        isLoading = false;
      });
      if (response.body == 'null') {
        setState(() {
          errorMsg = 'Something went wrong! Try again.';
        });
        return;
      }
      if (response.statusCode >= 400) {
        setState(() {
          errorMsg = 'Something went wrong! Try again.';
        });
        return;
      }
      final Map<String, dynamic> loadedList = json.decode(response.body);
      setState(() {
        for (final expense in loadedList.entries) {
          _expenses.add(Expense(
            id: expense.key,
            title: expense.value['title'],
            amount: expense.value['amount'],
            date: DateTime.parse(expense.value['date']),
            category: Category.values.byName(expense.value['category']),
          ));
        }
      });
    } catch (error) {
      setState(() {
        errorMsg = 'Something went wrong! Try again.';
      });
    }
  }

  void _addExpense(Expense newExpense) async {
    final url = Uri.https(
        'flutter-expenses-app-51adc-default-rtdb.firebaseio.com',
        'expenses-list.json');
    final encodedExpense = json.encode({
      'title': newExpense.title,
      'amount': newExpense.amount,
      'date': newExpense.date.toString(),
      'category': newExpense.category.name,
    });
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: encodedExpense,
      );
      if (response.statusCode >= 400) {
        print("---------------------${response.statusCode}-----------------------");
        return;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        _expenses.add(Expense(
          id: responseData['name'],
          title: newExpense.title,
          amount: newExpense.amount,
          date: newExpense.date,
          category: newExpense.category,
        ));
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add item! Try again.'), duration: Duration(seconds: 2),));
    }
  }

  void _deleteExpense(Expense item) async {
    final url = Uri.https(
        'flutter-expenses-app-51adc-default-rtdb.firebaseio.com',
        'expenses-list/${item.id}.json');
    final index = _expenses.indexOf(item);
    setState(() {
      _expenses.remove(item);
    });
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _expenses.insert(index, item);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to delete item, Try Again..',),
          duration: Duration(seconds: 2),
        ));
      });
    }
  }

  void _openAddExpense() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SafeArea(
              minimum: const EdgeInsets.only(top: 15),
              child: AddItem(addExpenseHandler: _addExpense));
        });
  }

  void _sendChatMessageWithExpenses(String question) async {
    _groq.startChat();
    try {
      // Prepare the expenses list to be sent with the question
      String expensesData = _expenses.map((expense) {
        return 'Title: ${expense.title}, Amount: ${expense.amount}, Date: ${expense.date}, Category: ${expense.category.name}';
      }).join('\n');

      // Combine the question and the expenses data
      String message = "$question\n\nHere are my expenses:\n$expensesData";
      print(message);

      GroqResponse response = await _groq.sendMessage(message);

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('AI Response'),
            content: Text(response.choices.first.message.content),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on GroqException catch (error) {
      print(error.message);
    }
  }

  void _openChatbotDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Ask a Financial Question'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display predefined questions as a list
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: predefinedQuestions.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(predefinedQuestions[index]),
                      onTap: () {
                        final selectedQuestion = predefinedQuestions[index];
                        Navigator.of(ctx).pop(); // Close dialog
                        _sendChatMessageWithExpenses(selectedQuestion); // Send selected question with expenses
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddExpense,
            iconSize: 30.0,
          ),
        ],
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
          child: isLoading ? const Center(child: CircularProgressIndicator())
              : width < 600
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_expenses.isNotEmpty)
                Chart(
                  expenses: _expenses,
                ),
              Expanded(
                  child: ExpensesList(
                    expenses: _expenses,
                    deleteExpense: _deleteExpense,
                  )),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_expenses.isNotEmpty)
                Expanded(
                  child: Chart(
                    expenses: _expenses,
                  ),
                ),
              Expanded(
                  child: ExpensesList(
                    expenses: _expenses,
                    deleteExpense: _deleteExpense,
                  )),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _openChatbotDialog,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.chat),
      ),
    );
  }
}