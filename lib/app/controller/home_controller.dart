import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whatfood/app/components/camera_component.dart';
import 'package:whatfood/app/model/food_model.dart';
import 'package:whatfood/app/repository/food_repository.dart';
import 'package:whatfood/app/utils/custon_error.dart';

enum HomeState { initial, loading, success, error }

class HomeController extends ChangeNotifier {
  List<FoodModel> listFood = [];
  File? imagemCapturada;
  HomeState state = HomeState.initial;
  String erro = '';

  getListFoodSaved() async {
    try {
      state = HomeState.loading;
      notifyListeners();
      //busca  lista de pratos salvos
      FoodRepository foodRepository = FoodRepository();
      listFood = await foodRepository.listFood();
      state = HomeState.success;
      notifyListeners();
    } on CustonError catch (e) {
      state = HomeState.error;
      erro = e.message;
      notifyListeners();
    }
  }

  capturaImagem(CameraComponent cameraComponent) async {
    try {
      imagemCapturada = await cameraComponent.getImage();
      notifyListeners();
    } on CustonError catch (e) {
      state = HomeState.error;
      erro = e.message;
      notifyListeners();
    }
  }
}
