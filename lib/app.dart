import 'package:flutter/cupertino.dart';
import 'package:modi_webusb/web_usb.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebUSB webusb = WebUSB();

  Future<void> _onConnectButtonPressed() async {
    await webusb.connect();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Flutter WebUSB Test App'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.topCenter,
            child: CupertinoButton(
              color: CupertinoColors.systemGrey2,
              onPressed: () => _onConnectButtonPressed(),
              child: Text('Connect'),
            ),
          ),
        ),
      ),
    );
  }
}
