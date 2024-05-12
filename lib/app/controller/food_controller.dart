import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:whatfood/app/model/food_model.dart';
import 'package:whatfood/app/repository/food_repository.dart';
import 'package:whatfood/app/repository/gemini_repository.dart';
import 'package:whatfood/app/utils/custon_error.dart';

enum FoodState { loading, success, error }

class FoodController extends ChangeNotifier {
  FoodState state = FoodState.loading;
  String erro = '';
  String loadingMsg = '';
  FoodController();

  late FoodModel foodModel = FoodModel(
      idFood: null,
      prato: '',
      descricao: '',
      urlImagem: '',
      arquivoImagem: null,
      idImage: null,
      ingredientes: [],
      instrucoes: [],
      dicas: [],
      saved: false);
  String error = '';

  getFoodByImage(File image) async {
    try {
      GeminiRepositore geminiRepositore = GeminiRepositore();
      state = FoodState.loading;
      loadingMsg = 'Processando imagem...';
      notifyListeners();
      foodModel = await geminiRepositore.getFoodByImage(image);
      foodModel = foodModel.copyWith(arquivoImagem: image);
      loadingMsg = 'Carregando informações...';
      notifyListeners();
      Future.delayed(const Duration(seconds: 3));
      state = FoodState.success;
      notifyListeners();
    } on CustonError catch (e) {
      error = e.message;
      state = FoodState.error;
      notifyListeners();
    }
  }

  saveFood() async {
    try {
      FoodRepository foodRepository = FoodRepository();
      state = FoodState.loading;
      loadingMsg = 'Salvando imagem da receita...';
      notifyListeners();
      String idImagem =
          await foodRepository.saveImage(foodModel.arquivoImagem!);
      foodModel = foodModel.copyWith(idImage: idImagem);
      loadingMsg = 'Salvando receita...';
      notifyListeners();
      String idFood = await foodRepository.saveFood(foodModel);
      foodModel = foodModel.copyWith(saved: true, idFood: idFood);
      state = FoodState.success;
      notifyListeners();
    } on CustonError catch (e) {
      erro = e.message;
      state = FoodState.error;
      notifyListeners();
    }
  }

  deleteFood() async {
    try {
      FoodRepository foodRepository = FoodRepository();
      state = FoodState.loading;
      loadingMsg = 'Deletando imagem da receita...';
      notifyListeners();
      await foodRepository.deleteImage(foodModel.idImage!);
      foodModel = foodModel.copyWith(idImage: null);
      loadingMsg = 'Deletando receita...';
      notifyListeners();
      await foodRepository.deleteFood(foodModel.idFood!);
      foodModel = foodModel.copyWith(idFood: null, saved: false);
      state = FoodState.success;
      notifyListeners();
    } on CustonError catch (e) {
      erro = e.message;
      state = FoodState.error;
      notifyListeners();
    }
  }
}
