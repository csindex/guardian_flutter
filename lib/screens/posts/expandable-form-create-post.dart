import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/utils.dart';

class ExpandableCreatePostForm extends StatefulWidget {
  @override
  _ExpandableCreatePostFormState createState() =>
      new _ExpandableCreatePostFormState();
}

class _ExpandableCreatePostFormState extends State<ExpandableCreatePostForm>
    with TickerProviderStateMixin<ExpandableCreatePostForm> {
  TextEditingController _postController;

  final _formPageKey = GlobalKey<FormState>();

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController(text: '');
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
            Container(
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
                      child: InkWell(
                        splashColor: Colors.grey, // inkwell color
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
                        onTap: () => setState(() => _isExpanded = !_isExpanded),
                      ),
                    ),
                  ),
                ],
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
                    child: */TextFormField(
                      key: Key('post'),
                      validator: (value) =>
                      value.isEmpty ? 'Please input something' : null,
                      controller: _postController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: _isExpanded ?
                      InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
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
                      ) : null,
                      keyboardType: TextInputType.text,
                      maxLines: 7,
                      minLines: 4,
                      onSaved: (String val) {
                        // _mobileNumber = val;
                        // _getRegCode();
                      },
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
}
