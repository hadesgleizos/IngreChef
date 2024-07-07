import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main/scan_controller_old.dart';
import 'package:main/Home/Recommendations.dart';

class CameraView extends StatelessWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan'),
      ),
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialized.value
              ? Stack(
            children: [
              CameraPreview(controller.cameraController),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      color: Colors.white.withOpacity(0.5), // Semi-transparent background
                      child: Obx(
                            () => Text(
                          controller.label.value,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print('Scanned Ingredients: ${controller.ingredients}');
                      // Log the scanned data
                      await controller.logScan();
                      // Navigate to RecommendationPage with scanned ingredients
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecommendationPage(
                            scannedIngredients: controller.ingredients,
                          ),
                        ),
                      );

                      // Dispose of the camera controller safely
                      controller.disposeCameraController();
                    },
                    child: const Text("Done"),
                  ),
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