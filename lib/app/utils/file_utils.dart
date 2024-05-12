import 'dart:convert';
import 'dart:io';
import 'package:whatfood/app/utils/custon_error.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  String retornaBase64(File file) {
    Uint8List bytes = file.readAsBytesSync();
    String base64Image = base64.encode(bytes);
    return base64Image;
  }

  void criaDiretorio(path) {
    Directory(path).createSync();
  }

  File retornaFile(base64, nomeFile) {
    final decodedBytes = base64Decode(base64);
    var file = File(nomeFile);
    file.writeAsBytesSync(decodedBytes);
    return file;
  }

  // Future<bool> gravarFotoCelular(XFile file) async {
  //   try {
  //     await GallerySaver.saveImage(file.path, albumName: 'whatfood');
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> localFile(String pathAdd, String fileName) async {
    final path = await _localPath;
    if (fileName == '') {
      return File('$path/$pathAdd');
    }
    if (pathAdd == '') {
      return File('$path/$fileName');
    }
    return File('$path/$pathAdd/$fileName');
  }

  Future<File> writeFile(File file, String content) async {
    return file.writeAsString(content);
  }

  Future<File> writeFileAsByte(File file, List<int> bytes) async {
    return file.writeAsBytes(bytes);
  }

  Future<String> readFile(file) async {
    try {
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<void> deleteFile(path, fileName) async {
    File file = await localFile(path, fileName);
    file.delete();
  }

  Future<List<FileSystemEntity>> readAllFiles(pathAdd) async {
    final f = await localFile(pathAdd, '');
    final Directory dir = Directory(f.path);
    List<FileSystemEntity> files = dir.listSync().toList();
    return files;
  }

  bool fileExist(path) {
    return FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound;
  }

  Future<File> carregarArquivo() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null) {
        String? pathFile = result.files.single.path ?? '';
        File file = File(pathFile);
        return file;
      } else {
        throw CustonError(message: 'Erro ao carregar arquivo.');
      }
    } catch (e) {
      if (e is CustonError) {
        rethrow;
      }
      throw CustonError(message: 'Erro ao carregar o arquivo: $e');
    }
  }
}
