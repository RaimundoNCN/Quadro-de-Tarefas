import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/list_model.dart';
import '../models/board_model.dart';
import '../services/task_service.dart';
import 'task_note_page.dart';
import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BoardModel> _boards = [];
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
    _loadBoards();
  }

  Future<void> _loadBoards() async {
    final boards = await _taskService.loadBoards();
    setState(() {
      _boards = boards.isEmpty
          ? [
              BoardModel(
                id: 'b1',
                name: 'Quadro de Tarefas',
                lists: [
                  ListModel(
                    id: 'l1',
                    name: 'A Fazer',
                    tasks: [
                      TaskModel(
                        id: 't1',
                        title: 'Minha tarefa',
                        //description: 'Descrição',
                        date: DateTime.now().toIso8601String(),
                      ),
                    ],
                  ),
                ],
              ),
            ]
          : boards;
    });
  }

  Future<void> _saveBoards() async {
    await _taskService.saveBoards(_boards);
  }

  @override
  Widget build(BuildContext context) {
    if (_boards.isEmpty) {
      return Scaffold(
        //appBar: AppBar(title: Text('Quadros')),
        body: Center(child: Text('Nenhum quadro encontrado.')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _boards.add(
                BoardModel(
                  id: DateTime.now().toString(),
                  name: 'Novo Quadro',
                  lists: [],
                ),
              );
            });
            _saveBoards();
          },
          child: Icon(Icons.add),
          tooltip: 'Criar novo quadro',
        ),
      );
    }

    final board = _boards.first;
    return Scaffold(
      appBar: AppBar(
        title: Text('Quadro de Tarefas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            tooltip: 'Nova Lista',
            onPressed: () => _showCreateListDialog(context, board),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.amber,
        backgroundColor: Colors.green,
        tooltip: "Adicionar tarefa na primeira lista",
        onPressed: () {
          if (board.lists.isNotEmpty) {
            _showCreateTaskCard(context, board.lists.first);
          }
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...board.lists
                .map((list) => _buildListColumn(context, board, list))
                .toList(),
            _buildAddListButton(context, board),
          ],
        ),
      ),
    );
  }

  Widget _buildListColumn(
    BuildContext context,
    BoardModel board,
    ListModel list,
  ) {
    final listIndex = board.lists.indexOf(list);
    return Container(
      width: 320,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da lista com botão de editar e excluir
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    list.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, size: 20),
                  tooltip: 'Editar lista',
                  onPressed: () => _showEditListDialog(context, board, list),
                ),
                IconButton(
                  icon: Icon(Icons.delete, size: 20, color: Colors.red),
                  tooltip: 'Excluir lista',
                  onPressed: () => _showDeleteListDialog(context, board, list),
                ),
              ],
            ),
          ),
          // DragTarget para receber cartões de outras listas
          Expanded(
            child: DragTarget<Map<String, dynamic>>(
              onWillAccept: (data) =>
                  data != null && data['fromList'] != listIndex,
              onAccept: (data) {
                setState(() {
                  final fromList = board.lists[data['fromList']];
                  final task = fromList.tasks.removeAt(data['taskIndex']);
                  list.tasks.insert(0, task);
                });
                _saveBoards(); // <--- Adicione aqui
              },
              builder: (context, candidateData, rejectedData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: list.tasks.length,
                  itemBuilder: (context, index) {
                    final task = list.tasks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: TaskTile(
                        task: task,
                        onEdit: () => _navigateToEditPage(list, index),
                        onDelete: () => _showDeleteDialog(list, index),
                        onLongPress: () async {
                          final board = _boards
                              .first; // ou obtenha o board atual conforme sua lógica
                          final destination = await showModalBottomSheet<int>(
                            context: context,
                            builder: (context) => ListView(
                              shrinkWrap: true,
                              children: board.lists
                                  .asMap()
                                  .entries
                                  .where((entry) => entry.value != list)
                                  .map(
                                    (entry) => ListTile(
                                      title: Text(
                                        'Mover para: ${entry.value.name}',
                                      ),
                                      onTap: () =>
                                          Navigator.pop(context, entry.key),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                          if (destination != null) {
                            setState(() {
                              final taskToMove = list.tasks.removeAt(index);
                              board.lists[destination].tasks.insert(
                                0,
                                taskToMove,
                              );
                            });
                            _saveBoards();
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Botão para adicionar cartão
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: OutlinedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Adicionar cartão'),
              onPressed: () => _showCreateTaskCard(context, list),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddListButton(BuildContext context, BoardModel board) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 16),
      child: OutlinedButton.icon(
        icon: Icon(Icons.add),
        label: Text('Nova Lista'),
        onPressed: () => _showCreateListDialog(context, board),
      ),
    );
  }

  void _showCreateListDialog(BuildContext context, BoardModel board) {
    final TextEditingController listNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nova Lista'),
        content: TextField(
          controller: listNameController,
          decoration: InputDecoration(labelText: 'Nome da lista'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (listNameController.text.trim().isEmpty) return;
              setState(() {
                board.lists.add(
                  ListModel(
                    id: DateTime.now().toString(),
                    name: listNameController.text.trim(),
                    tasks: [],
                  ),
                );
              });
              _saveBoards();
              Navigator.of(context).pop();
            },
            child: Text('Criar'),
          ),
        ],
      ),
    );
  }

  void _showEditListDialog(
    BuildContext context,
    BoardModel board,
    ListModel list,
  ) {
    final TextEditingController listNameController = TextEditingController(
      text: list.name,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Lista'),
        content: TextField(
          controller: listNameController,
          decoration: InputDecoration(labelText: 'Nome da lista'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (listNameController.text.trim().isEmpty) return;
              setState(() {
                list.name = listNameController.text.trim();
              });
              _saveBoards(); // <--- Adicione aqui
              Navigator.of(context).pop();
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteListDialog(
    BuildContext context,
    BoardModel board,
    ListModel list,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Lista'),
        content: Text(
          'Tem certeza que deseja excluir esta lista e todos os seus cartões?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                board.lists.remove(list);
              });
              _saveBoards(); // <--- Adicione aqui
              Navigator.of(context).pop();
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _showCreateTaskCard(BuildContext context, ListModel list) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nova Tarefa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              maxLength: 50,
            ),
            SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Descrição (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 200,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.check),
              label: Text('Criar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('O título da tarefa é obrigatório')),
                  );
                  return;
                }
                setState(() {
                  list.tasks.insert(
                    0,
                    TaskModel(
                      id: DateTime.now().toString(),
                      title: titleController.text.trim(),
                      //description: descController.text.trim(),
                      date: DateTime.now().toIso8601String(),
                    ),
                  );
                });
                _saveBoards(); // <--- Adicione aqui
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEditPage(ListModel list, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskNotePage(
          taskTitle: list.tasks[index].title,
          initialNote: list.tasks[index].note,
        ),
      ),
    );
    if (result != null && result is String) {
      setState(() {
        list.tasks[index].note = result;
      });
      _saveBoards(); // <--- Adicione aqui
    }
  }

  void _showDeleteDialog(ListModel list, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir tarefa'),
        content: Text('Tem certeza que deseja excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                list.tasks.removeAt(index);
              });
              _saveBoards(); // <--- Adicione aqui
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
