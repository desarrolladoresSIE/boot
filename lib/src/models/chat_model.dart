class ChatModel {
  final String text;

  ChatModel({required this.text});

  factory ChatModel.fromMapJson(Map<String, dynamic> json) => ChatModel(
        text: json['choices'][0]['text'],
      );
}

class ChatBodyModel {
  String model;
  String prompt;
  int maxTokens;
  int temperature;
  int topP;
  int n;
  bool stream;

  ChatBodyModel({
    this.model = 'text-davinci-003',
    this.maxTokens = 4000,
    this.n = 1,
    required this.prompt,
    this.stream = false,
    this.temperature = 0,
    this.topP = 1,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
        'prompt': prompt,
        'max_tokens': maxTokens,
        'temperature': temperature,
        'top_p': topP,
        'n': n,
        'stream': stream,
      };
}
