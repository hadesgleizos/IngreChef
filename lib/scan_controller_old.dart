// import 'dart:async';
// import 'package:camera/camera.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';
// import 'package:main/database_service.dart';
//
// class ScanController extends GetxController {
//   late CameraController cameraController;
//   late List<CameraDescription> cameras;
//   var cameraCount = 0;
//   var isCameraInitialized = false.obs;
//
//   var x = 0.0.obs;
//   var y = 0.0.obs;
//   var w = 1.0.obs;
//   var h = 1.0.obs;
//   var label = ''.obs;
//
//   var ingredients = <String>[].obs;
//
//   var isDisposed = false;
//   var isInterpreterBusy = false; // Added this flag
//
//   @override
//   void onInit() {
//     super.onInit();
//     debugLog('Initializing camera...');
//     initCamera();
//     debugLog('Initializing TFLite...');
//     initTflite();
//   }
//
//   @override
//   void onClose() {
//     debugLog('Disposing camera controller...');
//     disposeCameraController();
//     debugLog('Unloading TFLite model...');
//     unloadModel();
//     super.onClose();
//   }
//
//   Future<void> initCamera() async {
//     debugLog('Requesting camera permission...');
//     if (await Permission.camera.request().isGranted) {
//       debugLog('Camera permission granted.');
//       cameras = await availableCameras();
//       debugLog('Available cameras: ${cameras.length}');
//
//       CameraDescription rearCamera = cameras.firstWhere(
//             (camera) => camera.lensDirection == CameraLensDirection.back,
//         orElse: () => cameras.first,
//       );
//
//       cameraController = CameraController(
//         rearCamera,
//         ResolutionPreset.max,
//       );
//
//       try {
//         await cameraController.initialize();
//         debugLog('Camera initialized.');
//       } catch (e) {
//         debugLog('Error initializing camera: $e');
//         return;
//       }
//
//       cameraController.startImageStream((CameraImage image) {
//         if (isDisposed) return;
//         cameraCount++;
//         if (cameraCount % 10 == 0) {
//           cameraCount = 0;
//           runObjectDetection(image);
//         }
//         update();
//       });
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
//       await Tflite.loadModel(
//         model: "assets/best_float32.tflite",
//         labels: "assets/latestLabel.txt",
//       );
//       debugLog('TFLite model loaded.');
//     } catch (e) {
//       debugLog('Error loading TFLite model: $e');
//     }
//   }
//
//   Future<void> runObjectDetection(CameraImage image) async {
//     if (isInterpreterBusy) {
//       debugLog('Interpreter is busy, skipping this frame.');
//       return;
//     }
//
//     isInterpreterBusy = true;
//
//     try {
//       debugLog('Running object detection...');
//       var recognitions = await Tflite.runModelOnFrame(
//         bytesList: image.planes.map((plane) {
//           return plane.bytes;
//         }).toList(),
//         imageHeight: image.height,
//         imageWidth: image.width,
//         numResults: 5,
//         threshold: 0.4,
//         rotation: 90,
//       );
//       debugLog('Recognitions: $recognitions');
//
//       if (recognitions != null && recognitions.isNotEmpty) {
//         var recognition = recognitions.first;
//         debugLog('First recognition: $recognition');
//
//         var confidence = recognition['confidence'] ?? 0.0;
//         debugLog('Recognition confidence: $confidence');
//
//         if (confidence > 0.98) {
//           var rawLabel = recognition['label'] ?? '';
//           var processedLabel = rawLabel.replaceAll(RegExp(r'^\d+\s*'), '');
//           label.value = processedLabel;
//           debugLog('Processed label: $processedLabel');
//
//           if (!ingredients.contains(processedLabel)) {
//             ingredients.add(processedLabel);
//             debugLog('Added label to ingredients: $ingredients');
//           }
//         } else {
//           label.value = '';
//           debugLog('No confident recognition.');
//         }
//       } else {
//         label.value = '';
//         debugLog('No recognitions.');
//       }
//     } catch (e) {
//       debugLog('Error running object detector: $e');
//     } finally {
//       isInterpreterBusy = false;
//     }
//   }
//
//   Future<void> unloadModel() async {
//     try {
//       await Tflite.close();
//       debugLog('TFLite model unloaded.');
//     } catch (e) {
//       debugLog('Error closing TFLite model: $e');
//     }
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
