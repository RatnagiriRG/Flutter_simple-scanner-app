import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabel extends StatefulWidget {
  const ImageLabel({super.key});

  @override
  State<ImageLabel> createState() => _ImageLabelState();
}

class _ImageLabelState extends State<ImageLabel> {
  late ImagePicker imagePicker;
  File? _image;
  String result = 'Results will be shown here';


  dynamic imageLabeler;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.8);
    imageLabeler = ImageLabeler(options: options);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //TODO capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doImageLabeling();
    });
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doImageLabeling();
      });
    }
  }

  //TODO image labeling code here
  doImageLabeling() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    result = "";
    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;

      result += "$text  ${confidence.toStringAsFixed(3)}\n";
    }
    setState(() {
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 58, 1, 1),
            Color.fromARGB(255, 247, 89, 97)
          ],
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
                      Color.fromARGB(255, 227, 11, 58),
                      Color.fromARGB(255, 23, 1, 1)
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
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
