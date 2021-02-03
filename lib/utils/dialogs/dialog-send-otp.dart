import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;

import '../../utils/constants/utils.dart';

class SendOtpDialog extends StatefulWidget {
  SendOtpDialog({
    Key key,
    this.registrationCode = '',
    @required this.mobileNumber,
    @required this.onLoadingChanged,
    this.name,
  }) : super(key: key);

  final ValueChanged<String> onLoadingChanged;
  final String mobileNumber;
  final String registrationCode;
  final String name;

  @override
  _SendOtpState createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtpDialog> {
  @override
  void initState() {
    super.initState();
    print('regCode: ${widget.registrationCode}');
    print('mobile number: ${widget.mobileNumber}');
  }

  @override
  Widget build(BuildContext context) {
    _getRegCode(widget.mobileNumber, widget.name).then((value) {
      // widget.registrationCode = value;
      // setState(() {
      // _isLoading = false;
      print('$value : ${value.length}');
      widget.onLoadingChanged(value);
      // });
    });
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: dialogColor, borderRadius: BorderRadius.circular(20.0)),
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 32.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.smartphone,
                        size: 110.0,
                        color: colorPrimary,
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/images/key.svg',
                          height: 24.0,
                          width: 24.0,
                          fit: BoxFit.fitWidth,
                          color: colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'One-Time PIN',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  widget.registrationCode.length == 4 ? 'Sending' : 'Sent',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  'Don\'t SHARE the PIN to anyone.',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                widget.registrationCode.length == 4
                    ? Container(
                        width: 48.0,
                        height: 48.0,
                        margin: EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Container(
                        height: 48.0,
                        margin:
                            EdgeInsets.only(top: 8.0, left: 64.0, right: 64.0),
                        child: RaisedButton(
                          elevation: 4.0,
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: dialogBtnColor,
                          splashColor: Colors.grey.shade500,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
              ],
            ),
          ],
        ),
      );

  Future<String> _getRegCode(String mobileNumber, String name) async {
    var url = 'https://ccc.guardian4emergency.com/mobile/getRegCodes';
    var response = name == null
        ? await http.get('$url?mobile=$mobileNumber')
        : await http.get('$url?mobile=$mobileNumber&name=$name');
    return response.body.replaceAll('\"', '');
  }
}
