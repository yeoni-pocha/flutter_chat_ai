part of 'chat_message_bloc.dart';

sealed class ChatMessageEvent {
  const ChatMessageEvent();
}

final class ChatMessageInitialEvent extends ChatMessageEvent {
  final ChatItemModel chatItem;

  const ChatMessageInitialEvent(this.chatItem);
}

final class ChatMessageAddEvent extends ChatMessageEvent {
  final String message;

  const ChatMessageAddEvent(this.message);
}
