class TaskModel {
  String id;
  String title;
  String description;
  String date;
  String note;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.date,
    this.note = '',
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
    id: map['id'],
    title: map['title'],
    description: map['description'] ?? '',
    date: map['date'],
    note: map['note'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date,
    'note': note,
  };
}
