import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import 'utils/image_test.dart';

/// This allows a value of type T or T?
/// to be treated as a value of type T?.
///
/// We use this so that APIs that have become
/// non-nullable can still be used with `!` and `?`
/// to support older versions of the API as well.
T? _ambiguate<T>(T? value) => value;

class _Wrapper extends StatelessWidget {
  final Widget child;
  final List<GetPage>? getPages;
  final String? initialRoute;

  const _Wrapper({
    Key? key,
    this.child = const Scaffold(),
    this.getPages,
    this.initialRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: initialRoute,
      getPages: getPages ?? [GetPage(name: '/', page: () => child)],
    );
  }
}

@isTest
void testController<T>(
  String description,
  void Function(T) callback, {
  required T controller,
  void Function(T)? onInit,
  void Function(T)? onReady,
  void Function(T)? onClose,
}) {
  test(description, () {
    onInit?.call(controller);
    _ambiguate(SchedulerBinding.instance)?.addPostFrameCallback((f) {
      onReady?.call(controller);
    });
    callback(controller);
    onClose?.call(controller);
  });
}

@isTest
Future<T?> testGetX<T extends DisposableInterface>(
  String description, {
  required GetX<T> widget,
  required void Function(T controller) test,
}) async {
  T? controller;
  testWidgets(description, (tester) async {
    provideMockedNetworkImages(() async {
      await tester.pumpWidget(GetMaterialApp(home: widget));
      final controller = Get.find<T>();
      test(controller);
    });
  });
  return controller;
}

@isTest
Future<T?> testGetBuilder<T extends GetxController>(
  String description, {
  required GetBuilder<T> widget,
  required void Function(T controller) test,
}) async {
  T? controller;
  testWidgets(description, (tester) async {
    provideMockedNetworkImages(() async {
      await tester.pumpWidget(GetMaterialApp(home: widget));
      final controller = Get.find<T>();
      test(controller);
    });
  });
  return controller;
}

@isTest
Future<T> testObx<T extends GetxController>(
  String description, {
  required T controller,
  required Obx Function(T controller) widget,
  required void Function(T controller) test,
}) async {
  testWidgets(description, (tester) async {
    provideMockedNetworkImages(() async {
      await tester.pumpWidget(GetMaterialApp(home: widget(controller)));
      test(controller);
    });
  });
  return controller;
}

@isTest
void getTest(
  String description, {
  required WidgetTesterCallback widgetTest,
  Widget? wrapper,
  List<GetPage>? getPages,
  String initialRoute = '/',
  bool skip = false,
  Timeout? timeout,
  Duration? initialTimeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
}) {
  assert(variant.values.isNotEmpty);

  if (wrapper == null) {
    if (getPages != null) {
      wrapper = _Wrapper(getPages: getPages, initialRoute: initialRoute);
    } else if (getPages != null) {
      wrapper = _Wrapper(initialRoute: initialRoute, getPages: getPages);
    } else {
      wrapper = _Wrapper();
    }
  }

  testWidgets(
    description,
    (tester) async {
      provideMockedNetworkImages(() async {
        await tester.pumpWidget(wrapper!);
        widgetTest(tester);
      });
    },
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
  );
}
