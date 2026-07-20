import 'package:flutter/material.dart';
import 'package:fluttertest/design/global_design.dart';
import 'package:fluttertest/panels/base/todo/todo_panel.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext Context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Desktop',
      theme: GlobalDesign.CreateTheme(),
      home: const TodoPanel(),
    );
  }
}
