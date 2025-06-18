import 'package:isar/isar.dart';
import 'package:isar_todo/model/emums.dart';

part 'todo.g.dart';

@Collection()
class Todo {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String? content;

  @enumerated
  Status status = Status.pending;

  DateTime createedAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Todo copyWith({String? content, Status? status}) {
    print(content);
    final todo = Todo()
      ..id = id
      ..createedAt = createedAt
      ..updatedAt = DateTime.now()
      ..content = content ?? this.content
      ..status = status ?? this.status;

    print(todo.content);
    return todo;
  }
}
