import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main/scan_controller.dart';
import 'package:main/Home/recommendations.dart';

class CameraView extends StatelessWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialized.value
              ? Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: CameraPreview(controller.cameraController),
              ),
              Positioned(
                top: 100.0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    color: Colors.white.withOpacity(0.5),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
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
              Positioned(
                bottom: 16.0,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      print('Scanned Ingredients: ${controller.ingredients}');
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
