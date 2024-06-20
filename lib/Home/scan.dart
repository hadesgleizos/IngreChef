import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main/scan_controller.dart';
import 'package:main/Home/recommendations.dart'; // Import the new screen here

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialized.value
              ? Stack(
            children: [
              CameraPreview(controller.cameraController),
              Obx(() => Positioned(
                top: controller.y.value * MediaQuery.of(context).size.height,
                left: controller.x.value * MediaQuery.of(context).size.width,
                child: Container(
                  width: controller.w.value * MediaQuery.of(context).size.width,
                  height: controller.h.value * MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 4.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.white,
                        child: Text(controller.label.value),
                      ),
                    ],
                  ),
                ),
              )),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: ElevatedButton(
                  onPressed: () {
                    controller.cameraController.dispose();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecommendationPage(),
                      ),
                    );
                  },
                  child: const Text("Done"),
                ),
              ),
            ],
          )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
