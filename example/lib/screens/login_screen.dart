import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:senraise_printer_example/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool? ischecked = false;
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _bottomsheet1 =new TextEditingController(text: "http://173.249.7.219:8661");
  TextEditingController _bottomsheet2 =new TextEditingController(text: "http://vms-demo.foxit.pk");
  bool passwordObscured = true;
  void GetToken() async {
    if (_bottomsheet1.text == "http://173.249.7.219:8661") {
      var url = Uri.parse('${_bottomsheet1.text}/token');
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      var body = {
        'grant_type': 'password',
        'username': _username.text,
        'password': _password.text
      };

      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String accessToken = jsonResponse['access_token'];
        print(accessToken);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyAppHome(
                      text: "",
                      accessToken: accessToken,
                    )));
      } else {
        print('Request failed with status: ${response.statusCode}');
        showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text("Error"),
                    content: const Text('Invalid Credentials'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"))
                    ],
                  );
                }));
      }
    }else{
      showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text("Error"),
                    content: const Text('Invalid Base URL'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"))
                    ],
                  );
                }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.13),
                child: Container(
                  height: size.height * 0.87,
                  width: size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/background.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.08, left: size.width * 0.18),
                child: Container(
                    height: size.height * 0.15,
                    width: size.width * 0.6,
                    child: Image.asset("images/foxviz_delight.png")),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.34, left: size.width * 0.05),
                child: Container(
                  height: size.height * 0.55,
                  width: size.width * 0.91,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ]),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.02, left: size.width * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.w500),
                        ),
                        const Text(
                          "Please Sign in to continue",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        Container(
                          height: size.height * 0.06,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color.fromARGB(255, 240, 239, 238),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                )
                              ]),
                          child: TextFormField(
                            controller: _username,
                            decoration: const InputDecoration(
                                hintText: 'EMAIL',
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 131, 129, 129),
                                ),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xff29c6ab),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          height: size.height * 0.06,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color.fromARGB(255, 240, 239, 238),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                )
                              ]),
                          child: TextFormField(
                            controller: _password,
                            obscureText: passwordObscured,
                            decoration: InputDecoration(
                              hintText: 'PASSWORD',
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 131, 129, 129),
                              ),
                              border: InputBorder.none,
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xff29c6ab),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordObscured = !passwordObscured;
                                  });
                                },
                                icon: Icon(
                                  passwordObscured
                                      ? Icons.visibility_off
                                      : Icons.remove_red_eye_outlined,
                                  color: Color(0xff29c6ab),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            const Text(
                              "FORGOT PASSWORD",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff29c6ab)),
                            ),
                            SizedBox(
                              width: size.width * 0.08,
                            ),
                            Checkbox(
                                value: ischecked,
                                activeColor: const Color(0xff29c6ab),
                                onChanged: (newbool) {
                                  setState(() {
                                    ischecked = newbool;
                                  });
                                }),
                            const Text(
                              "REMEMBER ME",
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff29c6ab)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                GetToken();
                              },
                              child: Container(
                                height: size.height * 0.07,
                                width: size.width * 0.6,
                                decoration: BoxDecoration(
                                    color: const Color(0xff29c6ab),
                                    borderRadius: BorderRadius.circular(17.0)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.2,
                                    ),
                                    const Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.14,
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 15.0,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.45,
                                            width: double.infinity,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01),
                                              child: Column(children: [
                                                Image.asset(
                                                  "images/bottomsheetbar.PNG",
                                                  scale: 2,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.15),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "Set a connection url",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25.0),
                                                      ),
                                                      Image.asset(
                                                        "images/connection_bottomSheet.png",
                                                        scale: 2,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.07,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xfff2f2f2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          spreadRadius: 1,
                                                          blurRadius: 1,
                                                          offset: const Offset(
                                                              0, 1),
                                                        )
                                                      ]),
                                                  child: TextFormField(
                                                    controller: _bottomsheet1,
                                                    decoration: InputDecoration(
                                                      prefixIcon: Padding(
                                                        padding: EdgeInsets.only(
                                                            right: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.05,
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.03),
                                                        child: Image.asset(
                                                          "images/coonection_bottomsheet.PNG",
                                                          scale: 1.8,
                                                        ),
                                                      ),
                                                      border: InputBorder.none,
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.07,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xfff2f2f2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          spreadRadius: 1,
                                                          blurRadius: 1,
                                                          offset: const Offset(
                                                              0, 1),
                                                        )
                                                      ]),
                                                  child: TextFormField(
                                                    controller: _bottomsheet2,
                                                    decoration: InputDecoration(
                                                      prefixIcon: Padding(
                                                        padding: EdgeInsets.only(
                                                            right: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.05,
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.03),
                                                        child: Image.asset(
                                                          "images/coonection_bottomsheet.PNG",
                                                          scale: 1.8,
                                                        ),
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                                Text(
                                                  "Current Connection: ${_bottomsheet1.text}",
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.3)),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5),
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xff29c6ab)),
                                                      child: const Text(
                                                        "Submit",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                )
                                              ]),
                                            )),
                                      );
                                    });
                              },
                              child: Container(
                                height: size.height * 0.08,
                                width: size.width * 0.15,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: const Icon(
                                  Icons.settings,
                                  color: Color(0xff29c6ab),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * 0.03, left: size.width * 0.05),
                          child: Row(
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              const Text(
                                "Signup?",
                                style: TextStyle(
                                    color: Color(0xff29c6ab), fontSize: 15),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
