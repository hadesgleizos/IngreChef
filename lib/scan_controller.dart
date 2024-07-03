import 'dart:async';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database_service.dart';

class ScanController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var cameraCount = 0;
  var isCameraInitialized = false.obs;

  var x = 0.0.obs;
  var y = 0.0.obs;
  var w = 1.0.obs;
  var h = 1.0.obs;
  var label = ''.obs;

  var ingredients = <String>[].obs;

  var isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTflite();
  }

  @override
  void onClose() {
    disposeCameraController();
    unloadModel();
    super.onClose();
  }

  Future<void> initCamera() async {
    if (await Permission.camera.request().isGranted) {
      // Get the list of all cameras
      cameras = await availableCameras();

      // Find the rear camera (assuming there is at least one camera)
      CameraDescription rearCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      // Initialize the CameraController with the rear camera
      cameraController = CameraController(
        rearCamera,
        ResolutionPreset.max,
      );

      // Initialize the camera controller
      await cameraController.initialize();

      // Start streaming images from the camera
      cameraController.startImageStream((CameraImage image) {
        if (isDisposed) return;
        cameraCount++;
        if (cameraCount % 10 == 0) {
          cameraCount = 0;
          objectDetector(image);
        }
        update();
      });

      // Mark camera as initialized
      isCameraInitialized(true);
      update();
    } else {
      print("Permission denied");
    }
  }

  Future<void> initTflite() async {
    try {
      await Tflite.loadModel(
        model: "assets/model1.tflite",
        labels: "assets/labels(1).txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false,
      );
    } catch (e) {
      print("Error loading TFLite model: $e");
    }
  }

  Future<void> objectDetector(CameraImage image) async {
    try {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        numResults: 5,
        threshold: 0.4,
        rotation: 90,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        var recognition = recognitions.first;

        // Check confidence level
        var confidence = recognition['confidence'] ?? 0.0;
        if (confidence > 0.98) {
          var rawLabel = recognition['label'] ?? '';
          var processedLabel = rawLabel.replaceAll(RegExp(r'^\d+\s*'), '');

          label.value = processedLabel;

          if (!ingredients.contains(processedLabel)) {
            ingredients.add(processedLabel);
          }
        } else {
          // Confidence not met, reset values
          label.value = '';
        }
      } else {
        label.value = '';
      }
    } catch (e) {
      print("Error running object detector: $e");
    }
  }

  Future<void> unloadModel() async {
    try {
      await Tflite.close();
    } catch (e) {
      print("Error closing TFLite model: $e");
    }
  }

  void disposeCameraController() {
    isDisposed = true;
    if (cameraController.value.isInitialized) {
      // Delay for 2 seconds before stopping and disposing
      Timer(Duration(seconds: 2), () {
        cameraController.stopImageStream();
        cameraController.dispose();
      });
    }
  }

  Future<void> logScan() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection('Students')
            .doc(user.uid)
            .get();

        if (studentDoc.exists) {
          Map<String, dynamic> studentData = studentDoc.data() as Map<String, dynamic>;
          String firstName = studentData['firstName'];
          String lastName = studentData['lastName'];
          String studentId = studentData['studentId'];

          await DatabaseService().logScanData(firstName, lastName, studentId, ingredients);
          print('Scan logged successfully.');
        } else {
          print('Student data not found for UID: ${user.uid}');
        }
      } else {
        print('No user is logged in.');
      }
    } catch (e) {
      print('Error logging scan data: $e');
    }
  }
}