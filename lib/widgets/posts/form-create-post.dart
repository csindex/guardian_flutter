import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/constants/utils.dart';

class CreatePostForm extends StatefulWidget {
  @override
  _CreatePostFormState createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  TextEditingController _postController;

  final _formPageKey = GlobalKey<FormState>();

  // final _pageKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formPageKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4.0,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 32.0,
                top: 16.0,
              ),
              child: Text(
                'Posts',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: colorPrimary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidUser,
                    size: 14.0,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Flexible(
                    child: Text(
                      'Welcome to GUARDIAN community',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: Container(
                width: double.infinity,
                color: colorPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 12.0,
                ),
                child: Text(
                  'Say Something...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0,
              ),
              child: TextFormField(
                key: Key('post'),
                validator: (value) =>
                    value.isEmpty ? 'Please input something' : null,
                controller: _postController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide(width: 1.5, color: Colors.black),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    borderSide:
                        BorderSide(width: 1, color: Colors.grey.shade400),
                  ),
                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  //   borderSide: BorderSide(width: 1.5,color: Colors.black),
                  // ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    borderSide:
                        BorderSide(width: 1, color: Colors.grey.shade400),
                  ),
                  hintText: 'Create a post',
                  hintStyle: TextStyle(
                    color: Colors.white38,
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
                ),
                keyboardType: TextInputType.text,
                maxLines: 7,
                minLines: 4,
                onSaved: (String val) {
                  // _mobileNumber = val;
                  // _getRegCode();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: FlatButton(
                color: colorPrimary1,
                onPressed: () {},
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
          ],
        ),
      );
}
