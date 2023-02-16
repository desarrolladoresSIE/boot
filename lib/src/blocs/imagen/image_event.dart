part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class ListImagenesEvent extends ImageEvent {
  final List<Imagemodel> imagenes;

  const ListImagenesEvent(this.imagenes);
}

class LoadingImageEvent extends ImageEvent {
  final bool loading;
  const LoadingImageEvent(this.loading);
}
