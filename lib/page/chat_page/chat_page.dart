import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ai/hive_model/chat_item_model.dart';
import 'package:flutter_chat_ai/hive_model/message_item_model.dart';
import 'package:flutter_chat_ai/page/chat_page/bloc/chat_message_bloc.dart';
import 'package:flutter_chat_ai/page/chat_page/widgets/chat_input.dart';
import 'package:flutter_chat_ai/page/chat_page/widgets/message_date_item.dart';
import 'package:flutter_chat_ai/page/chat_page/widgets/message_item.dart';
import 'package:flutter_chat_ai/utils/chat_date_utils.dart';

class ChatPage extends StatefulWidget {
  final ChatItemModel chatItem;

  const ChatPage({super.key, required this.chatItem});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
    BlocProvider.of<ChatMessageBloc>(context)
        .add(ChatMessageInitialEvent(widget.chatItem));
  }

  void _scrollListener() {
    if (_scrollController.offset < _scrollController.position.maxScrollExtent) {
      setState(() {
        _showScrollButton = true;
      });
    } else {
      setState(() {
        _showScrollButton = false;
      });
    }
  }

  // 스크롤 최하단으로 이동
  void _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  // 메세지 추가
  void _addMessage(String message) {
    BlocProvider.of<ChatMessageBloc>(context).add(ChatMessageAddEvent(message));
  }

  // 메세지 그룹핑
  Map<String, List<MessageItemModel>> _groupMessageByDate(
      List<MessageItemModel> messages) {
    Map<String, List<MessageItemModel>> grouped = {};
    for (var message in messages) {
      String formattedDate = ChatDateUtils.formatTime(message.createdAt);
      if (grouped.containsKey(formattedDate)) {
        grouped[formattedDate]?.add(message); // 날짜로 구분 되어있으면 메세지 추가
      } else {
        grouped[formattedDate] = [message]; // 날짜로 구분 후 리스트 추가
      }
    }
    return grouped;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatMessageBloc, ChatMessageState>(
        listener: (context, state) {
      if (state.messages.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollToBottom();
          }
        });
      }
    }, builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Chat Room'),
          ),
          body: CustomScrollView(
            controller: _scrollController,
            slivers:
                _groupMessageByDate(state.messages).entries.expand((entry) {
              String date = entry.key;
              List<MessageItemModel> messages = entry.value;
              List<Widget> children = [];
              children
                  .add(SliverToBoxAdapter(child: MessageDateItem(date: date)));
              children.add(SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: messages.length,
                (context, index) => MessageItem(item: messages[index]),
              )));
              return children;
            }).toList(),
          ),
          floatingActionButton: _showScrollButton
              ? FloatingActionButton(onPressed: _scrollToBottom)
              : null,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: ChatInput(
                onSend: (message) => _addMessage(message),
                isLoading: state.isLoading),
          ));
    });
  }
}
