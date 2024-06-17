import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';

class ScanController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var cameraCount = 0;
  var isCameraInitialized = false.obs;

  // Observable variables
  var x = 0.0.obs;
  var y = 0.0.obs;
  var w = 1.0.obs;
  var h = 1.0.obs;
  var label = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTflite();
  }

  @override
  void dispose() {
    unloadModel();
    if (cameraController.value.isInitialized) {
      cameraController.stopImageStream();
      cameraController.dispose();
    }
    super.dispose();
  }

  Future<void> initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      CameraDescription rearCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      cameraController = CameraController(
        rearCamera,
        ResolutionPreset.max,
      );
      await cameraController.initialize();
      cameraController.startImageStream((image) {
        cameraCount++;
        if (cameraCount % 10 == 0) {
          cameraCount = 0;
          objectDetector(image);
        }
        update();
      });
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
      var detector = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 5,
        threshold: 0.4,
      );

      if (detector != null && detector.isNotEmpty) {
        var firstResult = detector[0];
        var rect = firstResult['rect'] ?? {};

        x.value = rect['x'] ?? 0.0;
        y.value = rect['y'] ?? 0.0;
        w.value = rect['w'] ?? 1.0;
        h.value = rect['h'] ?? 1.0;
        label.value = firstResult['label'] ?? '';
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
}
