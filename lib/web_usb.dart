import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_webusb/src/web_usb.dart';

class WebUsbController {
  static const int _vendorId = 0x2fde;
  static const List<int> _productIds = [0x0003, 0x0004];
  static const int _endpointIn = 1;
  static const int _endpointOut = 3;
  static const int _bufferSize = 256; // Set an appropriate buffer size

  static final WebUsbController _instance = WebUsbController._internal();

  final List<RequestOptionsFilter> _deviceIds = [
    RequestOptionsFilter(vendorId: _vendorId, productId: _productIds[0]),
    RequestOptionsFilter(vendorId: _vendorId, productId: _productIds[1])
  ];

  int _interfaceNumber = 1;
  UsbDevice? _device;

  factory WebUsbController() => _instance;

  WebUsbController._internal();

  Future<void> connect() async {
    try {
      _device = await usb.requestDevice(RequestOptions(
        filters: _deviceIds,
      ));

      // Open the device

      await _device?.open();
      debugPrint("Product Name: ${_device?.productName}");
      debugPrint("Vendor Id: ${_device?.vendorId}");
      debugPrint("Connected: ${_device?.opened}");

      final deviceConfiguration = _device?.configuration;

      if (deviceConfiguration == null) {
        await _device?.selectConfiguration(1);
      }

      var endpointOut = _endpointOut;
      var endpointIn = _endpointIn;

      if (deviceConfiguration != null) {
        final configurationInterfaces = deviceConfiguration.interfaces;

        for (var element in configurationInterfaces) {
          for (var elementalt in element.alternates) {
            if (elementalt.interfaceClass == 0xff) {
              _interfaceNumber = element.interfaceNumber;
              for (var elementendpoint in elementalt.endpoints) {
                if (elementendpoint.direction == "out") {
                  endpointOut = elementendpoint.endpointNumber;
                } else if (elementendpoint.direction == "in") {
                  endpointIn = elementendpoint.endpointNumber;
                }
              }
            }
          }
        }
      }

      await _device?.claimInterface(_interfaceNumber);
      await _device?.selectAlternateInterface(_interfaceNumber, 0);
      await _device?.controlTransferOut(ControlTransferOutSetup(
        requestType: 'class',
        recipient: 'interface',
        request: 0x22,
        value: 0x01,
        index: _interfaceNumber,
      ));

      while (_device?.opened ?? false) {
        var transferResult = await _device?.transferIn(endpointIn, _bufferSize);
        var receivedData = transferResult?.data.buffer.asUint8List();
        print('Received data: $receivedData');
      }
      // Close the device
      await _device?.close();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> disconnect() async {
    await _device?.controlTransferOut(ControlTransferOutSetup(
      requestType: 'class',
      recipient: 'interface',
      request: 0x22,
      value: 0x00,
      index: _interfaceNumber,
    ));
    await _device?.close();
  }
}
