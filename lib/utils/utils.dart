import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// for displaying snackbars
void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blueGrey[800],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );
}

showLoadingDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();
  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
  }
  return images;
}

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final imageFile = await picker.pickImage(source: ImageSource.gallery);
  if (imageFile != null) {
    return File(imageFile.path);
  }
  return null;
}