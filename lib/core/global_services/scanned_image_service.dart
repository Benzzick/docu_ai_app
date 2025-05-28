import 'dart:io';
import 'package:camera/camera.dart';
import 'package:docu_ai_app/core/app_styles/app_palette.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ScannedImageService {
  Future<File> takePicture(CameraController controller) async {
    final image = await controller.takePicture();
    final imageFile = File(image.path);

    return imageFile;
  }

  Future<File?> uploadPicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return null;

    final imageFile = File(pickedImage.path);
    return imageFile;
  }

  Future<File?> cropPicture(File imageFile) async {
    final imageCropper = ImageCropper();

    final croppedFile =
        await imageCropper.cropImage(sourcePath: imageFile.path, uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Document',
        toolbarColor: AppPalette.primaryColor,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        showCropGrid: true,
        hideBottomControls: false,
      ),
    ]);

    if (croppedFile == null) return null;

    return File(croppedFile.path);
  }
}
