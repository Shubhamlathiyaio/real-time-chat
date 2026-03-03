import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';

abstract class GetItHook<T extends GetxController> extends StatefulWidget {
  const GetItHook({super.key, T? controller}) : _controller = controller;

  @override
  State<GetItHook> createState() => _GetItHookState<T>();

  void _onInit() => onInit();
  void onInit() {}

  bool get autoDispose;

  Widget build(BuildContext context);

  T get controller => _controller ?? getIt<T>();

  final T? _controller;

  void _unRegister() {
    if (autoDispose && getIt.isRegistered<T>()) {
      getIt.resetLazySingleton<T>();
    }
  }
}

class _GetItHookState<T extends GetxController> extends State<GetItHook> {
  @override
  Widget build(BuildContext context) => widget.build(context);

  @override
  void initState() {
    super.initState();
    widget._onInit();
  }

  @override
  void dispose() {
    widget._unRegister();
    super.dispose();
  }
}

abstract class GetItHookState<T extends GetxController, S extends StatefulWidget> extends State<S> {
  T get controller => getIt<T>();

  void _unRegister() {
    if (autoDispose && getIt.isRegistered<T>()) {
      getIt.resetLazySingleton<T>();
    }
  }

  @override
  void dispose() {
    _unRegister();
    super.dispose();
  }

  bool get autoDispose;
}
