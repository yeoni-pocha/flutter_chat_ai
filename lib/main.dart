import 'package:flutter/material.dart';
import 'package:flutter_chat_ai/core/constants.dart';
import 'package:flutter_chat_ai/hive_model/chat_item_model.dart';
import 'package:flutter_chat_ai/hive_model/message_item_model.dart';
import 'package:flutter_chat_ai/hive_model/message_role_model.dart';
import 'package:flutter_chat_ai/page/chat_list_page/bloc/chat_list_bloc.dart';
import 'package:flutter_chat_ai/page/chat_list_page/chat_list_page.dart';
import 'package:flutter_chat_ai/page/chat_page/bloc/chat_message_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ChatItemModelAdapter());
  Hive.registerAdapter(MessageItemModelAdapter());
  Hive.registerAdapter(MessageRoleModelAdapter());
  await Hive.openBox<ChatItemModel>(kChatBox);
  await Hive.openBox<MessageItemModelAdapter>(kMessageBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatListBloc>(
            create: (context) =>
                ChatListBloc()..add(const ChatListInitEvent())),
        BlocProvider<ChatMessageBloc>(create: (context) => ChatMessageBloc()),
      ],
      child: MaterialApp(
        title: 'ChatGemini',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ChatListPage(),
      ),
    );
  }
}
