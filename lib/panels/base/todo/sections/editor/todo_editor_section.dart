import 'package:flutter/material.dart';
import 'package:fluttertest/design/global_design.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_types.dart';

class TodoEditorSection extends StatefulWidget {
  const TodoEditorSection({
    super.key,
    required this.Item,
    required this.IsCreating,
    required this.OnCreate,
    required this.OnUpdate,
    required this.OnDelete,
    required this.OnClose,
  });

  final TodoItem? Item;
  final bool IsCreating;
  final Future<void> Function(String, String, TodoPriority) OnCreate;
  final Future<void> Function(String, String, TodoPriority) OnUpdate;
  final Future<void> Function() OnDelete;
  final VoidCallback OnClose;

  @override
  State<TodoEditorSection> createState() => _TodoEditorSectionState();
}

class _TodoEditorSectionState extends State<TodoEditorSection> {
  final TextEditingController _TitleController = TextEditingController();
  final TextEditingController _NotesController = TextEditingController();
  TodoPriority _Priority = TodoPriority.Medium;
  bool _DeleteConfirmationVisible = false;

  @override
  void initState() {
    super.initState();
    _SyncFromWidget();
  }

  @override
  void didUpdateWidget(covariant TodoEditorSection OldWidget) {
    super.didUpdateWidget(OldWidget);
    if (OldWidget.Item?.Id != widget.Item?.Id ||
        OldWidget.IsCreating != widget.IsCreating) {
      _SyncFromWidget();
    }
  }

  @override
  void dispose() {
    _TitleController.dispose();
    _NotesController.dispose();
    super.dispose();
  }

  void _SyncFromWidget() {
    _TitleController.text = widget.Item?.Title ?? '';
    _NotesController.text = widget.Item?.Notes ?? '';
    _Priority = widget.Item?.Priority ?? TodoPriority.Medium;
    _DeleteConfirmationVisible = false;
  }

  @override
  Widget build(BuildContext Context) {
    return Container(
      width: GlobalDesign.EditorWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: GlobalDesign.BorderColor)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.IsCreating ? '새 할 일' : '할 일 편집',
                  style: Theme.of(
                    Context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                tooltip: '편집 닫기',
                onPressed: widget.OnClose,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('제목', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            key: const Key('todo_title_field'),
            controller: _TitleController,
            autofocus: widget.IsCreating,
            decoration: const InputDecoration(hintText: '예: Flutter 화면 만들기'),
          ),
          const SizedBox(height: 20),
          const Text('메모', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _NotesController,
            minLines: 4,
            maxLines: 7,
            decoration: const InputDecoration(hintText: '필요한 내용을 적어보세요.'),
          ),
          const SizedBox(height: 20),
          const Text('우선순위', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SegmentedButton<TodoPriority>(
            segments: const <ButtonSegment<TodoPriority>>[
              ButtonSegment<TodoPriority>(
                value: TodoPriority.Low,
                label: Text('낮음'),
              ),
              ButtonSegment<TodoPriority>(
                value: TodoPriority.Medium,
                label: Text('보통'),
              ),
              ButtonSegment<TodoPriority>(
                value: TodoPriority.High,
                label: Text('높음'),
              ),
            ],
            selected: <TodoPriority>{_Priority},
            onSelectionChanged: (Set<TodoPriority> Values) {
              setState(() => _Priority = Values.first);
            },
          ),
          const Spacer(),
          if (_DeleteConfirmationVisible) ...<Widget>[
            const Text(
              '이 할 일을 삭제할까요?',
              style: TextStyle(
                color: Color(0xFFD34F5A),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        setState(() => _DeleteConfirmationVisible = false),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD34F5A),
                    ),
                    onPressed: widget.OnDelete,
                    child: const Text('삭제 확인'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: <Widget>[
              if (widget.IsCreating == false)
                IconButton.outlined(
                  tooltip: '할 일 삭제',
                  onPressed: () =>
                      setState(() => _DeleteConfirmationVisible = true),
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              if (widget.IsCreating == false) const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  key: const Key('todo_save_button'),
                  onPressed: () async {
                    if (_TitleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(Context).showSnackBar(
                        const SnackBar(content: Text('할 일 제목을 입력해 주세요.')),
                      );
                      return;
                    }
                    if (widget.IsCreating) {
                      await widget.OnCreate(
                        _TitleController.text,
                        _NotesController.text,
                        _Priority,
                      );
                    } else {
                      await widget.OnUpdate(
                        _TitleController.text,
                        _NotesController.text,
                        _Priority,
                      );
                    }
                  },
                  child: Text(widget.IsCreating ? '할 일 추가' : '변경 저장'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
