import 'package:expenses_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';

var formatter = DateFormat.yMd('en');

class AddItem extends StatefulWidget {
  final Function addExpenseHandler;

  const AddItem({Key? key, required this.addExpenseHandler}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String _title = '';
  String _amount = '';
  DateTime _dateController = DateTime.now();
  TimeOfDay _timeController = TimeOfDay.now();
  String _dateString = '';
  String _timeString = '';
  Category _category = Category.Food;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final keyBoardSpace = MediaQuery.of(context)
        .viewInsets
        .bottom; //this line is added to fix the bottom overflow issue  from the keyboard
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(10, 0, 10, keyBoardSpace),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => _formKey.currentState?.reset(),
                style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.only(right: 10)
                  ),
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.only(left: 30)
                  ),
                child: Icon(
                  Icons.close,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
            ],
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusColor: colorScheme.primary,
                      labelText: 'Title',
                    ),
                    onSaved: (value) {
                      _title = value!;
                    },
                    validator: (value) {
                      if (value == null ||
                          value.trim().length >= 15 ||
                          value.trim().length <= 1) {
                        return 'Title must be between 1 and 15 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 15),
                    decoration: const InputDecoration(
                      suffixText: 'EGP',
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                    ),
                    onSaved: (value) {
                      _amount = value!;
                    },
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value!.startsWith('-')) {
                        return 'Amount must be a positive value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                    items: Category.values.map((Category category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(categoryIcons[category],
                                color: colorScheme.primary),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(category.toString().split('.').last),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (Category? category) {
                      setState(() {
                        _category = category!;
                      });
                    },
                    value: _category,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          final now = DateTime.now();
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime(now.year - 2, now.month, now.day),
                              lastDate:
                                  DateTime(now.year + 2, now.month, now.day),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: isDarkMode
                                      ? ThemeData.dark().copyWith(
                                          colorScheme: ColorScheme.dark(
                                            primary: darkColorScheme.primary,
                                          ),
                                        )
                                      : ThemeData.light().copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: colorScheme.primary,
                                          ),
                                        ),
                                  child: child!,
                                );
                              }).then((selectedDate) {
                            //this function will be executed once the date is selected
                            setState(() {
                              _dateController = selectedDate!;
                              _dateString =
                                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                            });
                          });
                        },
                        icon: Icon(Icons.calendar_today_rounded,
                            color: colorScheme.primary, size: 18),
                        label: Text(_dateString == '' ? "Date" : _dateString,
                            style: TextStyle(
                                color: isDarkMode
                                    ? darkColorScheme.secondary
                                    : colorScheme.secondary,
                                fontSize: 18)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton.icon(
                        onPressed: () {
                          showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: isDarkMode
                                      ? ThemeData.dark().copyWith(
                                          colorScheme: ColorScheme.dark(
                                            primary: darkColorScheme.primary,
                                          ),
                                        )
                                      : ThemeData.light().copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: colorScheme.primary,
                                          ),
                                        ),
                                  child: child!,
                                );
                              }).then((selectedTime) {
                            //this function will be executed once the date is selected
                            setState(() {
                              _timeController = selectedTime!;
                              _timeString =
                                  "${selectedTime.hour}:${selectedTime.minute}";
                            });
                          });
                        },
                        icon: Icon(Icons.lock_clock,
                            color: colorScheme.primary, size: 18),
                        label: Text(_timeString == '' ? "Time" : _timeString,
                            style: TextStyle(
                                color: isDarkMode
                                    ? darkColorScheme.secondary
                                    : colorScheme.secondary,
                                fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          TextButton.icon(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(10)),
              backgroundColor: MaterialStateProperty.all(colorScheme.primary),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            onPressed: () {
              _formKey.currentState!.save();
              if (_dateString == '') {
                print('please input all fields');
                return;
              }
              widget.addExpenseHandler(Expense(
                id: ' ',
                title: _title,
                amount: double.parse(_amount),
                date: _dateController,
                category: _category,
                // time: TimeOfDay.expense.value['time'])
              ));
              Navigator.pop(context);
            },
            icon: Icon(Icons.add, color: colorScheme.onPrimary, size: 19),
            label: Text(
              'Add',
              style: TextStyle(fontSize: 15, color: colorScheme.onPrimary),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
