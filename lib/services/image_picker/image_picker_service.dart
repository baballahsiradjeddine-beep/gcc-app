import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class ImagePickerService {
  ImagePickerService._();
  static final ImagePickerService instance = ImagePickerService._();

  static Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: AppColors.primaryColorLight,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            aspectRatioPresets: [
              // CropAspectRatioPreset.original,

              CropAspectRatioPreset.square,
              // CropAspectRatioPresetCustom(),
            ],
          ),
          // IOSUiSettings(
          //   title: 'Cropper',
          //   aspectRatioLockEnabled: true,

          //   aspectRatioPresets: [
          //     CropAspectRatioPreset.square,
          //   ],
          // ),
        ],
      );
      return File(croppedFile!.path);
    } else {
      return null;
    }
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
