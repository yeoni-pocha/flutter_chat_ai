import 'package:flutter_chat_ai/core/env/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService() {
    final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: Env.apiKey);
    _model = model;
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      final responseText = response.text ?? '';
      return responseText;
    } catch (e) {
      return '죄송합니다. 오류가 발생했습니다: $e';
    }
  }
}
