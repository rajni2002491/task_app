import 'package:flutter/material.dart';
import 'package:todo_app/input_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var data = <String, bool>{};
  bool _allSelected = false;

  @override
  void initState() {
    super.initState();
    data.remove("");
  }

  void _addTask(String task) {
    final trimmed = task.trim();
    if (trimmed.isNotEmpty) {
      setState(() {
        data[trimmed] = false;
        _updateSelectAllStatus();
      });
    }
  }

  void _deleteTask(String task) {
    setState(() {
      data.remove(task);
      _updateSelectAllStatus();
    });
  }

  void _updateTask(String oldTask, String newTask) {
    final trimmed = newTask.trim();
    if (trimmed.isNotEmpty && oldTask != trimmed) {
      setState(() {
        final isCompleted = data[oldTask];
        data.remove(oldTask);
        data[trimmed] = isCompleted ?? false;
      });
    }
  }

  void _toggleCompletion(String task, bool? value) {
    setState(() {
      data[task] = value ?? false;
      _updateSelectAllStatus();
    });
  }

  void _toggleSelectAll() {
    if (data.isEmpty) return;

    final newValue = !_allSelected;
    setState(() {
      data.updateAll((_, __) => newValue);
      _allSelected = newValue;
    });
  }

  void _updateSelectAllStatus() {
    if (data.isEmpty) {
      _allSelected = false;
      return;
    }

    setState(() {
      _allSelected = !data.containsValue(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Map<String, bool>.from(data)
      ..removeWhere((key, _) => key.isEmpty);
    final completedCount = tasks.values.where((v) => v).length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("TODO"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final input = await showDialog<String>(
            context: context,
            builder: (_) => InputDialog(),
          );
          if (input != null && input.trim().isNotEmpty) _addTask(input);
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (tasks.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("$completedCount/${tasks.length} completed"),
                  TextButton.icon(
                    onPressed: _toggleSelectAll,
                    icon: Icon(
                      _allSelected
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                    ),
                    label: Text(_allSelected ? "Deselect All" : "Select All"),
                  ),
                ],
              ),
            ),
          Expanded(
            child:
                tasks.isEmpty
                    ? Center(child: Text("No tasks yet. Add some!"))
                    : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final title = tasks.keys.toList()[index];
                        final completed = tasks.values.toList()[index];
                        return Dismissible(
                          key: Key(title),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => _deleteTask(title),
                          confirmDismiss: (direction) async {
                            // Show confirmation dialog
                            return await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text("Delete Task"),
                                    content: Text(
                                      "Are you sure you want to delete this task?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: Text("CANCEL"),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: Text(
                                          "DELETE",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              leading: Checkbox(
                                value: completed,
                                onChanged: (v) => _toggleCompletion(title, v),
                              ),
                              title: Text(
                                title,
                                style: TextStyle(
                                  decoration:
                                      completed
                                          ? TextDecoration.lineThrough
                                          : null,
                                  color: completed ? Colors.grey : Colors.black,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  final controller = TextEditingController(
                                    text: title,
                                  );
                                  final result = await showDialog<String>(
                                    context: context,
                                    builder:
                                        (_) => AlertDialog(
                                          title: Text("Edit Task"),
                                          content: TextField(
                                            controller: controller,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: Text("CANCEL"),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    controller.text,
                                                  ),
                                              child: Text("SAVE"),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (result != null &&
                                      result.trim().isNotEmpty) {
                                    _updateTask(title, result);
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
