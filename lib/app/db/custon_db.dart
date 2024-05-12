import 'dart:convert';
import 'dart:io';
import 'package:whatfood/app/db/doc.dart';
import 'package:whatfood/app/utils/file_utils.dart';
import 'package:path/path.dart';

class CustonDB {
  String id = '';
  List<Map> wheres = [];
  late final String col;
  late final FileUtils fileUtils;

  CustonDB() {
    fileUtils = FileUtils();
  }

  CustonDB collection(String collection) {
    col = collection;
    return this;
  }

  CustonDB doc(String id) {
    this.id = id;
    return this;
  }

  CustonDB where({key, op, value}) {
    wheres.add({'key': key, 'op': op, 'value': value});
    return this;
  }

  Future<String> add(Map data) async {
    id = DateTime.now().millisecondsSinceEpoch.toString();
    File file = await fileUtils.localFile(col, id);
    if (!fileUtils.fileExist(file.path)) {
      File fileDiretorio = await fileUtils.localFile(col, '');
      fileUtils.criaDiretorio(fileDiretorio.path);
    }
    fileUtils.writeFile(file, jsonEncode(data));
    return id;
  }

  Future<void> set(Map data, {required bool merge}) async {
    File file = await fileUtils.localFile(col, id);
    if (!fileUtils.fileExist(file.path)) {
      File fileDiretorio = await fileUtils.localFile(col, '');
      fileUtils.criaDiretorio(fileDiretorio.path);
    }
    if (merge) {
      data = await mergeJsonTxt(data);
    }
    fileUtils.writeFile(file, jsonEncode(data));
  }

  Future<dynamic> get() async {
    if (id != '') {
      String data =
          await fileUtils.readFile(await fileUtils.localFile(col, id));
      return Doc(id, data);
    }
    final files = await fileUtils.readAllFiles(col);
    List<Doc> docs = [];
    files.where((element) => element.existsSync()).forEach((element) {
      if (wheres.isNotEmpty) {
        int valid = 0;
        var doc =
            Doc(basename((element as File).path), element.readAsStringSync());
        for (var cond in wheres) {
          var objDoc = doc.data();
          if (objDoc[cond['key']] == cond['value']) valid++;
        }
        if (valid > 0) {
          docs.add(doc);
        }
      } else {
        docs.add(
            Doc(basename((element as File).path), element.readAsStringSync()));
      }
    });
    return docs;
  }

  Future<Map> mergeJsonTxt(Map data) async {
    Map contentBefore = (await get()).data();
    Map contentAfter = data;
    Map obj = mergeObj(contentAfter, contentBefore);
    return obj;
  }

  Future<void> delete() async {
    await fileUtils.deleteFile(col, id);
  }

  Map mergeObj(Map objA, Map objB) {
    Map obj = objA;
    objB.forEach((key, value) {
      if ((obj[key] is Map) && (objB[key] is Map)) {
        obj[key] = mergeObj(obj[key], objB[key]);
      } else {
        obj[key] = value;
      }
    });
    return obj;
  }
}
