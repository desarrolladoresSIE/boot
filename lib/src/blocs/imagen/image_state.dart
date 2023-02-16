part of 'image_bloc.dart';

class ImageState extends Equatable {
  final List<Imagemodel> imagenes;
  final bool loadingImage;
  const ImageState({
    this.imagenes = const [],
    this.loadingImage = false,
  });

  ImageState copyWith({
    final List<Imagemodel>? imagenes,
    final bool? loadingImage,
  }) =>
      ImageState(
        imagenes: imagenes ?? this.imagenes,
        loadingImage: loadingImage ?? this.loadingImage,
      );
  @override
  List<Object?> get props => [imagenes, loadingImage];
}
