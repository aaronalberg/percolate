import 'package:flutter/material.dart';
import 'task.dart';
import 'taskcreate.dart';
import 'helpers.dart';

class AllTasksView extends StatefulWidget {
  const AllTasksView(
      {super.key, required this.allTasks, required this.notifyParent});

  final List<Task> allTasks;
  final Function() notifyParent;

  @override
  State<AllTasksView> createState() => _AllTasksViewState();
}

class _AllTasksViewState extends State<AllTasksView> {
  void changePage(BuildContext context, Task? current, List<Task> entries) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TaskCreate(
                currentTask: current,
                existingTasks: entries,
              )),
    ).then((value) {
      widget.notifyParent();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TaskListItem> allTaskItemsSorted = [];

    List<Task> friendTasks = widget.allTasks
        .where((element) => element.category == "Friends")
        .toList();
    if (friendTasks.isNotEmpty) {
      allTaskItemsSorted.add(TaskListHeader(Category.Friends));
      allTaskItemsSorted.addAll(friendTasks);
    }

    List<Task> homeTasks =
        widget.allTasks.where((element) => element.category == "Home").toList();
    if (homeTasks.isNotEmpty) {
      allTaskItemsSorted.add(TaskListHeader(Category.Home));
      allTaskItemsSorted.addAll(homeTasks);
    }

    List<Task> workTasks =
        widget.allTasks.where((element) => element.category == "Work").toList();
    if (workTasks.isNotEmpty) {
      allTaskItemsSorted.add(TaskListHeader(Category.Work));
      allTaskItemsSorted.addAll(workTasks);
    }

    List<Task> miscTasks =
        widget.allTasks.where((element) => element.category == "Misc").toList();
    if (miscTasks.isNotEmpty) {
      allTaskItemsSorted.add(TaskListHeader(Category.Misc));
      allTaskItemsSorted.addAll(miscTasks);
    }

    return ListView.builder(
      itemCount: allTaskItemsSorted.length,
      itemBuilder: (BuildContext context, int index) {
        TaskListItem currentItem = allTaskItemsSorted[index];
        if (currentItem is Task) {
          return Card(
            color: matchCatFromString(currentItem.category).cardColor,
            child: ListTile(
              leading: matchCatStringToIcon(currentItem.category),
              title: Text(
                currentItem.title,
                style: TextStyle(fontSize: 21),
              ),
              subtitle: Text(
                currentItem.description,
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  TaskProvider.deleteTask(currentItem.title).then((value) {
                    widget.notifyParent();
                    setState(() {});
                  });
                },
              ),
              onTap: () {
                changePage(context, currentItem as Task, widget.allTasks);
              },
            ),
          );
        } else if (currentItem is TaskListHeader) {
          return Card(
            color: currentItem.category.headerColor,
            child: ListTile(
              title: Text(
                currentItem.category.name,
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        }
      },
    );
  }
}
