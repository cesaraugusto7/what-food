import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatfood/app/controller/food_controller.dart';

class FoodView extends StatefulWidget {
  const FoodView({super.key});

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  late FoodController foodController;

  @override
  void initState() {
    super.initState();
    foodController = FoodController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var arguments = (ModalRoute.of(context)?.settings.arguments ??
          <String, dynamic>{}) as Map;
      File? image = arguments['image'];
      if (image != null) {
        foodController.getFoodByImage(image);
      }
    });

    foodController.addListener(() {
      if (foodController.state == FoodState.error) {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(child: Text(foodController.erro));
          },
        );
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var foodModel = foodController.foodModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(foodModel.prato),
        centerTitle: true,
        leading: TapRegion(
          child: Icon(Icons.arrow_back),
          onTapInside: (event) {
            Navigator.of(context).popAndPushNamed('/');
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TapRegion(
                onTapInside: (event) {
                  if (foodModel.saved) {
                    foodController.deleteFood();
                  } else {
                    foodController.saveFood();
                  }
                },
                child: Icon(
                    foodModel.saved ? Icons.favorite : Icons.favorite_outline)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: foodController.state == FoodState.loading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  )
                ],
              )
            : ListView(
                children: [
                  if (foodModel.arquivoImagem != null)
                    Image.memory(foodModel.arquivoImagem!.readAsBytesSync()),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Text(foodModel.descricao, textAlign: TextAlign.justify),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  if (foodModel.ingredientes.isNotEmpty)
                    const Text(
                      'Ingredientes',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ...(foodModel.ingredientes.map((e) => Text('- $e')).toList()),
                  if (foodModel.instrucoes.isNotEmpty)
                    const Text(
                      'Modo de preparo',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ...(foodModel.instrucoes.map((e) => Text('- $e')).toList()),
                  if (foodModel.dicas.isNotEmpty)
                    const Text(
                      'Dicas',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ...(foodModel.dicas.map((e) => Text('- $e')).toList()),
                ],
              ),
      ),
    );
  }
}
