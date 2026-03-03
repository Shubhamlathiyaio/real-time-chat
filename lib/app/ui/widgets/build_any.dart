import 'package:flutter/material.dart';

typedef ChildBuilder<T> = Widget Function(BuildContext context, T data);

class BuilderAny<T> extends Builder {
  BuilderAny({super.key, required this.child, required ChildBuilder<T> builder}) : super(builder: (context) => builder(context, child));

  final T child;
}
