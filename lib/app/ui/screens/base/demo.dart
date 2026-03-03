import 'package:flutter/material.dart';
import 'package:real_time_chat/app/ui/widgets/app_scaffold.dart';

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: 'Hello', body: (context) => Text('Demo'));
  }
}
