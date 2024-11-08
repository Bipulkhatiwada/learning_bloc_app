import 'package:image_picker/image_picker.dart';
class ImagePickerUtils {
  // Corrected: Use 'final' to declare the variable
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> cameraCapture() async {
    // The type of 'file' is explicitly XFile?
    final XFile? file = await _picker.pickImage(source: ImageSource.camera);
    return file;
  }

  Future<XFile?> pickImageFromGallery() async {
    // Corrected: Use ImageSource.gallery for picking from gallery
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    return file;
  }
}