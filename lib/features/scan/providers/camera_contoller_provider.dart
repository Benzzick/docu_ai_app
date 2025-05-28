import 'package:camera/camera.dart';
import 'package:docu_ai_app/models/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraControllerProvider =
    StateNotifierProvider<CameraControllerNotifier, CameraController?>(
        (ref) => CameraControllerNotifier());

class CameraControllerNotifier extends StateNotifier<CameraController?> {
  CameraControllerNotifier() : super(null) {
    initializeCamera();
  }

  Future<void> initializeCamera(
      {CameraType cameraType = CameraType.back}) async {
    final oldController = state;

    state = null;

    if (oldController != null) {
      await oldController.dispose();
    }

    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      final selectedCamera =
          cameraType == CameraType.back ? cameras.first : cameras.last;

      final newController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
      );

      await newController.initialize();
      state = newController;
    }
  }

  void stopCamera() async {
    await state?.dispose();
    state = null;
  }

  @override
  void dispose() {
    state?.dispose();
    super.dispose();
  }
}
