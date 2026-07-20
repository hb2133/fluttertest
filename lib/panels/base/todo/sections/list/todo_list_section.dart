import 'package:flutter/material.dart';
import 'package:fluttertest/design/global_design.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_state.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_types.dart';

class TodoListSection extends StatelessWidget {
  const TodoListSection({
    super.key,
    required this.State,
    required this.OnSelected,
    required this.OnToggled,
  });

  final TodoState State;
  final ValueChanged<String> OnSelected;
  final ValueChanged<String> OnToggled;

  @override
  Widget build(BuildContext Context) {
    final List<TodoItem> Items = State.VisibleItems;
    if (Items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.checklist_rounded, size: 54, color: Color(0xFFB7BDCB)),
            SizedBox(height: 12),
            Text('표시할 할 일이 없습니다.', style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text('새 할 일을 추가해 하루를 계획해 보세요.'),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
      itemCount: Items.length,
      separatorBuilder: (BuildContext Context, int Index) =>
          const SizedBox(height: 10),
      itemBuilder: (BuildContext Context, int Index) {
        final TodoItem Item = Items[Index];
        final bool IsSelected = Item.Id == State.SelectedId;
        return Material(
          color: IsSelected ? const Color(0xFFEEF0FF) : Colors.white,
          borderRadius: BorderRadius.circular(GlobalDesign.CornerRadius),
          child: InkWell(
            onTap: () => OnSelected(Item.Id),
            borderRadius: BorderRadius.circular(GlobalDesign.CornerRadius),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              decoration: BoxDecoration(
                border: Border.all(
                  color: IsSelected
                      ? GlobalDesign.PrimaryColor
                      : GlobalDesign.BorderColor,
                ),
                borderRadius: BorderRadius.circular(GlobalDesign.CornerRadius),
              ),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: Item.IsCompleted,
                    onChanged: (_) => OnToggled(Item.Id),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Item.Title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: Item.IsCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: Item.IsCompleted
                                ? GlobalDesign.MutedTextColor
                                : GlobalDesign.TextColor,
                          ),
                        ),
                        if (Item.Notes.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 4),
                          Text(
                            Item.Notes,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: GlobalDesign.MutedTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _PriorityBadge(Priority: Item.Priority),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.Priority});

  final TodoPriority Priority;

  @override
  Widget build(BuildContext Context) {
    final (String Label, Color ColorValue) = switch (Priority) {
      TodoPriority.Low => ('낮음', const Color(0xFF3B9A70)),
      TodoPriority.Medium => ('보통', const Color(0xFFD18A28)),
      TodoPriority.High => ('높음', const Color(0xFFD34F5A)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: ColorValue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        Label,
        style: TextStyle(
          color: ColorValue,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
