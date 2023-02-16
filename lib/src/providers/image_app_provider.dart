import 'package:yucelied/src/api/http_services.dart';
import 'package:yucelied/src/models/models.dart';

class ImageAppProvider {
  final HttpServices _httpService = HttpServices();

  Future<List<Imagemodel>> generarImagen(
      {required Map<String, dynamic> datos}) async {
    final response =
        await _httpService.httpPost('/images/generations', data: datos);
    final data = response.data;
    final listImagenes = List<Imagemodel>.from(
      data['data'].map((image) => Imagemodel.fromMapJson(image)),
    );

    return listImagenes;
  }
}
