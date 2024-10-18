import 'package:bloc/bloc.dart';
import 'package:learning_bloc_app/bloc/ImagePicker/bloc/image_picker_event.dart';
import 'package:learning_bloc_app/bloc/ImagePicker/bloc/image_picker_state.dart';
import '../../../Utils/image_picker_utils.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImagePickerUtils imagePickerUtils;

  ImagePickerBloc(this.imagePickerUtils) : super(const ImagePickerState()) {
    on<GalleryImage>(_imagePickedFromGallery);
    on<CameraCapture>(_imageClickedFromCamera);
    on<ClearImage>(_clearImage);
  }

  Future<void> _imagePickedFromGallery(
      GalleryImage event, Emitter<ImagePickerState> emit) async {
    XFile? file = await imagePickerUtils.pickImageFromGallery();
    if (file != null) {
      emit(state.copyWith(file: file, clearImage: false)); 
    }
  }

  Future<void> _imageClickedFromCamera(
      CameraCapture event, Emitter<ImagePickerState> emit) async {
    XFile? file = await imagePickerUtils.cameraCapture();
    if (file != null) {
      emit(state.copyWith(file: file,clearImage: false)); 
    }
  }

 Future<void> _clearImage(ClearImage event, Emitter<ImagePickerState> emit) async {
  emit(state.copyWith(clearImage: true)); // This will set clearImage to true
}

}
