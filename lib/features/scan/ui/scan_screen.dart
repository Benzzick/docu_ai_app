import 'package:camera/camera.dart';
import 'package:docu_ai_app/features/scan/providers/camera_contoller_provider.dart';
import 'package:docu_ai_app/features/scan/providers/camera_type_provider.dart';
import 'package:docu_ai_app/core/global_providers/scanned_image_service_provider.dart';
import 'package:docu_ai_app/features/scan/widgets/a4_scanner_overlay.dart';
import 'package:docu_ai_app/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen>
    with WidgetsBindingObserver {
  bool pictureAction = false;

  Future<void> takePicture(CameraController controller) async {
    setState(() {
      pictureAction = true;
    });
    final scanner = ref.read(scannedImageServiceProvider);
    final pickedImage = await scanner.takePicture(controller);
    context.push('/preview-image', extra: pickedImage);
    setState(() {
      pictureAction = false;
    });
  }

  Future<void> uploadPicture() async {
    setState(() {
      pictureAction = true;
    });
    final scanner = ref.read(scannedImageServiceProvider);
    final pickedImage = await scanner.uploadPicture();
    if (pickedImage != null) {
      context.push('/preview-image', extra: pickedImage);
    }
    setState(() {
      pictureAction = false;
    });
  }

  Future<void> switchCamera() async {
    setState(() {
      pictureAction = true;
    });
    final cameraType = ref.read(cameraTypeProvider);

    final cameraTypeToUse =
        cameraType == CameraType.front ? CameraType.back : CameraType.front;
    ref.read(cameraTypeProvider.notifier).state = cameraTypeToUse;
    await ref.read(cameraControllerProvider.notifier).initializeCamera(
          cameraType: cameraTypeToUse,
        );
    setState(() {
      pictureAction = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final controller = ref.read(cameraControllerProvider);
    if (controller == null || controller.value.isInitialized == false) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      ref.read(cameraControllerProvider.notifier).stopCamera();
    } else if (state == AppLifecycleState.resumed) {
      final currentCameraType = ref.read(cameraTypeProvider);
      ref.read(cameraControllerProvider.notifier).initializeCamera(
            cameraType: currentCameraType,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(cameraControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: Center(
        child: AnimatedSwitcher(
            duration: Durations.medium1,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: controller == null || !controller.value.isInitialized
                ? CircularProgressIndicator(
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                  )
                : Stack(
                    children: [
                      SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: CameraPreview(
                          controller,
                        ),
                      ),
                      CustomPaint(
                        size: Size.infinite,
                        painter: A4ScannerOverlay(
                          overlayColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(153),
                          borderColor: Theme.of(context).colorScheme.primary,
                          borderWidth: 3.0,
                          borderRadius: 12.0,
                          padding: 30.0,
                          bottomControlsHeight: 0.0,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                padding: EdgeInsets.all(15),
                                onPressed: pictureAction ? null : uploadPicture,
                                icon: Icon(Icons.file_upload_outlined),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.all(20),
                                onPressed: pictureAction
                                    ? null
                                    : () {
                                        takePicture(controller);
                                      },
                                icon: Icon(
                                  Icons.circle,
                                  size: 50,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.all(15),
                                onPressed: pictureAction ? null : switchCamera,
                                icon: Icon(Icons.cameraswitch_rounded),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }
}
