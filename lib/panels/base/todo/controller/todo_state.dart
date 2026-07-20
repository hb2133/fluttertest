import 'package:fluttertest/panels/base/todo/controller/todo_types.dart';

class TodoState {
  const TodoState({
    this.Items = const <TodoItem>[],
    this.Filter = TodoFilter.All,
    this.SearchQuery = '',
    this.SelectedId,
    this.IsLoading = true,
    this.ErrorMessage,
  });

  final List<TodoItem> Items;
  final TodoFilter Filter;
  final String SearchQuery;
  final String? SelectedId;
  final bool IsLoading;
  final String? ErrorMessage;

  List<TodoItem> get VisibleItems {
    final String Query = SearchQuery.trim().toLowerCase();
    final Iterable<TodoItem> Filtered = Items.where((TodoItem Item) {
      final bool MatchesFilter = switch (Filter) {
        TodoFilter.All => true,
        TodoFilter.Active => Item.IsCompleted == false,
        TodoFilter.Completed => Item.IsCompleted,
      };
      final bool MatchesSearch =
          Query.isEmpty ||
          Item.Title.toLowerCase().contains(Query) ||
          Item.Notes.toLowerCase().contains(Query);
      return MatchesFilter && MatchesSearch;
    });

    return Filtered.toList(growable: false);
  }

  TodoItem? get SelectedItem {
    for (final TodoItem Item in Items) {
      if (Item.Id == SelectedId) {
        return Item;
      }
    }
    return null;
  }

  int get ActiveCount =>
      Items.where((TodoItem Item) => Item.IsCompleted == false).length;
  int get CompletedCount =>
      Items.where((TodoItem Item) => Item.IsCompleted).length;

  TodoState CopyWith({
    List<TodoItem>? Items,
    TodoFilter? Filter,
    String? SearchQuery,
    String? SelectedId,
    bool ClearSelection = false,
    bool? IsLoading,
    String? ErrorMessage,
    bool ClearError = false,
  }) {
    return TodoState(
      Items: Items ?? this.Items,
      Filter: Filter ?? this.Filter,
      SearchQuery: SearchQuery ?? this.SearchQuery,
      SelectedId: ClearSelection ? null : SelectedId ?? this.SelectedId,
      IsLoading: IsLoading ?? this.IsLoading,
      ErrorMessage: ClearError ? null : ErrorMessage ?? this.ErrorMessage,
    );
  }
}
