import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_puzzle/Data.dart';

import 'package:math_puzzle/main.dart';
import 'package:share_plus/share_plus.dart';

class winpage extends StatefulWidget {
  int index;

  winpage(this.index);

  @override
  State<winpage> createState() => _winpageState();
}

class _winpageState extends State<winpage> {

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/Images/background.jpg"))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "PUZZLE${widget.index} COMPLETED",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        child: Image.asset("assets/Images/trophy.png"),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(colors: [
                                  Colors.grey,
                                  Colors.white,
                                  Colors.grey
                                ])),
                            child: Text("CONTINUE",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return MathsPuzzle();
                              },
                            ));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(colors: [
                                  Colors.grey,
                                  Colors.white,
                                  Colors.grey
                                ])),
                            child: Text("MAIN MENU",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(colors: [
                                Colors.grey,
                                Colors.white,
                                Colors.grey
                              ])),
                          child: Text("BUY PRO",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "SHARE THIS PUZZLE",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w900),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(colors: [
                                  Colors.grey,
                                  Colors.white,
                                  Colors.grey
                                ])),
                            child: IconButton(
                                onPressed: () async {
                                  final byteData = await rootBundle.load(
                                      '${Data.sharepuzzle[widget.index - 1]}');
                                  var path = await ExternalPath
                                      .getExternalStoragePublicDirectory(
                                          ExternalPath.DIRECTORY_DOWNLOADS);
                                  Directory dir = Directory(path);
                                  if (await dir!.exists()) {
                                    dir.create();
                                  }
                                  File file = await File(
                                          '${dir.path}/${Data.sharepuzzle[widget.index - 1]}')
                                      .create(recursive: true);
                                  await file.writeAsBytes(byteData.buffer
                                      .asUint8List(byteData.offsetInBytes,
                                          byteData.lengthInBytes));
                                  Share.shareXFiles([XFile(file.path)]);
                                },
                                icon: Icon(Icons.share)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
