import 'task_model.dart';

class ListModel {
  String id;
  String name;
  List<TaskModel> tasks;

  ListModel({
    required this.id,
    required this.name,
    required this.tasks,
  });

  factory ListModel.fromMap(Map<String, dynamic> map) => ListModel(
        id: map['id'],
        name: map['name'],
        tasks: (map['tasks'] as List)
            .map((e) => TaskModel.fromMap(Map<String, dynamic>.from(e)))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'tasks': tasks.map((e) => e.toMap()).toList(),
      };
}