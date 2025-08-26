import 'package:flutter/material.dart';
import '../models/board_model.dart';
import '../models/list_model.dart';
import '../models/task_model.dart';
import '../widgets/task_tile.dart';

class BoardPage extends StatefulWidget {
  final BoardModel board;
  const BoardPage({super.key, required this.board});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  late List<ListModel> lists;

  @override
  void initState() {
    super.initState();
    lists = widget.board.lists;
  }

  void moveTask(int fromList, int toList, int taskIndex) {
    setState(() {
      final task = lists[fromList].tasks.removeAt(taskIndex);
      lists[toList].tasks.insert(0, task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.board.name)),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(lists.length, (listIndex) {
            final list = lists[listIndex];
            return Container(
              width: 320,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      list.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: DragTarget<Map<String, dynamic>>(
                      onWillAccept: (data) => data != null && data['fromList'] != listIndex,
                      onAccept: (data) {
                        moveTask(data['fromList'], listIndex, data['taskIndex']);
                      },
                      builder: (context, candidateData, rejectedData) {
                        return ListView.builder(
                          itemCount: list.tasks.length,
                          itemBuilder: (context, taskIndex) {
                            final task = list.tasks[taskIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Draggable<Map<String, dynamic>>(
                                data: {
                                  'fromList': listIndex,
                                  'taskIndex': taskIndex,
                                },
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: SizedBox(
                                    width: 280,
                                    child: TaskTile(
                                      task: task,
                                      onEdit: () {},
                                      onDelete: () {},
                                    ),
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.5,
                                  child: TaskTile(
                                    task: task,
                                    onEdit: () {},
                                    onDelete: () {},
                                  ),
                                ),
                                child: TaskTile(
                                  task: task,
                                  onEdit: () {
                                    // Implemente a edição
                                  },
                                  onDelete: () {
                                    setState(() {
                                      list.tasks.removeAt(taskIndex);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}