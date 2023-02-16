import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.gif'),
            ),
            accountName: Text('JUCE-LIED'),
            accountEmail: Text('La IA mas potente del mundo'),
          ),
          ListTile(
            title: const Text('Iniciar chat'),
            trailing: const Icon(Icons.chat),
            onTap: () => Navigator.pushNamed(context, '/chat'),
          ),
          ListTile(
            title: const Text('Generar imágenes'),
            trailing: const Icon(Icons.image),
            onTap: () => Navigator.pushNamed(context, '/images'),
          ),
        ],
      ),
    );
  }
}
