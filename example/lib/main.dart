import 'package:flutter/material.dart';
import 'package:image_firework/image_firework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Image Firework Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // set list or inject from another widget
  // this is set for debugging
  static List<String> animatingImageUriList = [
    'assets/image_1.png',
    'assets/image_2.png',
    'assets/image_3.png',
    'assets/image_4.png',
    'assets/image_5.png',
  ];

  List<int> animatingImageCountList = [0, 0, 0, 0, 0];

  ImageFireWorkManager imageFireWorkManager =
      ImageFireWorkManager(animatingImageUriList: animatingImageUriList);

  void _addFireworkBomb(Offset generatePosition) {
    if (animatingImageCountList.where((x) => x != 0).isEmpty) {
      return;
    }

    setState(() {
      imageFireWorkManager.addFireworkWidget(
        offset: generatePosition,
        animatingImageCountList: animatingImageCountList,
      );

      animatingImageCountList = List<int>.generate(
        animatingImageCountList.length,
        (index) => 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          IgnorePointer(
            child: Stack(
              children: imageFireWorkManager.fireworkWidgets.values.toList(),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTapUp: (details) {
                        _addFireworkBomb(details.localPosition);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: Colors.transparent,
                        ),
                        child: const Center(
                          child: Text(
                            "Press Screen To Shoot Firwork",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Set Firework Image Ingredient',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                      children: List<Widget>.generate(
                          animatingImageUriList.length, (index) {
                    return Expanded(
                      child: Column(
                        children: [
                          Text("${animatingImageCountList[index]}"),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  animatingImageCountList[index] += 1;
                                });
                              },
                              child: Image.asset(
                                animatingImageUriList[index],
                                width: 25,
                                height: 25,
                              ))
                        ],
                      ),
                    );
                  })),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
