import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerState extends Equatable {
  final XFile? file;
  final bool clearImage;

  const ImagePickerState({
    this.file,
    this.clearImage = false, // Default value for clearImage
  });

  ImagePickerState copyWith({
    XFile? file,
    bool? clearImage,
  }) {
    return ImagePickerState(
      file: clearImage == true ? null : file ?? this.file, // Reset file if clearImage is true
      clearImage: clearImage ?? this.clearImage,
    );
  }

  @override
  List<Object?> get props => [file, clearImage]; // Include clearImage in props for equality checks
}
