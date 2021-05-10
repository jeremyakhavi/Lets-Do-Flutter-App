import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Picture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(child: Image.asset('assets/siri_logo.png'));
  }
}

class ImageRequest extends Picture {}

class OpenImagePicker extends Picture {
  final ImageSource imageSource;

  OpenImagePicker({this.imageSource});
}
