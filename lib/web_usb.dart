import 'package:flutter/cupertino.dart';
import 'package:web_usb/web_usb.dart';

class WebUSB {
  static const int _vendorId = 0x2fde;
  static const List<int> _productIds = [0x0003, 0x0004];

  static final WebUSB _instance = WebUSB._internal();

  final List<RequestOptionsFilter> _deviceIds = [
    RequestOptionsFilter(vendorId: _vendorId, productId: _productIds[0]),
    RequestOptionsFilter(vendorId: _vendorId, productId: _productIds[1])
  ];

  factory WebUSB() {
    return _instance;
  }

  WebUSB._internal();

  Future<void> connect() async {
    UsbDevice requestDevice = await usb.requestDevice(RequestOptions(
      filters: _deviceIds,
    ));
    debugPrint('requestDevice $requestDevice');
    // var device_ = requestDevice;
  }
}
