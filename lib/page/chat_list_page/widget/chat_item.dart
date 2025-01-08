import 'package:flutter/material.dart';
import 'package:flutter_chat_ai/hive_model/chat_item_model.dart';

class ChatItem extends StatelessWidget {
  final ChatItemModel item;
  final VoidCallback onTapped;
  final VoidCallback onDelete;

  const ChatItem(
      {super.key,
      required this.item,
      required this.onTapped,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      onTap: onTapped,
      trailing: IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
    );
  }
}
