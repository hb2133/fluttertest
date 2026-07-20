import 'package:flutter/foundation.dart';
import 'package:fluttertest/panels/base/todo/controller/actions/todo_storage_action.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_state.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_types.dart';

class TodoController extends ChangeNotifier {
  TodoController({TodoStorageAction? StorageAction})
    : _StorageAction = StorageAction ?? TodoStorageAction();

  final TodoStorageAction _StorageAction;
  TodoState _State = const TodoState();

  TodoState get State => _State;

  Future<void> Load() async {
    try {
      final List<TodoItem> Items = await _StorageAction.LoadTodos();
      _SetState(
        _State.CopyWith(Items: Items, IsLoading: false, ClearError: true),
      );
    } catch (_) {
      _SetState(
        _State.CopyWith(IsLoading: false, ErrorMessage: '저장된 할 일을 불러오지 못했습니다.'),
      );
    }
  }

  Future<void> CreateTodo(
    String Title,
    String Notes,
    TodoPriority Priority,
  ) async {
    final String NormalizedTitle = Title.trim();
    if (NormalizedTitle.isEmpty) {
      return;
    }

    final DateTime Now = DateTime.now();
    final TodoItem Item = TodoItem(
      Id: Now.microsecondsSinceEpoch.toString(),
      Title: NormalizedTitle,
      Notes: Notes.trim(),
      Priority: Priority,
      IsCompleted: false,
      CreatedAt: Now,
      UpdatedAt: Now,
    );
    final List<TodoItem> Items = <TodoItem>[Item, ..._State.Items];
    _SetState(_State.CopyWith(Items: Items, SelectedId: Item.Id));
    await _Persist();
  }

  Future<void> UpdateTodo(
    String Id,
    String Title,
    String Notes,
    TodoPriority Priority,
  ) async {
    final String NormalizedTitle = Title.trim();
    if (NormalizedTitle.isEmpty) {
      return;
    }
    final List<TodoItem> Items = _State.Items.map((TodoItem Item) {
      if (Item.Id != Id) {
        return Item;
      }
      return Item.CopyWith(
        Title: NormalizedTitle,
        Notes: Notes.trim(),
        Priority: Priority,
        UpdatedAt: DateTime.now(),
      );
    }).toList(growable: false);
    _SetState(_State.CopyWith(Items: Items));
    await _Persist();
  }

  Future<void> ToggleTodo(String Id) async {
    final List<TodoItem> Items = _State.Items.map((TodoItem Item) {
      if (Item.Id != Id) {
        return Item;
      }
      return Item.CopyWith(
        IsCompleted: Item.IsCompleted == false,
        UpdatedAt: DateTime.now(),
      );
    }).toList(growable: false);
    _SetState(_State.CopyWith(Items: Items));
    await _Persist();
  }

  Future<void> DeleteTodo(String Id) async {
    final List<TodoItem> Items = _State.Items.where(
      (TodoItem Item) => Item.Id != Id,
    ).toList(growable: false);
    _SetState(_State.CopyWith(Items: Items, ClearSelection: true));
    await _Persist();
  }

  void SelectTodo(String? Id) {
    _SetState(_State.CopyWith(SelectedId: Id, ClearSelection: Id == null));
  }

  void SetFilter(TodoFilter Filter) {
    _SetState(_State.CopyWith(Filter: Filter));
  }

  void SetSearchQuery(String Query) {
    _SetState(_State.CopyWith(SearchQuery: Query));
  }

  Future<void> _Persist() async {
    try {
      await _StorageAction.SaveTodos(_State.Items);
      if (_State.ErrorMessage != null) {
        _SetState(_State.CopyWith(ClearError: true));
      }
    } catch (_) {
      _SetState(_State.CopyWith(ErrorMessage: '변경 내용을 저장하지 못했습니다.'));
    }
  }

  void _SetState(TodoState State) {
    _State = State;
    notifyListeners();
  }
}
