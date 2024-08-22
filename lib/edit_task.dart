import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/providers/task_provider.dart';
import 'models/task_model.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key, required this.task});

  final TaskModel task;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
    _dueDateController.text = widget.task.dueDate?.toIso8601String() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _editTask, // Link to the method here
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Edit Task',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 34,
          right: 34,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(
            children: [
              Text(
                "Title",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                ),
              ),
              Text(
                "*",
                style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          TextFormField(
            controller: _titleController,
            maxLines: 1,
            decoration: InputDecoration(
                hintText: "Type Here...",
                hintStyle: const TextStyle(
                  color: Colors.black12,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                  const BorderSide(color: Colors.white54, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                  const BorderSide(color: Colors.white54, width: 2.0),
                )),
          ),
          const Row(
            children: [
              Text(
                "Description",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                ),
              ),
              Text(
                "*",
                style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
                hintText: "Type Here...",
                hintStyle: const TextStyle(
                  color: Colors.black12,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                  const BorderSide(color: Colors.white54, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                  const BorderSide(color: Colors.white54, width: 2.0),
                )),
          ),
        ]),
      ),
    );
  }

  void _editTask() {
    final String title = _titleController.text;
    final String description = _descriptionController.text;

    if (title.isEmpty) {
      print("Add title first");
      return;
    } else if (description.isEmpty) {
      print("Add description first");
      return;
    }

    // Updating the task in the provider
    context.read<TaskProvider>().updateTask(
      id: widget.task.id,
      title: title,
      description: description,
      dueDate: widget.task.dueDate, // Assuming due date remains unchanged
    );
    Navigator.pop(context);
  }
}
