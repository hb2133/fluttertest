import 'dart:convert';
import 'dart:io';

import 'package:fluttertest/panels/base/todo/controller/todo_types.dart';

class TodoStorageAction {
  // ignore: prefer_initializing_formals
  TodoStorageAction({File? StorageFile}) : _StorageFile = StorageFile;

  final File? _StorageFile;

  Future<List<TodoItem>> LoadTodos() async {
    final File FileValue = _StorageFile ?? _ResolveStorageFile();
    if (await FileValue.exists() == false) {
      return <TodoItem>[];
    }

    final Object? JsonValue = jsonDecode(await FileValue.readAsString());
    if (JsonValue is! List<Object?>) {
      throw const FormatException('저장된 할 일 데이터 형식이 올바르지 않습니다.');
    }

    return JsonValue.map(
      (Object? Value) => TodoItem.FromJson(
        Map<String, Object?>.from(Value! as Map<Object?, Object?>),
      ),
    ).toList(growable: false);
  }

  Future<void> SaveTodos(List<TodoItem> Items) async {
    final File FileValue = _StorageFile ?? _ResolveStorageFile();
    await FileValue.parent.create(recursive: true);
    final String JsonValue = const JsonEncoder.withIndent(
      '  ',
    ).convert(Items.map((TodoItem Item) => Item.ToJson()).toList());
    await FileValue.writeAsString(JsonValue, flush: true);
  }

  File _ResolveStorageFile() {
    final Map<String, String> Environment = Platform.environment;
    late final String DirectoryPath;

    if (Platform.isWindows) {
      DirectoryPath =
          '${Environment['APPDATA'] ?? Directory.current.path}'
          '${Platform.pathSeparator}Todo Desktop';
    } else if (Platform.isMacOS) {
      DirectoryPath =
          '${Environment['HOME'] ?? Directory.current.path}'
          '/Library/Application Support/Todo Desktop';
    } else {
      final String DataRoot =
          Environment['XDG_DATA_HOME'] ??
          '${Environment['HOME'] ?? Directory.current.path}/.local/share';
      DirectoryPath = '$DataRoot/todo_desktop';
    }

    return File('$DirectoryPath${Platform.pathSeparator}todos.json');
  }
}
