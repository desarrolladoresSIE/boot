part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ConversationsEvent extends ChatEvent {
  final List<ConversationModel> conversations;
  const ConversationsEvent(this.conversations);
}

class LoadingChatEvent extends ChatEvent {
  final bool loadingChat;
  const LoadingChatEvent(this.loadingChat);
}
