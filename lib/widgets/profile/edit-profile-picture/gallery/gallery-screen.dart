import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utils/constants/utils.dart';

class GalleryScreen extends StatefulWidget {
  final String token;

  GalleryScreen(this.token);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  PickedFile _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: _image == null
                ? Text(
                    'No Photo Selected',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  )
                : Image.file(File(_image.path)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton(
              color: Colors.transparent.withAlpha(25),
              splashColor: Colors.grey,
              child: Container(
                width: double.infinity,
                height: 60,
                child: Center(
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                _saveProfilePicture().then((value) {
                  print('request ${value.reasonPhrase}');
                  http.Response.fromStream(value).then((response) {
                    print('save profile: ${response.body}');
                  });
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<http.StreamedResponse> _saveProfilePicture() async {
    print('path: ${_image.path} x ${File(_image.path).path.split('/').last}');
    Map<String, String> header = {
      'Content-Type': 'multipart/form-data;',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'x-auth-token': widget.token,
    };
    Map<String, String> params = {
      'status': 'Volunteer',
      'skills': 'EMS, EMT',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('$secretHollowsEndPoint/api/profile'));
    request.headers.addAll(header);
    request.files
        .add(await http.MultipartFile.fromPath('profilepic', _image.path));
    request.fields.addAll(params);
    var res = await request.send();
    return res;
    // http.Response.fromStream(res).then((response) {
    //   print('result? $response x ${response.statusCode} x ${response.body}');
    //   return response;
    // });
  }
}
