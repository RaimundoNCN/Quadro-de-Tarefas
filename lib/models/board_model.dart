import 'list_model.dart';

class BoardModel {
  String id;
  String name;
  List<ListModel> lists;

  BoardModel({required this.id, required this.name, required this.lists});

  factory BoardModel.fromMap(Map<String, dynamic> map) => BoardModel(
    id: map['id'],
    name: map['name'],
    lists: (map['lists'] as List<dynamic>? ?? [])
        .map((e) => ListModel.fromMap(Map<String, dynamic>.from(e)))
        .toList(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'lists': lists.map((e) => e.toMap()).toList(),
  };
}
