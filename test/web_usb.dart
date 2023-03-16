// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransferIn', () {
    test('"receivedData" JSON 변환', () {
      Uint8List uint8List = Uint8List.fromList([
        123,
        34,
        99,
        34,
        58,
        48,
        44,
        34,
        115,
        34,
        58,
        50,
        48,
        52,
        57,
        44,
        34,
        100,
        34,
        58,
        48,
        44,
        34,
        98,
        34,
        58,
        34,
        47,
        103,
        65,
        67,
        65,
        65,
        61,
        61,
        34,
        44,
        34,
        108,
        34,
        58,
        52,
        125
      ]);

      var result = String.fromCharCodes(uint8List);
      expect('{"c":0,"s":2049,"d":0,"b":"/gACAA==","l":4}', result);
    });
  });
}
