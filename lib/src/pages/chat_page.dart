import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yucelied/src/blocs/blocs.dart';
import 'package:yucelied/src/pages/pages.dart';

class ChatPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuPage(),
      appBar: AppBar(
        title: const Text('JUCE-LIED CHAT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        itemCount: state.conversations.length,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemBuilder: (_, i) {
                          final chat = state.conversations[i];
                          return ListTile(
                            title: Text(chat.text),
                            leading: (chat.remitente == 'boot')
                                ? const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/asistente.png'),
                                  )
                                : null,
                            trailing: (chat.remitente == 'local')
                                ? const CircleAvatar()
                                : null,
                          );
                        },
                      ),
                      if (state.loadingChat)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                    ],
                  ),
                ),
                SafeArea(
                  child: Row(
                    children: [
                      _FormDataText(controller: _controller),
                      const SizedBox(width: 5),
                      _ButtonSend(controller: _controller),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ButtonSend extends StatelessWidget {
  const _ButtonSend({
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    return IconButton(
      color: Colors.white,
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.blue),
      ),
      onPressed: (!chatBloc.state.loadingChat)
          ? () async {
              FocusManager.instance.primaryFocus?.unfocus();
              chatBloc.chatBodyModel.prompt = _controller.text;
              await chatBloc.getChat();
              _controller.text = '';
            }
          : null,
      icon: const Icon(Icons.send),
      tooltip: 'Enviar',
    );
  }
}

class _FormDataText extends StatelessWidget {
  const _FormDataText({
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _controller,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          hintText: '¿Cuál es tu pregunta?',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
