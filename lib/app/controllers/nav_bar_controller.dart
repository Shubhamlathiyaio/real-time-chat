import 'package:get/get.dart';
import 'package:injectable/injectable.dart';


@lazySingleton
class NavBarController extends GetxController {
  final RxInt _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int value) => _selectedIndex.value = value;
}