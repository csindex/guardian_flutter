import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:threading/threading.dart';

import '../../../utils/loading.dart';
import '../../../utils/constants/utils.dart';


class CameraScreen extends StatefulWidget {
  final String token;
  final ValueChanged<String> handleImage;

  CameraScreen({this.token, this.handleImage});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  List _cameras;
  int _selectedCameraIdx;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      _cameras = availableCameras;
      if (_cameras.length > 0) {
        setState(() {
          _selectedCameraIdx = 0;
        });
        _initCameraController(_cameras[_selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (_controller.value.hasError) {
        print('Camera error ${_controller.value.errorDescription}');
      }
    });
    try {
      await _controller.initialize();
      await Thread.sleep(500);
    } on CameraException catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: [
            _cameraPreviewWidget(size),
            Visibility(
              visible: _controller != null && _controller.value.isInitialized,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _cameraToggle(),
                      _cameraControl(context),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 48.0,
                ),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8.0,
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.transparent, // button color
                        child: InkWell(
                          splashColor: Colors.grey, // inkwell color
                          child: Container(
                            width: 36.0,
                            height: 36.0,
                            alignment: Alignment.center,
                            child: FaIcon(
                              FontAwesomeIcons.angleLeft,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'Return to Edit Profile',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget(Size size) {
    if (_controller == null || !_controller.value.isInitialized) {
      return Loading()/*Container(
        color: Colors.black,
        width: size.width,
        height: size.height,
        child: Center(
          child: Text(
            'Loading',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      )*/;
    }

    return Center(
      child: Transform.scale(
        scale: 1,
        child: Center(
          child: AspectRatio(
            aspectRatio: size.aspectRatio,
            child: CameraPreview(_controller),
          ),
        ),
      ),
    );
  }

  Widget _cameraControl(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: ClipOval(
          child: GestureDetector(
            onTap: () => onCapture(context),
            child: Container(
              width: 56.0,
              height: 56.0,
              color: Colors.white,
              child: Icon(
                Icons.camera,
                color: Colors.black,
                size: 36.0,
              ),
            ),
          ),
        )/*FloatingActionButton(
          child: Icon(
            Icons.camera,
            color: Colors.black,
            size: 36.0,
          ),
          backgroundColor: Colors.white,
          onPressed: () {
            onCapture(context);
          },
        )*/,
      ),
    );
  }

  Widget _cameraToggle() {
    if (_cameras == null || _cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = _cameras[_selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
            onPressed: () {
              onSwitchCamera();
            },
            icon: Icon(
              getCameraLensIcons(lensDirection),
              color: Colors.white,
              size: 36.0,
            ),
            label: Text(
              '${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1).toUpperCase()}',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            )),
      ),
    );
  }

  onCapture(context) async {
    try {
      await _controller.takePicture().then((value) {
        final tempPath = value.path;
        print('old path: $tempPath');
        widget.handleImage(tempPath);
        Navigator.pop(context);
      });
    } catch (e) {
      print(e);
    }
  }

  getCameraLensIcons(lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return Icons.switch_camera;
      case CameraLensDirection.front:
        return Icons.switch_camera_outlined;
      case CameraLensDirection.external:
        return Icons.photo_camera;
      default:
        return Icons.device_unknown;
    }
  }

  onSwitchCamera() {
    _selectedCameraIdx =
        _selectedCameraIdx < _cameras.length - 1 ? _selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = _cameras[_selectedCameraIdx];
    _initCameraController(selectedCamera);
  }
}
