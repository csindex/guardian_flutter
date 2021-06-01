import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/helpers/navigation-helper.dart';
import '../../utils/constants/utils.dart';

class ExpandableCreatePostForm extends StatefulWidget {
  final String token;
  final Function refresh;

  ExpandableCreatePostForm({this.token, this.refresh});

  @override
  _ExpandableCreatePostFormState createState() =>
      new _ExpandableCreatePostFormState();
}

class _ExpandableCreatePostFormState extends State<ExpandableCreatePostForm>
    with TickerProviderStateMixin<ExpandableCreatePostForm> {
  TextEditingController _postController;

  final _formPageKey = GlobalKey<FormState>();

  bool _isExpanded = false;

  final picker = ImagePicker();

  String _postMsg;

  File _imageFile;
  String _imagePath;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        var _image = pickedFile;
        _imagePath = _image.path;
        _imageFile = File(_imagePath);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController(text: '');
  }
  
  handleImagePath(String value) {
    print('CAMERA - $value');
    setState(() {
      _imagePath = value;
      _imageFile = File(_imagePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formPageKey,
      child: Container(
        color: Color(0xEEEEEE),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: colorPrimary,
                  border: Border.all(
                    color: colorPrimary,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                // color: colorPrimary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        (_isExpanded) ? 'Create a Post' : 'Say something...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Material(
                        color: colorPrimary, // button color
                        child: SizedBox(
                          width: 36.0,
                          height: 36.0,
                          child: Icon(
                            (_isExpanded)
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 100),
                child: ConstrainedBox(
                  constraints: _isExpanded
                      ? BoxConstraints()
                      : BoxConstraints(maxHeight: 0.0),
                  child: Column(
                    children: [/*Container(
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      border: Border.all(
                        color: Colors.grey[500],
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: */
                      Stack(
                        children: [
                          TextFormField(
                            key: Key('post'),
                            validator: (value) =>
                            value.isEmpty ? 'Please input something' : null,
                            controller: _postController,
                            autovalidateMode: AutovalidateMode.disabled,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.top,
                            decoration: _isExpanded
                                ? InputDecoration(
                                    contentPadding: (_imageFile != null)
                                        ? EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 128.0,)
                                        : EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 8.0,
                                        ),
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      borderSide: BorderSide(width: 1, color: Colors.black),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      borderSide:
                                      BorderSide(width: 1, color: Colors.grey.shade400),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      borderSide: BorderSide(width: 1.5,color: Colors.black),
                                    ),
                                    border: /*InputBorder.none,*/OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    hintText: 'Create a post',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                    labelText: '',
                                    labelStyle: TextStyle(
                                      fontSize: 0.0,
                                    ),
                                    // errorText: _validateMobileNumber ? _mobileNumberErrorMsg : null,
                                    errorStyle: TextStyle(
                                      letterSpacing: 1.5,
                                      fontSize: 10.0,
                                    ),
                                    counterText: '',
                                    counterStyle: TextStyle(
                                      fontSize: 0.0,
                                    ),
                                  )
                                : null,
                            keyboardType: TextInputType.text,
                            maxLines: 7,
                            minLines: 4,
                            onSaved: (String val) {
                              _postMsg = val;
                            },
                            onChanged: (String val) {
                              _postMsg = val;
                            },
                          ),
                          Positioned.fill(
                            bottom: 28.0,
                            right: 8.0,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Visibility(
                                visible: _imageFile != null,
                                child: Stack(
                                  children: [
                                    Container(
                                      color: Colors.black,
                                      child: Image.file(
                                        _imageFile ?? File(''),
                                        width: 112.0,
                                        height: 112.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned.fill(
                                      top: 2.0,
                                      right: 2.0,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: ClipOval(
                                          child: Material(
                                            color: Colors.grey.withOpacity(0.5), // button color
                                            child: InkWell(
                                              splashColor: Colors.grey, // inkwell color
                                              child: Container(
                                                width: 24.0,
                                                height: 24.0,
                                                alignment: Alignment.center,
                                                child: FaIcon(
                                                  FontAwesomeIcons.times,
                                                  color: Colors.black,
                                                  size: 12.0,
                                                ),
                                              ),
                                              onTap: () => setState(() => _imageFile = null),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 4.0,
                      // ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ClipOval(
                                  child: Material(
                                    color: colorPrimary, // button color
                                    child: InkWell(
                                      splashColor: Colors.grey, // inkwell color
                                      child: Container(
                                        width: 36.0,
                                        height: 36.0,
                                        alignment: Alignment.center,
                                        child: FaIcon(
                                          FontAwesomeIcons.camera,
                                          color: Colors.white,
                                          size: 12.0,
                                        ),
                                      ),
                                      onTap: () {
                                        // Navigator.pop(context);
                                        NavigationHelper.openCameraPost(context, widget.token, handleImagePath);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                ClipOval(
                                  child: Material(
                                    color: colorPrimary, // button color
                                    child: InkWell(
                                      splashColor: Colors.grey, // inkwell color
                                      child: Container(
                                        width: 36.0,
                                        height: 36.0,
                                        alignment: Alignment.center,
                                        child: FaIcon(
                                          FontAwesomeIcons.solidImages,
                                          color: Colors.white,
                                          size: 12.0,
                                        ),
                                      ),
                                      onTap: getImage,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                FlatButton(
                                  color: colorPrimary1,
                                  onPressed: () {
                                    _formPageKey.currentState.validate();
                                    _submitPost().then((value)  {
                                      print('value - ${value.stream}');
                                      http.Response.fromStream(value).then((response) {
                                        print('submit post: ${response.body}');
                                        if (!response.body.contains('error')) {
                                          setState(() {
                                            _imageFile = null;
                                            _postMsg = '';
                                            _postController.clear();
                                            _isExpanded = false;
                                          });
                                          widget.refresh();
                                        }
                                      });
                                    });
                                  },
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<http.StreamedResponse> _submitPost() async {
    // print('path: ${_image.path} x ${File(_image.path).path.split('/').last} x $_postMsg');
    Map<String, String> header = {
      'Content-Type': 'multipart/form-data;',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'x-auth-token': widget.token,
    };
    Map<String, String> params = {
      'text' : _postMsg,
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('$secretHollowsEndPoint/api/posts'));
    request.headers.addAll(header);
    request.files
        .add(await http.MultipartFile.fromPath('articleImage', _imagePath));
    request.fields.addAll(params);
    var res = await request.send();
    return res;
    // http.Response.fromStream(res).then((response) {
    //   print('result? $response x ${response.statusCode} x ${response.body}');
    //   return response;
    // });
  }
}
