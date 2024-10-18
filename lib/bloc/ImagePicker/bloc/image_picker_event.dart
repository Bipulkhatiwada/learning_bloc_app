import 'package:equatable/equatable.dart';

class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object> get props => [];
}

class GalleryImage extends ImagePickerEvent {}

class CameraCapture extends ImagePickerEvent {}

class ClearImage extends ImagePickerEvent {}
