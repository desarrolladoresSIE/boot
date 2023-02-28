import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yucelied/src/models/models.dart';
import 'package:yucelied/src/providers/providers.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatProvider chatProvider;
  ChatBodyModel chatBodyModel = ChatBodyModel(prompt: 'hola');

  ChatBloc({required this.chatProvider}) : super(const ChatState()) {
    on<ConversationsEvent>(
      (event, emit) => emit(state.copyWith(conversations: event.conversations)),
    );
    on<LoadingChatEvent>(
      (event, emit) => emit(state.copyWith(loadingChat: event.loadingChat)),
    );
  }
  Future<void> getChat() async {
    add(const LoadingChatEvent(true));
    final miChat = ConversationModel(
      remitente: 'local',
      text: chatBodyModel.prompt,
    );
    add(ConversationsEvent([...state.conversations, miChat]));
    final response = await chatProvider.getChat(chatBodyModel);
    final chatBoot = ConversationModel(
      remitente: 'boot',
      text: response.text,
    );
    add(ConversationsEvent([...state.conversations, chatBoot]));
    add(const LoadingChatEvent(false));
  }
}
