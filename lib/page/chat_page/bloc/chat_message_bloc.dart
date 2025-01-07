import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ai/api/gemini_service.dart';
import 'package:flutter_chat_ai/hive_model/chat_item_model.dart';
import 'package:flutter_chat_ai/hive_model/message_item_model.dart';
import 'package:flutter_chat_ai/hive_model/message_role_model.dart';

part 'chat_message_event.dart';

part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  final GeminiService _geminiService = GeminiService();

  ChatMessageBloc() : super(ChatMessagesLoadingState()) {
    on<ChatMessageInitialEvent>(_onChatMessageInit);
    on<ChatMessageAddEvent>(_onChatMessageAdd);
  }

  void _onChatMessageInit(
      ChatMessageInitialEvent event, Emitter<ChatMessageState> emit) {
    final chatItem = event.chatItem;
    final messages = chatItem.messages;

    emit(state.copyWith(chatItem: chatItem, messages: messages));
  }

  void _onChatMessageAdd(
      ChatMessageAddEvent event, Emitter<ChatMessageState> emit) async {
    final message = event.message;
    final newMessage =
        MessageItemModel(message, MessageRoleModel.user, DateTime.now());

    state.chatItem?.messages.add(newMessage);
    state.chatItem?.save();
    // 사용자가 채팅을 입력 후, API로 부터 응답을 기다리는 상황
    emit(state.copyWith(messages: state.messages, isLoading: true));

    // Gemini API로부터 응답 받기
    final response = await _geminiService.sendMessage(message);
    final newAiMessage =
        MessageItemModel(response, MessageRoleModel.ai, DateTime.now());
    state.chatItem?.messages.add(newAiMessage);
    state.chatItem?.save();
    emit(state.copyWith(messages: state.messages, isLoading: false));
  }
}
