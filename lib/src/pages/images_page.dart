import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:yucelied/src/blocs/blocs.dart';
import 'package:yucelied/src/models/image_model.dart';
import 'package:yucelied/src/pages/pages.dart';

class ImagesPage extends StatelessWidget {
  const ImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageBloc = BlocProvider.of<ImageBloc>(context);
    return Scaffold(
      drawer: const MenuPage(),
      appBar: AppBar(
        title: const Text('JUCE-LIED IMAGENES'),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: BlocBuilder<ImageBloc, ImageState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _InputDescripcion(imageBloc: imageBloc),
                  const SizedBox(height: 20),
                  _ButtonGenerar(imageBloc: imageBloc),
                  const SizedBox(height: 30),
                  _TextResult(imageBloc: imageBloc),
                  const SizedBox(height: 30),
                  (!state.loadingImage)
                      ? _CardResultImage(
                          imagenes: state.imagenes,
                        )
                      : const _LoadingImageResult(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoadingImageResult extends StatelessWidget {
  const _LoadingImageResult();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            'Creando imagen con su descripcion',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 76, 76, 76),
            ),
          ),
          const SizedBox(height: 29),
          LottieBuilder.asset(
            'assets/images/logo.json',
            width: 350,
          )
        ],
      ),
    );
  }
}

class _CardResultImage extends StatelessWidget {
  final List<Imagemodel> imagenes;
  const _CardResultImage({required this.imagenes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: imagenes.length,
      itemBuilder: (_, i) {
        final imagen = imagenes[i];
        return FadeInLeft(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (_) => GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: InteractiveViewer(
                    child: _ImagenGenerada(imagen: imagen),
                  ),
                ),
              ),
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/loading.gif'),
                image: NetworkImage(imagen.url!),
                width: double.infinity,
              ),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
    );
  }
}

class _TextResult extends StatelessWidget {
  const _TextResult({
    required this.imageBloc,
  });

  final ImageBloc imageBloc;

  @override
  Widget build(BuildContext context) {
    return Text(
      imageBloc.textResult,
      style: const TextStyle(
        fontSize: 24,
        color: Color.fromARGB(255, 85, 85, 85),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ButtonGenerar extends StatelessWidget {
  const _ButtonGenerar({
    required this.imageBloc,
  });

  final ImageBloc imageBloc;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (!imageBloc.state.loadingImage)
          ? () async {
              FocusManager.instance.primaryFocus?.unfocus();
              await imageBloc.generarImagen();
            }
          : null,
      child: (imageBloc.state.loadingImage)
          ? const Text('Generando...')
          : const Text('Generar Imagen'),
    );
  }
}

class _InputDescripcion extends StatelessWidget {
  const _InputDescripcion({
    required this.imageBloc,
  });

  final ImageBloc imageBloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (text) => imageBloc.imageData['prompt'] = text,
      decoration: const InputDecoration(
          suffixIcon: Icon(Icons.arrow_circle_right_outlined),
          label: Text('Captura cualquier idea que tengas'),
          hintText: 'Ejemplo: Perro comiendo cereal con cuchara'),
    );
  }
}

class _ImagenGenerada extends StatelessWidget {
  const _ImagenGenerada({
    required this.imagen,
  });

  final Imagemodel imagen;

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: const AssetImage('assets/images/loading.gif'),
      image: NetworkImage(imagen.url!),
      width: double.infinity,
    );
  }
}
