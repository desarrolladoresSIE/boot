import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yucelied/src/models/models.dart';
import 'package:yucelied/src/providers/providers.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageAppProvider imageProvider;
  String textResult = '';
  Map<String, dynamic> imageData = {'prompt': '', 'n': 8, 'size': '1024x1024'};
  ImageBloc({
    required this.imageProvider,
  }) : super(const ImageState()) {
    on<ListImagenesEvent>(
      (event, emit) => emit(
        state.copyWith(imagenes: event.imagenes),
      ),
    );
    on<LoadingImageEvent>(
      (event, emit) => emit(
        state.copyWith(loadingImage: event.loading),
      ),
    );
  }

  Future<void> generarImagen() async {
    textResult = '';
    add(const LoadingImageEvent(true));
    final imagenes = await imageProvider.generarImagen(datos: imageData);
    add(ListImagenesEvent(imagenes));
    textResult = imageData['prompt'];
    imageData['prompt'] = '';
    add(const LoadingImageEvent(false));
  }
}
