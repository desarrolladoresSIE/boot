part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final bool loadingChat;
  final List<ConversationModel> conversations;
  const ChatState({
    this.conversations = const [],
    this.loadingChat = false,
  });

  ChatState copyWith({
    final bool? loadingChat,
    final List<ConversationModel>? conversations,
  }) =>
      ChatState(
        conversations: conversations ?? this.conversations,
        loadingChat: loadingChat ?? this.loadingChat,
      );

  @override
  List<Object?> get props => [conversations, loadingChat];
}
