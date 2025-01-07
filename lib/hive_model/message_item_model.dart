import 'package:flutter_chat_ai/hive_model/message_role_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'message_item_model.g.dart';

@HiveType(typeId: 1)
class MessageItemModel {
  @HiveField(0)
  final String message;
  @HiveField(1)
  final MessageRoleModel role;
  @HiveField(2)
  final DateTime createdAt;

  const MessageItemModel(this.message, this.role, this.createdAt);
}
