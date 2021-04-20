import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_streaming_mobile/bloc/streaming.dart';
import 'package:video_streaming_mobile/constants/socket_events.dart';
import 'package:video_streaming_mobile/extensions/socket.io.dart';
import 'package:image/image.dart' as dartImage;

class VideoStreamingScreen extends StatefulWidget {
  @override
  _VideoStreamingScreenState createState() => _VideoStreamingScreenState();
}

class _VideoStreamingScreenState extends State<VideoStreamingScreen> {
  CameraController? _camera;
  CameraLensDirection _direction = CameraLensDirection.front;
  CameraImage? cameraImage = null;

  Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _uploadStreamDataWorker();
  }

  dispose() {
    super.dispose();
    streamingBloc.clearStore();
  }

  Future<Uint8List?> convertYUV420toImage(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      var img = dartImage.Image(width, height);
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          final pixelColor = image.planes[0].bytes[y * width + x];
          img.data[y * width + x] = (0xFF << 24) | (pixelColor << 16) | (pixelColor << 8) | pixelColor;
        }
      }
      img = dartImage.copyResize(img, width: 200, height: 200);
      dartImage.PngEncoder pngEncoder = new dartImage.PngEncoder(level: 0, filter: 0);
      return Uint8List.fromList(pngEncoder.encodeImage(img));
    } catch (e) {
      print("Image converting Error:" + e.toString());
    }
    return null;
  }

  Future<void> _uploadStreamDataWorker() async {
    if (streamingBloc.store == null) return;
    if (cameraImage == null) {
      _uploadStreamDataWorker();
      return;
    }
    Map<String, dynamic> request = {
      "to": streamingBloc.store!.name,
      "bytes": await convertYUV420toImage(cameraImage!),
    };
    IO.socket!.emitWithAck(SocketEvents.streamData.value, request, ack: () {
      _uploadStreamDataWorker();
    });
  }

  void _initializeCamera() async {
    _camera = CameraController(
      await _getCamera(_direction),
      ResolutionPreset.low,
    );
    await _camera!.initialize();
    _camera!.startImageStream((CameraImage image) {
      cameraImage = image;
    });
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sample Video Streaming App")),
      body: Container(
        color: Colors.black,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Positioned.fill(
              child: StreamBuilder(
                stream: streamingBloc.stream,
                builder: (_, __) {
                  if (streamingBloc.store!.lastFrame == null) return Container();
                  return Image.memory(streamingBloc.store!.lastFrame!, fit: BoxFit.contain, gaplessPlayback: true);
                },
              ),
            ),
            Positioned(
              bottom: 15,
              right: 15,
              child: Container(
                height: 150,
                width: 150,
                child: Transform.rotate(child: _camera?.buildPreview(), angle: math.pi / 2),
              ),
            )
          ],
        ),
      ),
    );
  }
}
