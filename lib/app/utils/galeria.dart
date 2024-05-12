import 'dart:io';
import 'package:whatfood/app/utils/custon_error.dart';
import 'package:image_picker/image_picker.dart';

class Galeria {
  Future<File> getImage() async {
    final XFile? pickedFile;
    try {
      final ImagePicker picker = ImagePicker();
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) {
        throw CustonError(message: 'Nenhuma foto foi selecionada.');
      }
      final File file = File(pickedFile.path);
      return file;
    } catch (e) {
      if (e is CustonError) {
        rethrow;
      }
      throw CustonError(message: 'Erro ao carregar foto:$e');
    }
  }
}
