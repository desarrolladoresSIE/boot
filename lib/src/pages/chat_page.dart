import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yucelied/src/blocs/blocs.dart';
import 'package:yucelied/src/pages/pages.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController textEditingController;
  late ScrollController scrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuPage(),
      appBar: AppBar(
        title: const Text('JUCE-LIED CHAT'),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Column(
            children: [
              Flexible(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: state.conversations.length,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemBuilder: (_, i) {
                    final chat = state.conversations[i];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: (chat.remitente == 'local')
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: (chat.remitente == 'local')
                                  ? Theme.of(context).primaryColor
                                  : const Color.fromARGB(255, 223, 223, 223),
                              borderRadius: BorderRadius.circular(20)),
                          child: AnimatedTextKit(
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TyperAnimatedText(
                                chat.text,
                                speed: const Duration(milliseconds: 40),
                                textStyle: TextStyle(
                                  color: (chat.remitente == 'local'
                                      ? Colors.white
                                      : null),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (state.loadingChat) ...[
                const Center(
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(height: 10),
              ],
              Material(
                color: const Color.fromARGB(255, 232, 232, 232),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _FormDatatext(
                        controller: textEditingController,
                        focusNode: focusNode,
                      ),
                      const SizedBox(width: 5),
                      _ButtonSend(
                        controller: textEditingController,
                        focusNode: focusNode,
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _ButtonSend extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const _ButtonSend({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    return IconButton(
      color: Theme.of(context).primaryColor,
      onPressed: (!chatBloc.state.loadingChat)
          ? () async {
              focusNode.unfocus();
              chatBloc.chatBodyModel.prompt = controller.text;
              controller.clear();
              await chatBloc.getChat();
            }
          : null,
      icon: const Icon(Icons.send),
      tooltip: 'Enviar',
    );
  }
}

class _FormDatatext extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const _FormDatatext({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        maxLines: null,
        focusNode: focusNode,
        controller: controller,
        decoration: const InputDecoration.collapsed(
          hintText: '¿Cuál es tu pregunta?',
        ),
      ),
    );
  }
}
