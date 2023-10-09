

import 'package:flutter/material.dart';
import 'package:simple_scanner/Image.dart';
import 'package:simple_scanner/qr.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectpageIndex = 0;
  void selectpage(int index) {
    setState(() {
      selectpageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activepage = const QRreader();
    if (selectpageIndex == 1) {
      activepage = const ImageLabel();
    }
  

    return MaterialApp(
      theme: ThemeData().copyWith(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: activepage,
        bottomNavigationBar: BottomNavigationBar(
            mouseCursor: MaterialStateMouseCursor.clickable,
            selectedFontSize: 15,
            backgroundColor: selectpageIndex == 0
                ? const Color.fromARGB(35, 0, 187, 212)
                : selectpageIndex == 1
                    ? const Color.fromARGB(62, 244, 67, 54)
                    : const Color.fromARGB(50, 31, 255, 1),
            currentIndex: selectpageIndex,
            selectedItemColor: selectpageIndex == 0
                ? Colors.blue
                : selectpageIndex == 1
                    ? Colors.red
                    : const Color.fromARGB(255, 162, 255, 2),
            onTap: selectpage,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code), label: 'QrCode'),
                  
              BottomNavigationBarItem(
                  icon: Icon(Icons.image_search_sharp), label: 'Label'),
                 
                 
            ]),
      ),
    );
  }
}
