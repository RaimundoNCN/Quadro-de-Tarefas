import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onEdit; // Editar nota + título
  final VoidCallback onDelete; // Excluir tarefa
  final VoidCallback? onLongPress; // Novo parâmetro

  const TaskTile({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    this.onLongPress,
  });

  String _formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} ${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
        ),
        child: ListTile(
          title: Text(task.title),
          subtitle: Text(
            'Criada em: ${_formatDate(task.date)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Editar tarefa',
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: 'Excluir',
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
