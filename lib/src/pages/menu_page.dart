import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yucelied/src/blocs/blocs.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}
class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final menuBloc = BlocProvider.of<MenuBloc>(context);
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        return NavigationDrawer(
          selectedIndex: state.indexMenu,
          onDestinationSelected: (i) {
            menuBloc.add(IndexMenuEvent(i));
            Navigator.pop(context);
          },
          children: const [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.gif'),
              ),
              accountName: Text('JUCE-LIED'),
              accountEmail: Text('La IA mas potente del mundo'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.chat_outlined),
              selectedIcon: Icon(Icons.chat),
              label: Text('Chat inteligente'),
            ),
            NavigationDrawerDestination(
              selectedIcon: Icon(Icons.image),
              icon: Icon(Icons.image_outlined),
              label: Text('Generar imágenes'),
            ),
          ],
        );
      },
    );
  }
}
