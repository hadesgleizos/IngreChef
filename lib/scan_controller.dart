import 'dart:async';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';

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
    if (await Permission.camera
        .request()
        .isGranted) {
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
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
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
        var rect = recognition['rect'] ?? {};

        x.value = rect['x'] ?? 0.0;
        y.value = rect['y'] ?? 0.0;
        w.value = rect['w'] ?? 1.0;
        h.value = rect['h'] ?? 1.0;

        var rawLabel = recognition['label'] ?? '';
        var processedLabel = rawLabel.replaceAll(RegExp(r'^\d+\s*'), '');

        label.value = processedLabel;

        if (!ingredients.contains(processedLabel)) {
          ingredients.add(processedLabel);
        }
      } else {
        x.value = 0.0;
        y.value = 0.0;
        w.value = 1.0;
        h.value = 1.0;
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
}