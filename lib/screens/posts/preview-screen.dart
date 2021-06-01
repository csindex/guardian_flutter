import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/utils.dart';

class PreviewScreen extends StatefulWidget {
  final String imgPath;
  final String fileName;
  final String token;

  PreviewScreen({this.imgPath, this.fileName, this.token});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: Image.file(
              File(widget.imgPath),
              fit: BoxFit.cover,
            ),
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
    print('path: ${widget.imgPath} x ${widget.fileName}');
    Map<String, String> header = {
      'Content-Type': 'multipart/form-data;',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'x-auth-token': widget.token,
    };
    Map<String, String> params = {

    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('$secretHollowsEndPoint/api/profile'));
    request.headers.addAll(header);
    request.files
        .add(await http.MultipartFile.fromPath('profilepic', widget.imgPath));
    request.fields.addAll(params);
    var res = await request.send();
    return res;
    // http.Response.fromStream(res).then((response) {
    //   print('result? $response x ${response.statusCode} x ${response.body}');
    //   return response;
    // });
  }
}
