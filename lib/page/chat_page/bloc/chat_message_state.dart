part of 'chat_message_bloc.dart';

class ChatMessageState {
  final ChatItemModel? chatItem;
  final List<MessageItemModel> messages;
  final bool isLoading;

  const ChatMessageState(
      {this.chatItem, this.messages = const [], this.isLoading = false});

  ChatMessageState copyWith(
          {ChatItemModel? chatItem,
          List<MessageItemModel>? messages,
          bool? isLoading}) =>
      ChatMessageState(
          chatItem: chatItem ?? this.chatItem,
          messages: messages ?? this.messages,
          isLoading: isLoading ?? this.isLoading);
}

final class ChatMessagesLoadingState extends ChatMessageState {
  ChatMessagesLoadingState();
}
