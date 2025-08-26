import 'package:flutter/material.dart';

class TaskNotePage extends StatefulWidget {
  final String taskTitle;
  final String initialNote;

  const TaskNotePage({
    super.key,
    required this.taskTitle,
    required this.initialNote,
  });

  @override
  State<TaskNotePage> createState() => _TaskNotePageState();
}

class _TaskNotePageState extends State<TaskNotePage> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Salvar',
            onPressed: () {
              Navigator.pop(context, _noteController.text);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _noteController,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Digite suas anotações aqui...',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}