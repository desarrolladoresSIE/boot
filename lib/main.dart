import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yucelied/src/blocs/blocs.dart';
import 'package:yucelied/src/pages/home_page.dart';
import 'package:yucelied/src/pages/pages.dart';
import 'package:yucelied/src/providers/providers.dart';

void main() => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ImageBloc(
              imageProvider: ImageAppProvider(),
            ),
          ),
          BlocProvider(
            create: (_) => ChatBloc(
              chatProvider: ChatProvider(),
            ),
          ),
          BlocProvider(
            create: (_) => MenuBloc(),
          ),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      title: 'Yucelied',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (_) => const HomePage(),
        '/images': (_) => const ImagesPage(),
        '/chat': (_) => const ChatPage()
      },
    );
  }
}
