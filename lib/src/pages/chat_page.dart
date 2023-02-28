import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
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
  late GlobalKey<FormState> globalkey;
  bool activeMicrofono = false;
  late SpeechToText speechToText;
  String textAudio = '';
  bool mute = false;
  late FlutterTts flutterTts;
  @override
  void initState() {
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    focusNode = FocusNode();
    flutterTts = FlutterTts();
    speechToText = SpeechToText();
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
        actions: [
          IconButton(
            onPressed: () => setState(() {
              mute = !mute;
            }),
            tooltip: (mute) ? 'Activar sonido' : 'Silenciar sonido',
            icon: Icon((mute) ? Icons.volume_off : Icons.volume_up),
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Column(
            children: [
              Flexible(
                child: (!activeMicrofono)
                    ? ListView.builder(
                        controller: scrollController,
                        itemCount: state.conversations.length,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemBuilder: (_, i) {
                          final chat = state.conversations[i];
                          if (chat.remitente == 'boot' &&
                              state.conversations.length - 1 == i) {
                            _textVoz(text: chat.text, flutterTts: flutterTts,mute: mute);
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 13,
                            ),
                            child: GestureDetector(
                              onTap: (chat.remitente == 'boot')
                                  ? () async {
                                      _textVoz(
                                        text: chat.text,
                                        flutterTts: flutterTts,
                                        mute: mute
                                      );
                                    }
                                  : null,
                              child: Align(
                                alignment: (chat.remitente == 'local')
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: (chat.remitente == 'local')
                                        ? Theme.of(context).primaryColor
                                        : const Color.fromARGB(
                                            255, 223, 223, 223),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: AnimatedTextKit(
                                    isRepeatingAnimation: false,
                                    repeatForever: false,
                                    displayFullTextOnTap: false,
                                    totalRepeatCount: 1,
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        chat.text.trim(),
                                        speed: Duration(
                                            milliseconds: (i ==
                                                        state.conversations
                                                                .length -
                                                            1 &&
                                                    chat.remitente == 'boot')
                                                ? 40
                                                : 0),
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
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (textAudio != '')
                                ? textAudio
                                : 'dime tu pregunta, te escucho....',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 87, 87, 87),
                            ),
                          ),
                        ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    children: [
                      _FormDatatext(
                        controller: textEditingController,
                        focusNode: focusNode,
                      ),
                      const SizedBox(width: 14),
                      AvatarGlow(
                        animate: activeMicrofono,
                        endRadius: 30,
                        glowColor: Theme.of(context).primaryColor,
                        child: (!state.loadingChat)
                            ? GestureDetector(
                                onTapDown: (_) async {
                                  if (!activeMicrofono) {
                                    final available =
                                        await speechToText.initialize();
                                    if (available) {
                                      setState(() {
                                        textAudio = '';
                                        activeMicrofono = true;
                                      });
                                      speechToText.listen(onResult: (resut) {
                                        setState(() {
                                          textAudio = resut.recognizedWords;
                                        });
                                      });
                                    }
                                  }
                                },
                                onTapUp: (_) async {
                                  setState(() {
                                    activeMicrofono = false;
                                  });
                                  speechToText.stop();
                                  _submitbutton(
                                      focusNode: focusNode,
                                      textEditingController:
                                          textEditingController,
                                      context: context,
                                      textAudio: textAudio,
                                      flutterTts: flutterTts);
                                },
                                child: CircleAvatar(
                                  child: Icon((activeMicrofono)
                                      ? Icons.mic_none_rounded
                                      : Icons.mic),
                                ),
                              )
                            : Container(),
                      ),
                      _ButtonSend(
                        controller: textEditingController,
                        focusNode: focusNode,
                        flutterTts: flutterTts,
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
  final FlutterTts flutterTts;
  const _ButtonSend({
    required this.controller,
    required this.focusNode,
    required this.flutterTts,
  });

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    return (!chatBloc.state.loadingChat)
        ? IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: () async => _submitbutton(
                focusNode: focusNode,
                textEditingController: controller,
                context: context,
                flutterTts: flutterTts),
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: 'Enviar',
          )
        : Container();
  }
}

class _FormDatatext extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const _FormDatatext({
    required this.controller,
    required this.focusNode,
  });

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

Future _submitbutton({
  required FocusNode focusNode,
  required TextEditingController textEditingController,
  required BuildContext context,
  String? textAudio,
  required FlutterTts flutterTts,
}) async {
  final chatBloc = BlocProvider.of<ChatBloc>(context);
  final textprompt = textAudio ?? textEditingController.text;
  focusNode.unfocus();
  if (textprompt == '') {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 162, 67, 61),
        content: Text('Tienes que realizar una pregunta'),
      ),
    );
    return;
  }
  chatBloc.chatBodyModel.prompt = textprompt;
  textEditingController.clear();
  await chatBloc.getChat();
}

Future _textVoz({required String text, required FlutterTts flutterTts,required bool mute}) async {
  await flutterTts.setVolume((mute) ? 0 : 1);
  await flutterTts.setLanguage('es-ES');
  await flutterTts.speak(text);
}
