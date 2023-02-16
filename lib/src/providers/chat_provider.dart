import 'package:yucelied/src/api/http_services.dart';
import 'package:yucelied/src/models/models.dart';

class ChatProvider {
  final HttpServices _httpService = HttpServices();

  Future<ChatModel> getChat(ChatBodyModel data) async {
    final response = await _httpService.httpPost('/completions', data: data.toJson());
    final chatResponse = ChatModel.fromMapJson(response.data);
    return chatResponse;
  }
}
