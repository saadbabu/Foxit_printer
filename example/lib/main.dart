import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:senraise_printer/senraise_printer.dart';
import 'package:senraise_printer_example/screens/form.dart';
import 'package:senraise_printer_example/screens/result_screen.dart';
import 'package:senraise_printer_example/screens/scan.dart';
import 'package:senraise_printer_example/screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: Mysplash());
  }
}

class MyAppHome extends StatefulWidget {
  final String text;
  final String accessToken;
  const MyAppHome({super.key, required this.text, required this.accessToken});

  @override
  _MyAppHomeState createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  final _senraisePrinterPlugin = SenraisePrinter();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("My App Home Screen Token: ${widget.accessToken}");
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.28,
            width: double.maxFinite,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/foxviz_back.png"),
                    fit: BoxFit.fill)),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.width * 0.05),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 219, 213, 213),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("images/person_img.png"),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.07,
                      left: MediaQuery.of(context).size.width * 0.33),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tariq Nabeel",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      Text(
                        "Foxit Head Ofice",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                      left: MediaQuery.of(context).size.width * 0.8),
                  child: const Icon(
                    Icons.settings,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.25),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20.0),
                        image: const DecorationImage(
                            image: AssetImage("images/home_back.PNG"),
                            fit: BoxFit.cover)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.45,
                      right: MediaQuery.of(context).size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 1))
                                ]),
                            child: Image.asset(
                              "images/card_back.PNG",
                              scale: 1.5,
                            ),
                          ),
                          const Text("Personal Guest")
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 1))
                                ]),
                            child: Image.asset(
                              "images/card_back.PNG",
                              scale: 1.5,
                            ),
                          ),
                          const Text("Vendor pass")
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 1))
                                ]),
                            child: Image.asset(
                              "images/card_back.PNG",
                              scale: 1.5,
                            ),
                          ),
                          const Text("Gate pass")
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.65,
                      right: MediaQuery.of(context).size.width * 0.05),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "images/bottomsheetbar.PNG",
                                                scale: 2,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => MyForm(
                                                            accessToken: widget
                                                                .accessToken)),
                                                  );
                                                },
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.85,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          spreadRadius: 2,
                                                          blurRadius: 10,
                                                          offset: const Offset(
                                                              0, 5),
                                                        )
                                                      ]),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                            "CLICK HERE TO CREATE"),
                                                        Image.asset(
                                                          "images/bottomsheet1.PNG",
                                                          scale: 3,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.85,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          spreadRadius: 2,
                                                          blurRadius: 10,
                                                          offset: const Offset(
                                                              0, 5),
                                                        )
                                                      ]),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                            "CLICK HERE TO EDIT"),
                                                        Image.asset(
                                                          "images/bottomsheet2.PNG",
                                                          scale: 3,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.08,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        spreadRadius: 2,
                                                        blurRadius: 10,
                                                        offset:
                                                            const Offset(0, 5),
                                                      )
                                                    ]),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                          "CLICK HERE TO VIEW"),
                                                      Image.asset(
                                                        "images/bottomsheet2.PNG",
                                                        scale: 3,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                  });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 1))
                                  ]),
                              child: Image.asset(
                                "images/card_back.PNG",
                                scale: 1.5,
                              ),
                            ),
                          ),
                          const Text("Walk in visitor")
                        ])
                      ]),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
