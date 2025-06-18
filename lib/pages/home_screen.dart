import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar_todo/model/emums.dart';
import 'package:isar_todo/model/todo.dart';
import 'package:isar_todo/services/db_service.dart';
import 'package:isar_todo/services/notification/noti_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todoList = [];

  StreamSubscription? todoStream;

  @override
  void initState() {
    todoStream = DBService.db.todos
        .buildQuery<Todo>()
        .watch(fireImmediately: true)
        .listen((event) {
          setState(() {
            todoList = event;
          });
        });
    super.initState();
  }

  @override
  void dispose() {
    todoStream!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrEditTodo,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              print(value);
              switch (value) {
                case 'About':
                  break;
                case 'Notifications':
                  NotiService().showNotification(
                    id_: 0,
                    title: "This is notification title",
                    body:
                        'This is a test notification body. this notification is called for testing purpose. and it should be show longer and longer. as it cna be compressed and extendavbale text. Is it ok with you.',
                  );
                  break;
              }
            },
            itemBuilder: (context) {
              return ['About', 'Notifications'].map((e) {
                return PopupMenuItem(value: e, child: Text(e));
              }).toList();
            },
          ),
        ],
      ),
      body:
          todoList.isEmpty
              ? Center(child: Text('No todo is found'))
              : ListView.builder(
                shrinkWrap: true,
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  final todo = todoList[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 10,
                        backgroundColor:
                            todo.status == Status.pending
                                ? Colors.redAccent
                                : todo.status == Status.inProgress
                                ? Colors.lightBlueAccent
                                : Colors.greenAccent,
                      ),
                      title: Text(todo.content ?? '--'),
                      subtitle: Text(todo.updatedAt.toLocal().toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await DBService.db.writeTxn(() async {
                                await DBService.db.todos.delete(todo.id);
                              });
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () {
                              _addOrEditTodo(todo: todo);
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  _addOrEditTodo({Todo? todo}) {
    Status status = Status.pending;
    final textController = TextEditingController();
    if (todo != null) {
      status = todo.status;
      textController.text = todo.content ?? '';
    }
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(todo == null ? 'Add new todo' : 'Update todo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: textController,
                  minLines: 2,
                  maxLines: 5,
                  decoration: InputDecoration(
                    label: Text('Todo Task'),
                    hintText: 'Write your todo text',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  value: status,
                  items:
                      Status.values.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e.name));
                      }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    status = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.blue)),
              ),
              TextButton(
                onPressed: () async {
                  if (textController.text.isEmpty) {
                    return;
                  }
                  Todo newTodo = Todo();
                  if (todo == null) {
                    newTodo = newTodo.copyWith(
                      content: textController.text.trim(),
                      status: status,
                    );
                  } else {
                    newTodo = todo.copyWith(
                      content: textController.text.trim(),
                      status: status,
                    );
                  }
                  print('saving :: -- ${newTodo.content}');

                  await DBService.db.writeTxn(() async {
                    await DBService.db.todos.put(newTodo);
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
