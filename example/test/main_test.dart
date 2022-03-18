import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_test/get_test.dart';

void main() {
  getTest(
    "test description",
    widgetTest: (tester) async {
      expect('/', Get.currentRoute);

      Get.toNamed('/Container');
      expect('/Container', Get.currentRoute);

      Get.toNamed('/Scaffold');
      expect('/Scaffold', Get.currentRoute);

      Get.back();

      expect('/Container', Get.currentRoute);
    },
  );

  testGetX(
    'GetX test',
    widget: GetX<Controller>(
      init: Controller(),
      builder: (controller) {
        return Text("ban:${controller.count}");
      },
    ),
    test: (e) {
      expect(find.text("ban:0"), findsOneWidget);
      expect(e.count.value, 0);
    },
  );

  testGetBuilder(
    'GetBuilder test',
    widget: GetBuilder<Controller>(
      init: Controller(),
      builder: (controller) {
        return Text("ban:${controller.count}");
      },
    ),
    test: (e) {
      expect(find.text("ban:0"), findsOneWidget);
      expect(e.count.value, 0);
    },
  );

  testObx(
    'Obx test',
    widget: (controller) => Obx(
      () => Text("ban:${controller.count}"),
    ),
    controller: Controller(),
    test: (e) {
      expect(find.text("ban:0"), findsOneWidget);
      expect(e.count.value, 0);
    },
  );

  testController<Controller>(
    'Controller test',
    (controller) {},
    controller: Controller(),
    onInit: (c) {
      c.increment();
      print('onInit');
    },
    onReady: (c) {
      print('onReady');
      c.increment();
    },
    onClose: (c) {
      print('onClose');
    },
  );
}
