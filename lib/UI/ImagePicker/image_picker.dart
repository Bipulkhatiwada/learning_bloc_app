import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc_app/bloc/ImagePicker/bloc/image_picker_bloc.dart';
import 'package:learning_bloc_app/bloc/ImagePicker/bloc/image_picker_state.dart';
import 'package:learning_bloc_app/bloc/ImagePicker/bloc/image_picker_event.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key, required this.title});
  final String title;

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  void _pickImageFromGallery() {
    context.read<ImagePickerBloc>().add(GalleryImage());
  }

  void _clickImage() {
    context.read<ImagePickerBloc>().add(CameraCapture());
  }

  void _clearImage() {
    context.read<ImagePickerBloc>().add(ClearImage());
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.teal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 8,
      shadowColor: Colors.tealAccent,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }

  // @override
  // void dispose() {
  //   _clearImage();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shadowColor: Colors.tealAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
                  builder: (context, state) {
                    return ClipRRect(
                      
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          state.file != null
                              ? SizedBox(
                                  // Use Container to control the size and behavior
                                  height: 400,
                                  width: 400,
                                  child: Image.file(
                                    File(state.file!.path),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 350,
                                    color: Colors.teal.withOpacity(0.5),
                                  ),
                                ),
                          // Cross icon at the top right
                          if (state.file !=
                              null) // Only show the icon if there is a file
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors. cyan, 
                                ),
                                onPressed:
                                    _clearImage,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImageFromGallery,
                      style: _buttonStyle(),
                      icon: const Icon(Icons.image, color: Colors.white),
                      label: const Text(
                        "Gallery",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _clickImage,
                      style: _buttonStyle(),
                      icon: const Icon(Icons.camera, color: Colors.white),
                      label: const Text(
                        "Camera",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
