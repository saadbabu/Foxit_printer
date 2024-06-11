import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:senraise_printer_example/model/model.dart';
import 'package:senraise_printer_example/model/post_image.dart';
import 'package:senraise_printer_example/screens/form_response.dart';
import 'package:senraise_printer_example/screens/scan.dart';
import 'package:http_parser/http_parser.dart';

class MyForm extends StatefulWidget {
  final String accessToken;
  const MyForm({required this.accessToken});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  late Future<List<PayloadModel>> _futureForms;
  late String currentDate = DateTime.now().toString();
  late PayloadModel? firstForm;
  late List<String?> enteredValues;
  late TextEditingController cnicController;
  late String todaysdate = "";
  late File _image;
  int id = 0;
  String fileUrl ="";
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _futureForms = _fetchForms();
    print("Form Screen token: ${widget.accessToken}");

    cnicController = TextEditingController();
    _futureForms.then((forms) {
      firstForm = forms.last;
      enteredValues = List.generate(
        firstForm!.formTemplate!.length,
        (index) {
          // Set initial value for the 3rd last text field to current date
          if (index == firstForm!.formTemplate!.length - 3 ||
              index == firstForm!.formTemplate!.length - 2) {
            return DateTime.now().toString().split(" ")[0];
          }
          return '';
        },
      );
    });
  }

  @override
  void dispose() {
    cnicController.dispose();
    super.dispose();
  }

  bool _isCNIC(String input) {
    RegExp cnicRegex = RegExp(r'^\d{5}-\d{7}-\d$');
    return cnicRegex.hasMatch(input);
  }

  //Post Method for Image
  Future<void> _sendImageData(File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://173.249.7.219:8665/File/UploadImage'));
    var multipartFile = await http.MultipartFile.fromPath(
      'document',
      imageFile.path,
      // filename: 'image.jpg', // Adjust filename as needed
      contentType: MediaType(
          'image', 'jpeg'), // Adjust content type as per your image type
    );
    request.files.add(multipartFile);
    var response = await request.send();

    // Read response stream as string
    var responseString = await response.stream.bytesToString();

    // Check the response status
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      // Print the response string to understand its content
      print('Response: $responseString');
      _extractFileUrl(responseString);
      _extractid(responseString);
    } else {
      print("statusCode:${response.statusCode}");
      print('Failed to upload image');
    }
  }

  //function for extracting Id of image from json response
void _extractFileUrl(String responseString) {
  try {
    List<dynamic> jsonResponse = jsonDecode(responseString);
    if (jsonResponse.isNotEmpty) {
      fileUrl = jsonResponse[0]['FileUrl'];
      print('FileUrl: $fileUrl');
    } else {
      print('No objects found in the response.');
    }
  } catch (e) {
    print('Error decoding JSON: $e');
  }
}

