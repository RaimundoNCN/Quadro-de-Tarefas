import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/board_model.dart';

class TaskService {
  static const String _boardsKey = 'boards';

  Future<List<BoardModel>> loadBoards() async {
    final prefs = await SharedPreferences.getInstance();
    final boardsJson = prefs.getString(_boardsKey);
    if (boardsJson == null) return [];
    final List<dynamic> decoded = jsonDecode(boardsJson);
    return decoded
        .map((e) => BoardModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveBoards(List<BoardModel> boards) async {
    final prefs = await SharedPreferences.getInstance();
    final boardsJson = jsonEncode(boards.map((b) => b.toMap()).toList());
    await prefs.setString(_boardsKey, boardsJson);
  }
}