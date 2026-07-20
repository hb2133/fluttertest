import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/panels/base/todo/controller/actions/todo_storage_action.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_controller.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_types.dart';

void main() {
  test('할 일 변경 사항을 로컬 JSON에 저장하고 복원한다', () async {
    final Directory DirectoryValue = await Directory.systemTemp.createTemp(
      'todo_desktop_test_',
    );
    final File StorageFile = File('${DirectoryValue.path}/todos.json');
    final TodoStorageAction StorageAction = TodoStorageAction(
      StorageFile: StorageFile,
    );
    final TodoController Controller = TodoController(
      StorageAction: StorageAction,
    );

    await Controller.Load();
    await Controller.CreateTodo('Flutter 공부', '첫 화면 만들기', TodoPriority.High);
    await Controller.ToggleTodo(Controller.State.Items.single.Id);

    final TodoController RestoredController = TodoController(
      StorageAction: StorageAction,
    );
    await RestoredController.Load();

    expect(RestoredController.State.Items.single.Title, 'Flutter 공부');
    expect(RestoredController.State.Items.single.IsCompleted, isTrue);
  });

  test('할 일 상태를 검색하고 필터링한다', () async {
    final Directory DirectoryValue = await Directory.systemTemp.createTemp(
      'todo_desktop_filter_test_',
    );
    final TodoController Controller = TodoController(
      StorageAction: TodoStorageAction(
        StorageFile: File('${DirectoryValue.path}/todos.json'),
      ),
    );

    await Controller.Load();
    await Controller.CreateTodo('Flutter 공부', '', TodoPriority.High);
    await Controller.CreateTodo('장보기', '우유', TodoPriority.Low);
    await Controller.ToggleTodo(Controller.State.Items.last.Id);

    Controller.SetFilter(TodoFilter.Active);
    expect(Controller.State.VisibleItems.single.Title, '장보기');

    Controller.SetFilter(TodoFilter.All);
    Controller.SetSearchQuery('우유');
    expect(Controller.State.VisibleItems.single.Title, '장보기');
  });
}
