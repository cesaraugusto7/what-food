// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CameraComponent extends StatefulWidget {
  final Completer<XFile> _completerImage = Completer<XFile>();

  CameraComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraComponent> createState() => _CameraComponentState();

  open(BuildContext context, CameraComponent cameraComponent) async {
    showDialog(context: context, builder: (context) => cameraComponent);
    // await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => cameraComponent,
    //   ),
    // );
  }

  Future<File> getImage() async {
    XFile file = await _completerImage.future;
    return File(file.path);
  }
}

class _CameraComponentState extends State<CameraComponent> {
  CameraController? cameraController;
  late Size? size;
  late int camera;
  late bool flash;
  late double zoom;
  late double maxZoom;
  late double minZoom;
  List cameras = [];
  XFile? imagem;

  @override
  void initState() {
    camera = 0;
    flash = false;
    zoom = 1.0;
    maxZoom = 1.0;
    minZoom = 1.0;
    super.initState();
    _buscaCameras();
  }

  @override
  void dispose() {
    cameraController!.setFlashMode(FlashMode.off);
    super.dispose();
  }

  _buscaCameras() async {
    try {
      cameras = await availableCameras();
      _inicializaCamera();
    } on CameraException catch (e) {
      print(e.description);
    }
  }

  _inicializaCamera() async {
    if (cameras.isEmpty) {
    } else {
      cameraController = CameraController(
          cameras[camera],
          enableAudio: false,
          ResolutionPreset.ultraHigh,
          imageFormatGroup: ImageFormatGroup.jpeg);

      try {
        await cameraController!.initialize();
        await cameraController!.setZoomLevel(zoom);
        maxZoom = await cameraController!.getMaxZoomLevel();
        minZoom = await cameraController!.getMinZoomLevel();
        if (mounted) {
          setState(() {});
        }
      } on CameraException catch (e) {
        print(e.description);
      }
    }
  }

  _changeCamera() async {
    if ((camera + 1) > cameras.length - 1) {
      camera = 0;
    } else {
      camera = camera + 1;
    }
    await _inicializaCamera();
  }

  _mudarZoom(double scaleZoom) async {
    if (scaleZoom >= 1.0) {
      await cameraController!.setZoomLevel(scaleZoom);
      setState(() {
        zoom = scaleZoom;
      });
    }
  }

  _capturaFoto() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        imagem = await cameraController!.takePicture();
        if (mounted) {
          setState(() {});
        }
      } on CameraException catch (e) {
        print(e.description);
      }
    }
  }

  _fash() async {
    if (flash) {
      await cameraController!.setFlashMode(FlashMode.off);
      flash = false;
    } else {
      await cameraController!.setFlashMode(FlashMode.torch);
      flash = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: imagem == null
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TapRegion(
                  onTapInside: (event) {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
      ),
      body: _imagemWidget(),
      bottomSheet: imagem == null
          ? Container(
              width: double.maxFinite,
              height: size!.height * 0.12,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TapRegion(
                      onTapInside: (event) {
                        _changeCamera();
                      },
                      child: const Icon(
                        Icons.cameraswitch_outlined,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                    TapRegion(
                      onTapInside: (event) {
                        _capturaFoto();
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(97, 97, 97, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                                color: Colors.white24,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TapRegion(
                      onTapInside: (event) {
                        _fash();
                      },
                      child: const Icon(
                        Icons.bolt_outlined,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              width: double.maxFinite,
              height: size!.height * 0.12,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TapRegion(
                    onTapInside: (event) {
                      setState(() {
                        imagem = null;
                      });
                    },
                    child: const Icon(
                      Icons.close_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  TapRegion(
                    onTapInside: (event) {
                      widget._completerImage.complete(imagem);
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.check_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _imagemWidget() {
    return SizedBox(
      width: size!.width,
      height: size!.height * 0.79,
      child: imagem == null
          ? _cameraPreview()
          : Image.file(
              File(imagem!.path),
              fit: BoxFit.contain,
            ),
    );
  }

  _cameraPreview() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return CameraPreview(
        cameraController!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Slider(
                label: '${zoom.toStringAsFixed(1)}x',
                max: maxZoom,
                min: minZoom,
                divisions: 10,
                value: zoom,
                onChanged: ((value) => _mudarZoom(value)),
              ),
            ),
          ],
        ),
      );
    }
  }
}
