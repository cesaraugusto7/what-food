import 'dart:convert';
import 'dart:io';

import 'package:whatfood/app/db/custon_db.dart';
import 'package:whatfood/app/db/doc.dart';
import 'package:whatfood/app/model/food_model.dart';
import 'package:whatfood/app/utils/custon_error.dart';
import 'package:whatfood/app/utils/file_utils.dart';

class FoodRepository {
  Future<String> saveFood(FoodModel foodModel) async {
    try {
      CustonDB custonDB = CustonDB();
      String idFood = await custonDB.collection('food').add(foodModel.toMap());
      return idFood;
    } catch (e) {
      throw CustonError(message: 'Erro ao salvar receita.$e');
    }
  }

  Future<List<FoodModel>> listFood() async {
    try {
      CustonDB custonDB = CustonDB();
      var result = await custonDB.collection('food').get();
      List<FoodModel> list = [];
      for (Doc item in (result as List)) {
        var food = FoodModel.fromMap(item.data());
        food.copyWith(arquivoImagem: await getImage(food.idImage!));
        list.add(food);
      }
      return list;
    } catch (e) {
      throw CustonError(message: 'Erro ao deletar receita.$e');
    }
  }

  Future<File> getImage(String idImage) async {
    try {
      CustonDB custonDB = CustonDB();
      FileUtils fileUtils = FileUtils();
      var result = await custonDB.collection('image').doc(idImage).get();
      var image = fileUtils.retornaFile(result, idImage);
      return image;
    } catch (e) {
      throw CustonError(message: 'Erro ao buscar imagem.$e');
    }
  }

  deleteFood(String idFood) async {
    try {
      CustonDB custonDB = CustonDB();
      await custonDB.collection('food').doc(idFood).delete();
    } catch (e) {
      throw CustonError(message: 'Erro ao deletar receita.$e');
    }
  }

  deleteImage(String idImage) async {
    try {
      CustonDB custonDB = CustonDB();
      await custonDB.collection('image').doc(idImage).delete();
    } catch (e) {
      throw CustonError(message: 'Erro ao deletar receita.$e');
    }
  }

  Future<String> saveImage(File file) async {
    try {
      CustonDB custonDB = CustonDB();
      String base64 = base64Encode(file.readAsBytesSync());
      String id = await custonDB.collection('image').add({'image': base64});
      return id;
    } catch (e) {
      throw CustonError(message: 'Erro ao salvar imagem da receita.$e');
    }
  }
}
