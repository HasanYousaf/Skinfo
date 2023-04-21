import 'package:final_project/models/product.dart';
import 'package:final_project/screens/ingredients_view.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:final_project/screens/camera_view.dart';
import 'package:final_project/text_detection/text_detector_painter.dart';


  Product? product;
class TextRecognizerView extends StatefulWidget {
  const TextRecognizerView({super.key});

  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView> {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  String recognized = "";
  String? scanned;

  @override
  void dispose() async {
    _canProcess = false;
    scanned = recognized;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Scan Product Label',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) async {
        await processImage(inputImage);
        if (recognized != "") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IngredientsView(scanned: recognized)));
        }
      },

    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
      recognized;
      print("scanned = $scanned");
      print ("recognized = $recognized");
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
      recognized = recognizedText.text;
    recognized = recognized.split('\n').join(' ');
      scanned = recognized;
      print ("scanned1 = $scanned");
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = TextRecognizerPainter(
          recognizedText,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Recognized text:\n\n$recognized';
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {scanned = recognized;});
    }

  }
}
