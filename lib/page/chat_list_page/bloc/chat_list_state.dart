part of 'chat_list_bloc.dart';

class ChatListState {
  final List<ChatItemModel> chats;

  const ChatListState({this.chats = const []});

  ChatListState copyWith({List<ChatItemModel>? chats}) =>
      ChatListState(chats: chats ?? this.chats);
}
