import 'package:flutter/material.dart';

class CameraButtonApp extends StatelessWidget {
  const CameraButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyScan(title: 'Camera Button App'),
    );
  }
}

class MyScan extends StatefulWidget {
  const MyScan({super.key, required this.title});

  final String title;

  @override
  State<MyScan> createState() => _MyScanState();
}

class _MyScanState extends State<MyScan> {
  void _onCameraButtonPressed() {
    print('Camera button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _onCameraButtonPressed,
          child: const Icon(
            Icons.camera_alt,
            size: 50,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: Colors.black
          ),
        ),
      ),
    );
  }
}