void _extractid(String responseString) {
  try {
    List<dynamic> jsonResponse = jsonDecode(responseString);
    if (jsonResponse.isNotEmpty) {
      id = jsonResponse[0]['Id'];
      print('FileUrl: $id');
    } else {
      print('No objects found in the response.');
    }
  } catch (e) {
    print('Error decoding JSON: $e');
  }
}

  //get Method for fetching forms
  Future<List<PayloadModel>> _fetchForms() async {
    try {
      final response = await http.get(
        Uri.parse('http://173.249.7.219:8661/api/Form/GetUserForms'),
        headers: {
          'Authorization': 'bearer ${widget.accessToken}',
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        final payload = payloadModelFromJson(response.body);
        firstForm = payload.last;
        enteredValues = List.generate(
          firstForm!.formTemplate!.length,
          (index) => '',
        );

        return payload;
      } else {
        throw Exception('Failed to fetch forms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch forms: $e');
    }
  }

  Future<void> _postData(String id) async {
    try {
      List<Map<String, String>> formCollection = [];

      for (var i = 0; i < enteredValues.length; i++) {
        formCollection.add({
          'Key': firstForm!.formTemplate![i].controlName ?? '',
          'Value': i == enteredValues.length - 1
              ? "http://173.249.7.219:8665//Uploads/ProfileImages/638508716036623354e5d7748a-7000-4b58-84df-3f5700f5a4cc7051517263162021206.jpg"
              :enteredValues[i] ?? '',
        });
      }

      final requestData = {
        'FormCollection': formCollection,
        'FormDetails': '[]',
        'FormTypeId': '12',
      };

      final response = await http.post(
        Uri.parse('http://173.249.7.219:8661/api/Form/Initiate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'bearer ${widget.accessToken}',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == HttpStatus.ok) {
        print('Data posted successfully');
        print("form collection ${formCollection}");
        print(response.body);
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String formId = jsonResponse['Exception'];
        print(formId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Formrespnse(
              formId: formId,
              accessToken: widget.accessToken,
            ),
          ),
        );
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  //function for getting image
  Future getImage() async {
    final pickerImage = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickerImage != null) {
        _image = File(pickerImage.path);
        _sendImageData(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/foxviz_back.png"),
                        fit: BoxFit.fill)),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Scan()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03,
                      left: MediaQuery.of(context).size.width * 0.85),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 33,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.09,
                    left: MediaQuery.of(context).size.width * 0.17),
                child: const Text(
                  "Walk In Visitor Form",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: FutureBuilder<List<PayloadModel>>(
                  future: _futureForms,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final forms = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Walk In Visitor Form",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff00beb2),
                                  fontWeight: FontWeight.bold),
                            ),
                            if (firstForm != null) ...[
                              for (var i = 0;
                                  i < firstForm!.formTemplate!.length;
                                  i++)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: i ==
                                          firstForm!.formTemplate!.length - 2
                                      ? Container(
                                          child: Row(children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    TextEditingController(
                                                  text: enteredValues[i] ?? '',
                                                ),
                                                decoration: InputDecoration(
                                                  labelText: firstForm!
                                                          .formTemplate![i]
                                                          .controlName ??
                                                      '',
                                                  hintText: firstForm!
                                                          .formTemplate![i]
                                                          .placeHolder ??
                                                      '',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      const Color.fromARGB(
                                                          255, 252, 249, 249),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 10.0,
                                                  ),
                                                ),
                                                readOnly:
                                                    true, // Make it read-only to prevent manual input
                                              ),
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2),
                                            InkWell(
                                              onTap: () {
                                                selectFdate();
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 252, 249, 249),
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
                                                child: const Icon(
                                                  Icons.calendar_month_outlined,
                                                  color: Color(0xff00beb2),
                                                ),
                                              ),
                                            )
                                          ]),
                                        )
                                      : i == firstForm!.formTemplate!.length - 3
                                          ? Row(children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                    text:
                                                        enteredValues[i] ?? '',
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText: firstForm!
                                                            .formTemplate![i]
                                                            .controlName ??
                                                        '',
                                                    hintText: firstForm!
                                                            .formTemplate![i]
                                                            .placeHolder ??
                                                        '',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        const Color.fromARGB(
                                                            255, 252, 249, 249),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 10.0,
                                                    ),
                                                  ),
                                                  readOnly:
                                                      true, // Make it read-only to prevent manual input
                                                ),
                                              ),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2),
                                              InkWell(
                                                onTap: () {
                                                  selectTdate();
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.07,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              252,
                                                              249,
                                                              249),
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
                                                  child: const Icon(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    color: Color(0xff00beb2),
                                                  ),
                                                ),
                                              )
                                            ])
                                          : i ==
                                                  firstForm!.formTemplate!
                                                          .length -
                                                      1
                                              ? Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        getImage();
                                                      },
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 1.0),
                                                            color: const Color
                                                                .fromARGB(255,
                                                                243, 237, 237),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0)),
                                                        child: const Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Choose file",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : i ==
                                                      firstForm!.formTemplate!
                                                              .length -
                                                          1
                                                  ? TextFormField(
                                                      controller: i == 0
                                                          ? cnicController
                                                          : null,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: firstForm!
                                                                .formTemplate![
                                                                    i]
                                                                .controlName ??
                                                            '',
                                                        hintText: firstForm!
                                                                .formTemplate![
                                                                    i]
                                                                .placeHolder ??
                                                            '',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        filled: true,
                                                        fillColor: const Color
                                                            .fromARGB(
                                                            255, 252, 249, 249),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0,
                                                                horizontal:
                                                                    10.0),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          enteredValues[i] =
                                                              value;
                                                        });
                                                      },
                                                      keyboardType: i == 0
                                                          ? TextInputType.number
                                                          : TextInputType.text,
                                                      inputFormatters: i == 0
                                                          ? [CNICFormatter()]
                                                          : null,
                                                    )
                                                  : TextFormField(
                                                      controller: i == 0
                                                          ? cnicController
                                                          : null,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: firstForm!
                                                                .formTemplate![
                                                                    i]
                                                                .controlName ??
                                                            '',
                                                        hintText: firstForm!
                                                                .formTemplate![
                                                                    i]
                                                                .placeHolder ??
                                                            '',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        filled: true,
                                                        fillColor: const Color
                                                            .fromARGB(
                                                            255, 252, 249, 249),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0,
                                                                horizontal:
                                                                    10.0),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          enteredValues[i] =
                                                              value;
                                                        });
                                                      },
                                                      keyboardType: i == 0
                                                          ? TextInputType.number
                                                          : TextInputType.text,
                                                      inputFormatters: i == 0
                                                          ? [CNICFormatter()]
                                                          : null,
                                                    ),
                                ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff00beb2)),
                                onPressed: () {
                                  bool allFieldsFilled = true;
                                  for (var i = 0;
                                      i < enteredValues.length - 1;
                                      i++) {
                                    if (i == 0 &&
                                        (enteredValues[i] == null ||
                                            enteredValues[i]!.isEmpty ||
                                            !_isCNIC(enteredValues[i]!))) {
                                      allFieldsFilled = false;
                                      break;
                                    } else if (enteredValues[i] == null ||
                                        enteredValues[i]!.isEmpty) {
                                      allFieldsFilled = false;
                                      break;
                                    }
                                  }
                                  if (allFieldsFilled) {
                                    if (snapshot.hasData) {
                                      _postData(id.toString());
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Error"),
                                        content: const Text(
                                            'Please fill in all fields correctly'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Close"),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Next',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectTdate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    print("pickdate: $pickedDate");
    if (pickedDate != null) {
      print("setstate is been called");
      setState(() {
        if (firstForm != null && firstForm!.formTemplate != null) {
          int toDateIndex = firstForm!.formTemplate!.length - 3;
          if (toDateIndex >= 0 && toDateIndex < enteredValues.length) {
            enteredValues[toDateIndex] = pickedDate.toString().split(" ")[0];
          }
        }
      });
    }
  }

  Future<void> selectFdate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    print("pickdate: $pickedDate");
    if (pickedDate != null) {
      print("setstate is been called");
      setState(() {
        if (firstForm != null && firstForm!.formTemplate != null) {
          int toDateIndex = firstForm!.formTemplate!.length - 2;
          if (toDateIndex >= 0 && toDateIndex < enteredValues.length) {
            enteredValues[toDateIndex] = pickedDate.toString().split(" ")[0];
          }
        }
      });
    }
  }
}

class CNICFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    if (text.length >= 5) {
      buffer.write(text.substring(0, 5) + '-');
      if (text.length >= 12) {
        buffer.write(text.substring(5, 12) + '-');
        if (text.length >= 13) {
          buffer.write(text.substring(12, 13));
        }
      } else {
        buffer.write(text.substring(5));
      }
    } else {
      buffer.write(text);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
