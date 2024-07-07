// import 'dart:async';
// import 'dart:math';
// import 'package:camera/camera.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// import 'package:image/image.dart' as imgLib;
// import 'package:main/database_service.dart';
//
// class ScanController extends GetxController {
//   late CameraController cameraController;
//   late List<CameraDescription> cameras;
//   var cameraCount = 0;
//   var isCameraInitialized = false.obs;
//
//   String getLabel(int classId) {
//     if (classId >= 0 && classId < labels.length) {
//       return labels[classId];
//     }
//     return 'unknown';
//   }
//
//
//   var x = 0.0.obs;
//   var y = 0.0.obs;
//   var w = 1.0.obs;
//   var h = 1.0.obs;
//   var label = ''.obs;
//
//   var ingredients = <String>[].obs;
//
//   List<String> labels = [];
//
//   var isDisposed = false;
//   var isInterpreterBusy = false;
//
//   late Interpreter interpreter;
//
//   @override
//   void onInit() {
//     super.onInit();
//     debugLog('Initializing camera...');
//     initCamera();
//     debugLog('Initializing TFLite...');
//     initTflite();
//     debugLog('Loading labels...');
//     loadLabels();
//   }
//
//   @override
//   void onClose() {
//     debugLog('Disposing resources...');
//     if (cameraController.value.isStreamingImages) {
//       cameraController.stopImageStream();
//     }
//     disposeCameraController();
//     interpreter.close();
//       super.onClose();
//   }
//
//   void _processCameraImage(CameraImage image) {
//     if (!isInterpreterBusy) {
//       runObjectDetection(image);
//     }
//   }
//
//   Future<void> initCamera() async {
//     debugLog('Requesting camera permission...');
//     if (await Permission.camera.request().isGranted) {
//       debugLog('Camera permission granted.');
//       cameras = await availableCameras();
//       debugLog('Available cameras: ${cameras.length}');
//
//       if (cameras.isEmpty) {
//         debugLog('No cameras available');
//         return;
//       }
//
//       CameraDescription rearCamera = cameras.firstWhere(
//             (camera) => camera.lensDirection == CameraLensDirection.back,
//         orElse: () => cameras.first,
//       );
//
//       cameraController = CameraController(
//         rearCamera,
//         ResolutionPreset.medium,
//         enableAudio: false,
//       );
//
//       try {
//         await cameraController.initialize();
//         debugLog('Camera initialized.');
//
//         if (!cameraController.value.isInitialized) {
//           debugLog('Error: Camera not initialized');
//           return;
//         }
//
//         // Start image stream once the camera is initialized
//         await cameraController.startImageStream(_processCameraImage);
//         debugLog('Camera stream started.');
//       } catch (e) {
//         debugLog('Error initializing camera: $e');
//         return;
//       }
//
//       isCameraInitialized(true);
//       update();
//     } else {
//       debugLog('Camera permission denied.');
//     }
//   }
//
//   Future<void> initTflite() async {
//     try {
//       interpreter = await Interpreter.fromAsset('best_float32.tflite');
//       debugLog('TFLite model loaded.');
//
//       // Print input and output shapes
//       var inputShape = interpreter.getInputTensor(0).shape;
//       var outputShape = interpreter.getOutputTensor(0).shape;
//       debugLog('Input shape: $inputShape');
//       debugLog('Output shape: $outputShape');
//     } catch (e) {
//       debugLog('Error loading TFLite model: $e');
//     }
//   }
//
//   Future<void> loadLabels() async {
//     try {
//       String labelsData = await rootBundle.loadString('assets/labels.txt');
//       labels = labelsData.split('\n')
//           .map((label) => label.trim())
//           .where((label) => label.isNotEmpty)
//           .toList();
//       debugLog('Labels loaded successfully: ${labels.length} labels');
//       debugLog('Labels: $labels');
//     } catch (e) {
//       debugLog('Error loading labels: $e');
//     }
//   }
//
//   Future<void> runObjectDetection(CameraImage image) async {
//     if (isInterpreterBusy || interpreter == null) return;
//
//     isInterpreterBusy = true;
//
//     try {
//       TensorImage tensorImage = TensorImage.fromImage(
//           _convertCameraImage(image)
//       );
//       ImageProcessor imageProcessor = ImageProcessorBuilder()
//           .add(ResizeOp(640, 640, ResizeMethod.BILINEAR))
//           .add(NormalizeOp(0, 255))
//           .build();
//       tensorImage = imageProcessor.process(tensorImage);
//
//       TensorBuffer outputBuffer = TensorBuffer.createFixedSize(
//         interpreter.getOutputTensor(0).shape,
//         interpreter.getOutputTensor(0).type,
//       );
//
//       interpreter.run(tensorImage.buffer, outputBuffer.buffer);
//
//       List<double> results = outputBuffer.getDoubleList();
//       processResults(results);
//
//     } catch (e) {
//       debugLog('Error running object detection: $e');
//     } finally {
//       isInterpreterBusy = false;
//     }
//   }
//
//   void processResults(List<double> results) {
//     if (results.length != 21) {
//       debugLog('Unexpected number of results: ${results.length}. Expected 21.');
//       return;
//     }
//
//     int classId = results.indexOf(results.reduce((a, b) => a > b ? a : b));
//     double confidence = results[classId];
//
//     if (confidence > 0.5) { // Lowered threshold for demonstration
//       String rawLabel = getLabel(classId);
//       var processedLabel = rawLabel.split(' ').last;
//
//       // Update UI
//       label.value = processedLabel;
//
//       if (!ingredients.contains(processedLabel)) {
//         ingredients.add(processedLabel);
//         debugLog('Detected new ingredient: $processedLabel');
//       }
//     } else {
//       label.value = '';
//     }
//
//     // Trigger UI update
//     update();
//   }
//
//   imgLib.Image _convertCameraImage(CameraImage image) {
//     final int width = image.width;
//     final int height = image.height;
//     final int uvRowStride = image.planes[1].bytesPerRow;
//     final int uvPixelStride = image.planes[1].bytesPerPixel!;
//
//     // Create image buffer
//     var imgImage = imgLib.Image(width, height);
//
//     // Fill the image buffer
//     for (int y = 0; y < height; y++) {
//       for (int x = 0; x < width; x++) {
//         final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
//         final int index = y * width + x;
//
//         final int yp = image.planes[0].bytes[index];
//         final int up = image.planes[1].bytes[uvIndex];
//         final int vp = image.planes[2].bytes[uvIndex];
//
//         // Convert yuv to rgb
//         int r = (yp + vp * 1.370705).round().clamp(0, 255);
//         int g = (yp - up * 0.337633 - vp * 0.698001).round().clamp(0, 255);
//         int b = (yp + up * 1.732446).round().clamp(0, 255);
//
//         imgImage.setPixel(x, y, imgLib.getColor(r, g, b));
//       }
//     }
//     return imgImage;
//   }
//
//   void disposeCameraController() {
//     isDisposed = true;
//     if (cameraController.value.isInitialized) {
//       Timer(Duration(seconds: 2), () {
//         cameraController.stopImageStream();
//         cameraController.dispose();
//         debugLog('Camera controller disposed.');
//       });
//     }
//   }
//
//   Future<void> logScan() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot studentDoc = await FirebaseFirestore.instance
//             .collection('Students')
//             .doc(user.uid)
//             .get();
//
//         if (studentDoc.exists) {
//           Map<String, dynamic> studentData = studentDoc.data() as Map<String, dynamic>;
//           String firstName = studentData['firstName'];
//           String lastName = studentData['lastName'];
//           String studentId = studentData['studentId'];
//
//           await DatabaseService().logScanData(firstName, lastName, studentId, ingredients);
//           debugLog('Scan logged successfully.');
//         } else {
//           debugLog('Student data not found for UID: ${user.uid}');
//         }
//       } else {
//         debugLog('No user is logged in.');
//       }
//     } catch (e) {
//       debugLog('Error logging scan data: $e');
//     }
//   }
//
//   void debugLog(String message) {
//     print('[DEBUG] $message');
//   }
// }
