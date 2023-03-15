import 'package:flutter/cupertino.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
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
  final List<String> buttonTexts = [
    'Connect',
  ];

  void _onButtonPressed(String text) {
    print('$text 버튼을 눌렀습니다.');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Flutter WebUSB Test App'),
      ),
      child: SafeArea(
        child: Center(
          child: SizedBox(
            width: 300,
            child: ListView.builder(
              itemCount: buttonTexts.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton(
                    color: CupertinoColors.systemGrey2,
                    onPressed: () => _onButtonPressed(buttonTexts[index]),
                    child: Text(buttonTexts[index]),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
