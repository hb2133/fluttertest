import 'package:flutter/material.dart';
import 'package:fluttertest/design/global_design.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_state.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_types.dart';

class TodoNavigationSection extends StatelessWidget {
  const TodoNavigationSection({
    super.key,
    required this.State,
    required this.OnFilterSelected,
  });

  final TodoState State;
  final ValueChanged<TodoFilter> OnFilterSelected;

  @override
  Widget build(BuildContext Context) {
    return Container(
      width: GlobalDesign.NavigationWidth,
      color: const Color(0xFF25283A),
      padding: const EdgeInsets.fromLTRB(18, 28, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(Icons.check_circle_rounded, color: Color(0xFF8995FF)),
              SizedBox(width: 10),
              Text(
                'Todo Desktop',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 34),
          _NavigationItem(
            Label: '전체',
            IconDataValue: Icons.inbox_rounded,
            Count: State.Items.length,
            IsSelected: State.Filter == TodoFilter.All,
            OnTap: () => OnFilterSelected(TodoFilter.All),
          ),
          _NavigationItem(
            Label: '진행 중',
            IconDataValue: Icons.radio_button_unchecked_rounded,
            Count: State.ActiveCount,
            IsSelected: State.Filter == TodoFilter.Active,
            OnTap: () => OnFilterSelected(TodoFilter.Active),
          ),
          _NavigationItem(
            Label: '완료',
            IconDataValue: Icons.task_alt_rounded,
            Count: State.CompletedCount,
            IsSelected: State.Filter == TodoFilter.Completed,
            OnTap: () => OnFilterSelected(TodoFilter.Completed),
          ),
          const Spacer(),
          Text(
            '${State.ActiveCount}개의 할 일이 남았습니다',
            style: const TextStyle(color: Color(0xFFB7BAC8), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.Label,
    required this.IconDataValue,
    required this.Count,
    required this.IsSelected,
    required this.OnTap,
  });

  final String Label;
  final IconData IconDataValue;
  final int Count;
  final bool IsSelected;
  final VoidCallback OnTap;

  @override
  Widget build(BuildContext Context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: IsSelected ? const Color(0xFF3B405D) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: OnTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: <Widget>[
                Icon(IconDataValue, color: Colors.white70, size: 19),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    Label,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Text('$Count', style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
