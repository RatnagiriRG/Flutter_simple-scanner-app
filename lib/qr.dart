import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';

class QRreader extends StatefulWidget {
  const QRreader({super.key});

  @override
  State<QRreader> createState() => _QRreaderState();
}

class _QRreaderState extends State<QRreader> {
  late ImagePicker imagePicker;
  File? _image;
  String result = 'results will be shown here';
  dynamic barcodeScanner;
  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();

    final List<BarcodeFormat> formats = [BarcodeFormat.all];
    barcodeScanner = BarcodeScanner(formats: formats);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doBarcodeScanning();
    });
  }

  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doBarcodeScanning();
      });
    }
  }

  doBarcodeScanning() async {
    result = '';
    InputImage inputImage = InputImage.fromFile(_image!);
    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);

    for (Barcode barcode in barcodes) {
      final BarcodeType type = barcode.type;
      final Rect boundingBox = barcode.boundingBox;
      final String? displayValue = barcode.displayValue;
      final String? rawValue = barcode.rawValue;
      if (type case BarcodeType.wifi) {
        final barcodeWifi = barcode.value as BarcodeWifi;
        // ignore: prefer_interpolation_to_compose_strings
        result = 'ssid : ' +
            barcodeWifi.ssid! +
            "\n password :, " +
            barcodeWifi.password!;
        break;
      } else if (type case BarcodeType.url) {
        final barcodeUrl = barcode.value as BarcodeUrl;
        result = 'URL  :${barcodeUrl.url!} \n title :${barcodeUrl.title!}';
        break;
      } else if (type
          case BarcodeType.unknown ||
              BarcodeType.contactInfo ||
              BarcodeType.email) {}
      setState(() {
        result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal, Colors.cyanAccent],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 55, left: 30, right: 30, bottom: 30),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 23, 200, 182),
                      Color.fromARGB(255, 8, 74, 74)
                    ],
                  ),
                ),
                width: 500,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    color: const Color.fromARGB(114, 250, 250, 250),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onLongPress: _imgFromCamera,
                      onPressed: _imgFromGallery,
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image_search),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                result,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
