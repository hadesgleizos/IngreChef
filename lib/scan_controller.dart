// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;
// import 'dart:typed_data';
//
// class VegetableDetector extends StatefulWidget {
//   @override
//   _VegetableDetectorState createState() => _VegetableDetectorState();
// }
//
// class _VegetableDetectorState extends State<VegetableDetector> {
//   late CameraController _cameraController;
//   late Interpreter _interpreter;
//   List<dynamic>? _recognitions;
//   bool _isDetecting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _loadModel();
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//     _cameraController = CameraController(
//       firstCamera,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//     await _cameraController.initialize();
//     if (!mounted) return;
//     setState(() {});
//     _cameraController.startImageStream(_processCameraImage);
//   }
//
//   Future<void> _loadModel() async {
//     _interpreter = await Interpreter.fromAsset('assets/your_model.tflite');
//   }
//
//   void _processCameraImage(CameraImage image) {
//     if (_isDetecting) return;
//     _isDetecting = true;
//     _detectVegetables(image);
//   }
//
//   Future<void> _detectVegetables(CameraImage image) async {
//     var inputImage = _preProcessImage(image);
//     var outputShape = _interpreter.getOutputTensor(0).shape;
//     var output = List.filled(outputShape.reduce((a, b) => a * b), 0.0).reshape(outputShape);
//
//     _interpreter.run(inputImage, output);
//
//     var results = _postProcessResults(output);
//
//     setState(() {
//       _recognitions = results;
//     });
//
//     _isDetecting = false;
//   }
//
//   List<double> _preProcessImage(CameraImage image) {
//     var img = _convertYUV420ToImage(image);
//     var resizedImg = img.copyResize(width: 416, height: 416);
//
//     var inputBytes = Float32List(1 * 416 * 416 * 3);
//     var inputTensor = inputBytes.buffer.asFloat32List();
//
//     for (var y = 0; y < resizedImg.height; y++) {
//       for (var x = 0; x < resizedImg.width; x++) {
//         var pixel = resizedImg.getPixel(x, y);
//         inputTensor[(y * 416 + x) * 3] = pixel.r / 255.0;
//         inputTensor[(y * 416 + x) * 3 + 1] = pixel.g / 255.0;
//         inputTensor[(y * 416 + x) * 3 + 2] = pixel.b / 255.0;
//       }
//     }
//
//     return inputTensor;
//   }
//
//   img.Image _convertYUV420ToImage(CameraImage image) {
//     final int width = image.width;
//     final int height = image.height;
//     final int uvRowStride = image.planes[1].bytesPerRow;
//     final int uvPixelStride = image.planes[1].bytesPerPixel!;
//
//     var img = img.Image(width, height);
//
//     for (int x = 0; x < width; x++) {
//       for (int y = 0; y < height; y++) {
//         final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
//         final int index = y * width + x;
//
//         final yp = image.planes[0].bytes[index];
//         final up = image.planes[1].bytes[uvIndex];
//         final vp = image.planes[2].bytes[uvIndex];
//
//         int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
//         int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
//         int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
//
//         img.setPixelRgb(x, y, r, g, b);
//       }
//     }
//
//     return img;
//   }
//
//   List<dynamic> _postProcessResults(List<dynamic> outputs) {
//     // Implement post-processing logic here
//     // This depends on your model's output format and requirements
//     // You'll need to apply non-max suppression, threshold filtering, etc.
//     // For simplicity, let's return a dummy result
//     return [
//       {
//         'label': 'Carrot',
//         'confidence': 0.95,
//         'bbox': [10, 10, 100, 100],
//       },
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_cameraController.value.isInitialized) {
//       return Container();
//     }
//     return Column(
//       children: [
//         CameraPreview(_cameraController),
//         if (_recognitions != null)
//           Expanded(
//             child: ListView.builder(
//               itemCount: _recognitions!.length,
//               itemBuilder: (context, index) {
//                 var recognition = _recognitions![index];
//                 return ListTile(
//                   title: Text(recognition['label']),
//                   subtitle: Text('Confidence: ${recognition['confidence']}'),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _interpreter.close();
//     super.dispose();
//   }
// }