// import 'dart:async';
// import 'dart:ui';
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
// import 'package:main/database_service.dart';
//
// class ScanController extends GetxController {
//
//   late CameraController cameraController;
//   late List<CameraDescription> cameras;
//   var cameraCount = 0;
//   var isCameraInitialized = false.obs;
//
//   var label = ''.obs;
//   var ingredients = <String>[].obs;
//   var isDisposed = false;
//
//   late ObjectDetector _objectDetector;
//
//   @override
//   void onInit() {
//     super.onInit();
//     initCamera();
//     initObjectDetector();
//   }
//
//   @override
//   void onClose() {
//     disposeCameraController();
//     _objectDetector.close();
//     super.onClose();
//   }
//
//   Future<void> initCamera() async {
//     if (await Permission.camera.request().isGranted) {
//       cameras = await availableCameras();
//
//       CameraDescription rearCamera = cameras.firstWhere(
//             (camera) => camera.lensDirection == CameraLensDirection.back,
//         orElse: () => cameras.first,
//       );
//
//       cameraController = CameraController(
//         rearCamera,
//         ResolutionPreset.medium,
//       );
//
//       await cameraController.initialize();
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
//       print("Permission denied");
//     }
//   }
//
//   Future<void> initObjectDetector() async {
//     print("Initializing object detector");
//     const modelPath = 'assets/best_float32.tflite';
//     final options = LocalObjectDetectorOptions(
//       mode: DetectionMode.single,
//       classifyObjects: true,
//       multipleObjects: false,
//       modelPath: modelPath,
//     );
//     _objectDetector = ObjectDetector(options: options);
//   }
//
//   Future<void> runObjectDetection(CameraImage image) async {
//     final WriteBuffer allBytes = WriteBuffer();
//     for (Plane plane in image.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();
//
//     final imageSize = Size(image.width.toDouble(), image.height.toDouble());
//     const imageRotation = InputImageRotation.rotation90deg;
//     final inputImageFormat = InputImageFormat.nv21;
//
//     final inputImageData = InputImageMetadata(
//       size: imageSize,
//       rotation: imageRotation,
//       format: inputImageFormat,
//       bytesPerRow: image.planes[0].bytesPerRow,
//     );
//
//     final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
//
//     try {
//       final List<DetectedObject> objects = await _objectDetector.processImage(inputImage);
//
//       if (objects.isNotEmpty) {
//         final DetectedObject detectedObject = objects.first;
//         if (detectedObject.labels.isNotEmpty) {
//           final label = detectedObject.labels.first;
//           if (label.confidence > 0.7) {  // Adjust this threshold as needed
//             this.label.value = label.text;
//             if (!ingredients.contains(this.label.value)) {
//               ingredients.add(this.label.value);
//             }
//             print("Detected object: ${this.label.value}");  // Add this line for debugging
//           } else {
//             this.label.value = '';
//           }
//         }
//       } else {
//         label.value = '';
//       }
//     } catch (e) {
//       print("Error running object detector: $e");
//     }
//   }
//
//   void disposeCameraController() {
//     isDisposed = true;
//     if (cameraController.value.isInitialized) {
//       Timer(Duration(seconds: 2), () {
//         cameraController.stopImageStream();
//         cameraController.dispose();
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
//           print('Scan logged successfully.');
//         } else {
//           print('Student data not found for UID: ${user.uid}');
//         }
//       } else {
//         print('No user is logged in.');
//       }
//     } catch (e) {
//       print('Error logging scan data: $e');
//     }
//   }
// }
