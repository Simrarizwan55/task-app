import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_app/providers/task_provider.dart';
import 'package:task_app/widgets/primary_button.dart';
import 'add_task_screen.dart';
import 'edit_task.dart';
import 'models/task_model.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    // context.read<TaskProvider>().fetchTasks();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.read<TaskProvider>().fetchTasks());
  }

  int _value = 0;

  final List<String> statuses = [
    "All",
    "Completed",
    "Incomplete",
  ];

  final List<OrderBy> sortingOptions = [
    OrderBy.all,
    OrderBy.ascending,
    OrderBy.descending,
  ];
  OrderBy orderby = OrderBy.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TO DO LIST"),
      ),
      body: Consumer<TaskProvider>(builder: (__, taskProvider, _) {
        // final tasks = taskProvider.getTasks();
        // final tasks = taskProvider.getTasks(isCompleted: isCompleted);
        List<TaskModel> tasks;
        if (_value == 1) {
          tasks = taskProvider.getTasks(isCompleted: true, orderBy: orderby);
        } else if (_value == 2) {
          tasks = taskProvider.getTasks(isCompleted: false, orderBy: orderby);
        } else {
          tasks = taskProvider.getTasks(orderBy: orderby);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 12.0,
              children: statuses.map((String status) {
                final int index = statuses.indexOf(status);
                return ChoiceChip(
                  pressElevation: 0.0,
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey[100],
                  label: Text(
                    status,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  selected: _value == index,
                  onSelected: (bool selected) {
                    setState(() {
                      _value = selected ? index : _value;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(
              height: 15,
            ),
            DropdownMenu<OrderBy>(
              initialSelection: orderby,
              onSelected: (OrderBy? val) {
                if (val != null) {
                  setState(() {
                    orderby = val;
                  });
                }
              },
              dropdownMenuEntries: sortingOptions
                  .map((OrderBy element) => DropdownMenuEntry<OrderBy>(
                      value: element, label: element.name))
                  .toList(),
            ),
            tasks.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 80,
                      bottom: 80,
                      left: 40,
                      right: 40,
                    ),
                    child: Image.asset(
                      "assets/images/first_screen.PNG",
                      fit: BoxFit.contain,
                      width: 250,
                    ),
                  )
                : Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    shrinkWrap: true,

                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return Dismissible(
                        key: ValueKey(task.id),
                        onDismissed: (_) {
                          taskProvider.deleteTask(task.id);
                        },
                        child: ListTile(
                            title: Text(task.title),
                            subtitle: Text(task.description),
                            leading: Checkbox(
                              value: task.isCompleted,
                              onChanged: (bool? value) {
                                taskProvider.toggleCompletionOfTask(
                                  id: task.id,
                                  isCompleted: value ?? false,
                                );
                              },
                            ),
                            // trailing: IconButton(
                            //   icon: const Icon(Icons.delete, color: Colors.red),
                            //   onPressed: () {
                            //     taskProvider.deleteTask(task.id);
                            //   },
                            // ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                      children: [task.dueDate != null
                                ? Text(
                                    DateFormat('yyyy-MM-dd')
                                        .format(task.dueDate!),
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 14.0))
                                : const SizedBox(),
                           IconButton(
                            icon: const Icon(Icons.edit, color: Colors.red),
                            onPressed: () {
                              // notesList.updateNote(note.id, note.description);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditTask(
                                    task: task,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                        ),
                        ),
                      );
                    },
                  ),
                ),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: PrimaryButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskScreen()),
            );
          },
          text: "Add Task",
        ),
      ),
    );
  }
}
