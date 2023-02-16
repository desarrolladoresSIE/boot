class ConversationModel {
  final String remitente;
  final String text;
  final DateTime dateTime;

  ConversationModel({
    required this.remitente,
    required this.text,
  }) : dateTime = DateTime.now();
}
