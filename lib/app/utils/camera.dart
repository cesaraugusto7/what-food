import 'dart:io';
import 'package:whatfood/app/components/camera_component.dart';
import 'package:whatfood/app/utils/custon_error.dart';
import 'package:whatfood/app/utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Camera {
  late final FileUtils fileUtils;
  late final CameraComponent cameraComponent;
  late final BuildContext context;
  Camera({required this.cameraComponent, required this.context}) {
    fileUtils = FileUtils();
  }
  Future<File> getImage() async {
    const XFile? pickedFile = null;
    try {
      // cameraComponent.openCamera(context);
      // if (pickedFile == null) {
      //   throw CustonError(message: 'Nenhuma foto foi adicionada.');
      // }

      // final File file = File(pickedFile.path);
      // await fileUtils.gravarFotoCelular(pickedFile);
      return File('/teste');
    } catch (e) {
      if (e is CustonError) {
        rethrow;
      }
      throw CustonError(message: 'Erro ao carregar adicionar  foto:$e');
    }
  }
}
