import 'package:flutter/material.dart';
import 'task.dart';
import 'taskcreate.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Percolate'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Icon matchCatToIcon(String cat) {
    switch (cat) {
      case "Friend":
        return Icon(Icons.people);
      case "Home":
        return Icon(Icons.house);
      case "Work":
        return Icon(Icons.work);
      default:
        return Icon(Icons.lightbulb);
    }
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Task>>(
          future: TaskProvider.getAllTasks(),
          builder: (context, snapshot) {
            print("ABC");
            if (snapshot.connectionState == ConnectionState.done) {
              print("DEF");
              // future complete
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              print("GHI");
              // future complete with no error and has data
              List<Task> entries = snapshot.requireData;
              return entries.length > 0
                  ? ListView.builder(
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  Task current = entries[index];
                  return Card(
                      color: index % 2 == 0 ? Colors.white60 : Colors.white70,
                      child: ListTile(
                        leading: matchCatToIcon(current.category),
                        title: Text('Item ${current.title}'),
                        subtitle: Text(current.description),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            TaskProvider.deleteTask(current.title).then((value) {
                              setState(() {

                              });
                            });
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TaskCreate()),
                          );
                        },
                      ),
                  );
                },
              )
                  : const Center(child: Text('No items'));
            }
            // return loading widget while connection state is active
            else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskCreate()),
          ).then((value) {
            setState(() {

            });
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}