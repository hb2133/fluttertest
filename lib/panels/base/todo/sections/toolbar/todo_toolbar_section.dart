import 'package:flutter/material.dart';

class TodoToolbarSection extends StatelessWidget {
  const TodoToolbarSection({
    super.key,
    required this.Title,
    required this.OnSearchChanged,
    required this.OnCreatePressed,
  });

  final String Title;
  final ValueChanged<String> OnSearchChanged;
  final VoidCallback OnCreatePressed;

  @override
  Widget build(BuildContext Context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Title,
                  style: Theme.of(Context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                const Text('오늘 할 일을 가볍게 정리해 보세요.'),
              ],
            ),
          ),
          SizedBox(
            width: 260,
            child: TextField(
              onChanged: OnSearchChanged,
              decoration: const InputDecoration(
                hintText: '할 일 검색',
                prefixIcon: Icon(Icons.search_rounded),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: OnCreatePressed,
            icon: const Icon(Icons.add_rounded),
            label: const Text('새 할 일'),
          ),
        ],
      ),
    );
  }
}
