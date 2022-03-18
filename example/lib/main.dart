import 'package:get/get.dart';

class Controller extends GetxController {
  final count = 0.obs;
  void increment() => count.value++;

  @override
  void onInit() {
    print('inittt');
    super.onInit();
  }

  @override
  void onReady() {
    print('onReady');
    super.onReady();
  }

  void onClose() {
    print('onClose');
  }
}
