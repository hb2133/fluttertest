import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertest/app/panel_layer/panel_layer_host.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_controller.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_state.dart';
import 'package:fluttertest/panels/base/todo/controller/todo_types.dart';
import 'package:fluttertest/panels/base/todo/sections/editor/todo_editor_section.dart';
import 'package:fluttertest/panels/base/todo/sections/list/todo_list_section.dart';
import 'package:fluttertest/panels/base/todo/sections/navigation/todo_navigation_section.dart';
import 'package:fluttertest/panels/base/todo/sections/toolbar/todo_toolbar_section.dart';

class TodoPanel extends StatefulWidget {
  const TodoPanel({super.key, this.Controller});

  final TodoController? Controller;

  @override
  State<TodoPanel> createState() => _TodoPanelState();
}

class _TodoPanelState extends State<TodoPanel> {
  late final TodoController _Controller;
  bool _IsCreating = false;

  @override
  void initState() {
    super.initState();
    _Controller = widget.Controller ?? TodoController();
    _Controller.Load();
  }

  @override
  void dispose() {
    if (widget.Controller == null) {
      _Controller.dispose();
    }
    super.dispose();
  }

  void _OpenCreator() {
    _Controller.SelectTodo(null);
    setState(() => _IsCreating = true);
  }

  @override
  Widget build(BuildContext Context) {
    return ListenableBuilder(
      listenable: _Controller,
      builder: (BuildContext Context, Widget? Child) {
        final TodoState State = _Controller.State;
        final bool EditorVisible = _IsCreating || State.SelectedItem != null;
        final String FilterTitle = switch (State.Filter) {
          TodoFilter.All => '모든 할 일',
          TodoFilter.Active => '진행 중인 할 일',
          TodoFilter.Completed => '완료한 할 일',
        };

        return Shortcuts(
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.keyN, control: true):
                _CreateTodoIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              _CreateTodoIntent: CallbackAction<_CreateTodoIntent>(
                onInvoke: (_CreateTodoIntent IntentValue) {
                  _OpenCreator();
                  return null;
                },
              ),
            },
            child: Focus(
              autofocus: true,
              child: PanelLayerHost(
                child: Scaffold(
                  body: SafeArea(
                    child: LayoutBuilder(
                      builder:
                          (BuildContext Context, BoxConstraints Constraints) {
                            final bool ShowNavigation =
                                Constraints.maxWidth >= 1024;
                            return Row(
                              children: <Widget>[
                                if (ShowNavigation)
                                  TodoNavigationSection(
                                    State: State,
                                    OnFilterSelected: _Controller.SetFilter,
                                  ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      TodoToolbarSection(
                                        Title: FilterTitle,
                                        OnSearchChanged:
                                            _Controller.SetSearchQuery,
                                        OnCreatePressed: _OpenCreator,
                                      ),
                                      if (State.ErrorMessage != null)
                                        MaterialBanner(
                                          content: Text(State.ErrorMessage!),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: _Controller.Load,
                                              child: const Text('다시 시도'),
                                            ),
                                          ],
                                        ),
                                      Expanded(
                                        child: State.IsLoading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : TodoListSection(
                                                State: State,
                                                OnSelected: (String Id) {
                                                  setState(
                                                    () => _IsCreating = false,
                                                  );
                                                  _Controller.SelectTodo(Id);
                                                },
                                                OnToggled:
                                                    _Controller.ToggleTodo,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (EditorVisible)
                                  TodoEditorSection(
                                    key: ValueKey<String>(
                                      _IsCreating
                                          ? 'create'
                                          : State.SelectedId!,
                                    ),
                                    Item: State.SelectedItem,
                                    IsCreating: _IsCreating,
                                    OnCreate:
                                        (
                                          String Title,
                                          String Notes,
                                          TodoPriority Priority,
                                        ) async {
                                          await _Controller.CreateTodo(
                                            Title,
                                            Notes,
                                            Priority,
                                          );
                                          if (mounted) {
                                            setState(() => _IsCreating = false);
                                          }
                                        },
                                    OnUpdate:
                                        (
                                          String Title,
                                          String Notes,
                                          TodoPriority Priority,
                                        ) => _Controller.UpdateTodo(
                                          State.SelectedId!,
                                          Title,
                                          Notes,
                                          Priority,
                                        ),
                                    OnDelete: () => _Controller.DeleteTodo(
                                      State.SelectedId!,
                                    ),
                                    OnClose: () {
                                      _Controller.SelectTodo(null);
                                      setState(() => _IsCreating = false);
                                    },
                                  ),
                              ],
                            );
                          },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CreateTodoIntent extends Intent {
  const _CreateTodoIntent();
}
