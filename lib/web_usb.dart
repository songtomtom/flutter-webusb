import 'dart:async';
import 'dart:html' show Event, EventListener;
import 'dart:js' show allowInterop;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_webusb/src/web_usb.dart';

class WebUsbController {
  static const int _vendorId = 0x2fde;
  static const List<int> _productIds = [0x0003, 0x0004];
  static const int _interfaceNumber = 1;
  static const int _endpointIn = 1;
  static const int _endpointOut = 3;
  static const int _bufferSize = 256; // Set an appropriate buffer size

  static final WebUsbController _instance = WebUsbController._internal();

  final List<RequestOptionsFilter> _deviceIds = [
    RequestOptionsFilter(vendorId: _vendorId, productId: _productIds[0]),
    RequestOptionsFilter(vendorId: _vendorId, productId: _productIds[1])
  ];

  factory WebUsbController() => _instance;

  WebUsbController._internal();

  Future<void> connect() async {
    try {
      UsbDevice device = await usb.requestDevice(RequestOptions(
        filters: _deviceIds,
      ));

      // Open the device
      await device.open();
      debugPrint("Product Name: ${device.productName}");
      debugPrint("Vendor Id: ${device.vendorId}");
      debugPrint("Connected: ${device.opened}");

      final deviceConfiguration = device.configuration;

      if (deviceConfiguration == null) {
        await device.selectConfiguration(1);
      }

      var interfaceNumber = _interfaceNumber;
      var endpointOut = _endpointOut;
      var endpointIn = _endpointIn;

      if (deviceConfiguration != null) {
        final configurationInterfaces = deviceConfiguration.interfaces;

        for (var element in configurationInterfaces) {
          for (var elementalt in element.alternates) {
            if (elementalt.interfaceClass == 0xff) {
              interfaceNumber = element.interfaceNumber;
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

      await device.claimInterface(interfaceNumber);
      await device.selectAlternateInterface(interfaceNumber, 0);
      await device.controlTransferOut(ControlTransferOutSetup(
        requestType: 'class',
        recipient: 'interface',
        request: 0x22,
        value: 0x01,
        index: interfaceNumber,
      ));

      while (device.opened ?? false) {
        UsbInTransferResult transferResult =
            await device.transferIn(endpointIn, _bufferSize);
        Uint8List receivedData = transferResult.data.buffer.asUint8List();
        print('Received data: $receivedData');
      }
      // Close the device
      await device.close();
    } catch (e) {
      print('Error: $e');
    }
  }
}

final EventListener _handleConnect = allowInterop((Event event) {
  print('_handleConnect $event');
});
