import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:whatfood/app/model/food_model.dart';
import 'package:whatfood/app/utils/custon_error.dart';

class GeminiRepositore {
  //final String apiKey = Platform.environment['API_KEY'].toString();
  final String apiKey = 'AIzaSyC38CGqT6QZSSDlnA6tzD26EbACl0tJrU4';

  Future<FoodModel> getFoodByImage(File image) async {
    try {
      final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
      final prompt = TextPart(
          'Basedo na sua analise e descrição da imagem me retorne o possivel nome da comida.\nAdicione também uma receita com os ingredientes e modo de preparo.\nAdicione também alguma dica relacionada a receita.\nRetorne as informações em um JSON ou seja apenas uma String com o objeto. O JSON deve seguir o seguinte padrão:{"prato": "nome do prato (String)","descricao": "descrição do prato (String)","ingredientes":"Lista de ingredientes (Array de String)","instrucoes":"Sequencia dos procedimentos para preparar o prato (Array de String)","dicas":"Lista de dicas relacionas ao prato (Array de String)"} .\nDevolva apenas o objeto Json e remova qualquer caracter que possa atrapar o json.decode do Dart.\n Em alguns casos tem retornado aspas invertidas no objeto JSON o que tem ocasionado erro ao realizar um parse, evite enviar esse caracter.\nTodos os valores devem estar em Português do Brasil.');
      final imageParts = [
        DataPart('image/jpeg', await image.readAsBytes()),
      ];
      final response = await model.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);
      return FoodModel.fromJson(
          (response.text as String).replaceAll("`", "").replaceAll('json', ''));
    } catch (error) {
      throw CustonError(message: 'Erro ao analisar imagem. Tente novamente!');
    }
  }
}
