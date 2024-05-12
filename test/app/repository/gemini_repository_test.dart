import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:whatfood/app/repository/gemini_repository.dart';

void main() {
  test('gemini repository ...', () async {
    File image = File('img_test.jpg');
    GeminiRepositore geminiRepositore = GeminiRepositore();
    expect((await geminiRepositore.getFoodByImage(image)).prato, 'Lasanha');
  });
}
