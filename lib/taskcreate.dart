import 'package:flutter/material.dart';
import 'package:percolate/task.dart';
import 'package:sqflite/sqflite.dart';
import 'helpers.dart';

enum Category { Work, Home, Friend, Misc }

class TaskCreate extends StatefulWidget {
  TaskCreate(
      {super.key, required this.currentTask, required this.existingTasks});

  final Task? currentTask;
  final List<Task> existingTasks;

  @override
  State<TaskCreate> createState() => _TaskCreateState();
}

class _TaskCreateState extends State<TaskCreate> {
  final _formKey = GlobalKey<FormState>();
  Category? _selectedCategory;
  String _titleInput = '';
  String _descInput = '';

  Category? matchCategory(String? toMatch) {
    switch (toMatch) {
      case "Friend":
        return Category.Friend;
      case "Work":
        return Category.Work;
      case "Home":
        return Category.Home;
      case "Misc":
        return Category.Misc;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.currentTask ?? "NULL TASK");
    _selectedCategory = matchCategory(widget.currentTask?.category);

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Create a new task"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.words,
                readOnly: widget.currentTask != null,
                initialValue: widget.currentTask?.title,
                onSaved: (value) {
                  setState(() {
                    _titleInput = value ?? '';
                  });
                },
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  for (final task in widget.existingTasks) {
                    if (task.title == value &&
                        task.title != widget.currentTask?.title) {
                      return 'Title already in use';
                    }
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Task Title'),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                initialValue: widget.currentTask?.description,
                onSaved: (value) {
                  setState(() {
                    _descInput = value ?? '';
                  });
                },
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Description'),
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0), hintText: 'category'),
                value: _selectedCategory,
                hint: Text(
                  'Category',
                ),
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                onSaved: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (Category? value) {
                  if (value == null) {
                    return "Please select a category";
                  } else {
                    return null;
                  }
                },
                items: Category.values.map((Category cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                              child: matchCatToIcon(cat.name)
                          ),
                          TextSpan(
                            text: "   ${cat.name}",
                          ),

                        ]
                      )
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );

                      _formKey.currentState?.save();
                      Task toInsert = Task(
                          title: _titleInput,
                          description: _descInput,
                          category: _selectedCategory?.name ?? '');
                      print("INSERTING: ${toInsert}");
                      TaskProvider.insertTask(toInsert)
                          .then((value) => Navigator.pop(context, true));
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}
