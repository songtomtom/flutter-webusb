import 'dart:async';
import 'dart:html';
import 'dart:js';

import 'package:web_usb/web_usb.dart';

class WebUSB {
  static const int _vendorId = 0x2fde;
  static const List<int> _productIds = [0x0003, 0x0004];

  static final WebUSB _instance = WebUSB._internal();

  final List<RequestOptionsFilter> _deviceIds = [
    RequestOptionsFilter(vendorId: _vendorId, productId: _productIds[0]),
    RequestOptionsFilter(vendorId: _vendorId, productId: _productIds[1])
  ];

  factory WebUSB() => _instance;

  WebUSB._internal();

  Future<void> connect() async {
    try {
      // Request an Arduino device
      UsbDevice device = await usb.requestDevice(RequestOptions(
        filters: _deviceIds,
      ));

      // Open the device
      await device.open();
      print('Open device: $device');
      // Select the configuration (usually 1)
      await device.selectConfiguration(1);
      // Claim the interface (usually 0)
      int interfaceNumber = 1;
      await device.claimInterface(interfaceNumber);
      // Find the endpoints
      int endpointIn = 1;
      int endpointOut = 3;
      // Receive data
      int bufferSize = 256; // Set an appropriate buffer size

      // UsbInTransferResult transferResult =
      //     await device.transferIn(endpointIn, bufferSize);
      // Uint8List receivedData = transferResult.data.buffer.asUint8List();
      // print('Received data: $receivedData');
      // Close the device
      await device.close();
      print('Close device: ${device}');
    } catch (e) {
      print('Error: $e');
    }
  }
}

final EventListener _handleConnect = allowInterop((Event event) {
  print('_handleConnect $event');
});
