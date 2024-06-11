import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:senraise_printer_example/model/IdForm_model.dart';
import 'package:senraise_printer/senraise_printer.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class Formrespnse extends StatefulWidget {
  final String formId;
  final String accessToken;
  const Formrespnse({required this.formId, required this.accessToken});

  @override
  State<Formrespnse> createState() => _FormrespnseState();
}

class _FormrespnseState extends State<Formrespnse> {
  GetFormById? responseData;
  final _senraisePrinterPlugin = SenraisePrinter();

  @override
  void initState() {
    super.initState();
    fetchFormData(); // Fetch form data when the widget initializes
  }

  Future<void> fetchFormData() async {
    String api =
        "http://173.249.7.219:8661/api/Form/GetFormByFormId?FormId=${widget.formId}";
    var url = Uri.parse(api);
    var headers = {
      'Authorization': 'bearer ${widget.accessToken}',
    };
    print(widget.formId);
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        responseData = GetFormById.fromJson(jsonDecode(response.body));
        
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> printFormData() async {
    if (responseData != null) {
      await _senraisePrinterPlugin.setTextBold(true);
      await _senraisePrinterPlugin.setTextSize(15);

      for (var data in responseData!.formCollection!) {
        await _senraisePrinterPlugin
            .printText("${data.key}:" + "\n" + "${data.value}" + "\n\n");
            SenraisePrinter().setTextBold(true);
            
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Response'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  // Load the image from asset bundle
                  ByteData imageData =
                      await rootBundle.load('images/ideas_logo.png');
                  Uint8List imageDataList = imageData.buffer.asUint8List();

                  // Resize the image to fit M80 paper dimensions
                  Uint8List resizedImageData = resizeImage(imageDataList, 300,
                      300); // M80 paper dimensions: 576 pixels width, 80 pixels height

                  // Print the resized image
                  await _senraisePrinterPlugin.printPic(resizedImageData);
                  await _senraisePrinterPlugin.printText("\n");
                  await printFormData();
                  await _senraisePrinterPlugin.printText("\n\n");
                } catch (e) {
                  // Handle printing errors
                  print("Printing error: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Error printing. Please try again later.')),
                  );
                }
              },
              child: const Text("Call Api"),
            ),
            if (responseData != null)
              Expanded(
                child: ListView.builder(
                  itemCount: responseData!.formCollection!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(responseData!.formCollection![index].key ?? ''),
                      subtitle: Text(
                          responseData!.formCollection![index].value ?? ''),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Uint8List resizeImage(
      Uint8List imageData, int targetWidth, int targetHeight) {
    img.Image image = img.decodeImage(imageData)!;
    img.Image resizedImage =
        img.copyResize(image, width: targetWidth, height: targetHeight);
    return Uint8List.fromList(img.encodePng(resizedImage));
  }
}
