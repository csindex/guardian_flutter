import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guardian_flutter/data/user/data-user-details.dart';
import 'package:guardian_flutter/provider/user/viewmodel-user-profile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/utils.dart';
import '../../utils/loading.dart';

class AddTraining extends StatefulWidget {
  final String token;
  final Function refresh;

  AddTraining({
    Key key,
    this.token,
    this.refresh,
  }) : super(key: key);

  @override
  _AddTrainingState createState() => _AddTrainingState();
}

class _AddTrainingState extends State<AddTraining> {
  var _errorMsg;
  final _formPageKey = GlobalKey<FormState>();

  String _title;
  String _company;
  String _location;
  String _dateFrom;
  bool _isCurrent = false;
  String _dateTo;
  String _desc;
  bool _isLoading = false;

  TextEditingController _ttlController;
  TextEditingController _compController;
  TextEditingController _locController;
  TextEditingController _descController;

  Future<String> addTraining() async {
    print('$_title - $_company - $_location - $_dateFrom - $_isCurrent - $_dateTo - $_desc');
    final url = Uri.parse('$secretHollowsEndPoint/api/profile/experience');
    Map data = {
      'title' : _title,
      'company' : _company,
      'location' : _location,
      'from' : _dateFrom,
      'to' : _dateTo,
      'current' : '$_isCurrent',
      'description' : _desc,
    };
    print('data - $data');
    var reqBody = jsonEncode(data);
    final response = await http.put(
      url,
      headers: {
        'Cache-Control' : 'no-cache',
        'Accept' : '*/*',
        'Accept-Encoding' : 'gzip, deflate, br',
        'Connection' : 'keep-alive',
        'Content-Type': 'application/json',
        'x-auth-token': widget.token,
      },
      body: reqBody,
    );
    print('add training - ${response.body}');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'failed';
    }
  }

  @override
  void initState() {
    super.initState();
    _isCurrent = false;
    _ttlController = TextEditingController(text: '');
    _compController = TextEditingController(text: '');
    _locController = TextEditingController(text: '');
    _descController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _ttlController.dispose();
    _compController.dispose();
    _locController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Loading() : Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Form(
          key: _formPageKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      'Add Trainings/Experiences',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: colorPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  _header,
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    '* = required field',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    key: Key('title'),
                    validator: (value) =>
                    value.isEmpty ? '* Please enter your Job Title' : null,
                    controller: _ttlController,
                    autovalidateMode: AutovalidateMode.disabled,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
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
                        borderSide: BorderSide(width: 1.5, color: Colors.black),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      hintText: '* Job Title',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                      labelText: '* Job Title',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      errorText: _errorMsg,
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
                    maxLines: 1,
                    minLines: 1,
                    onSaved: (String val) {
                      _title = val;
                    },
                    onChanged: (String val) {
                      _title = val;
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    key: Key('company'),
                    validator: (value) =>
                    value.isEmpty ? '* Please enter your Company' : null,
                    controller: _compController,
                    autovalidateMode: AutovalidateMode.disabled,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
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
                        borderSide: BorderSide(width: 1.5, color: Colors.black),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      hintText: '* Company',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                      labelText: '* Company',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      errorText: _errorMsg,
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
                    maxLines: 1,
                    minLines: 1,
                    onSaved: (String val) {
                      _company = val;
                    },
                    onChanged: (String val) {
                      _company = val;
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    key: Key('location'),
                    // validator: (value) =>
                    // value.isEmpty ? '* Please enter your Company Location' : null,
                    controller: _locController,
                    autovalidateMode: AutovalidateMode.disabled,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
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
                        borderSide: BorderSide(width: 1.5, color: Colors.black),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      hintText: 'Location',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                      labelText: 'Location',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      errorText: _errorMsg,
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
                    maxLines: 1,
                    minLines: 1,
                    onSaved: (String val) {
                      _location = val;
                    },
                    onChanged: (String val) {
                      _location = val;
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      primary: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 16.0,),
                      side: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      DateTime _currentBirthDate = DateTime.now();
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime.now(),
                        onChanged: (date) {
                          print('change $date');
                        },
                        onConfirm: (date) {
                          print('confirm: $date');
                          setState(() {
                            _dateFrom = DateFormat('MM-dd-yyyy').format(date);
                            print('_bdate - $_dateFrom');
                          });
                        },
                        currentTime: DateTime(
                          _currentBirthDate.year,
                          _currentBirthDate.month,
                          _currentBirthDate.day,
                        ),
                        locale: LocaleType.en,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _dateFrom != null && _dateFrom != ''
                              ? 'From Date: $_dateFrom'
                              : '* From Date (MM-dd-yyyy)',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        tristate: false,
                        value: _isCurrent,
                        activeColor: colorPrimary,
                        onChanged: (value) {
                          setState(() {
                            _isCurrent = !_isCurrent;
                          });
                        },
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        '* Current Job?',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: !_isCurrent,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        primary: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 16.0,),
                        side: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        DateTime _currentBirthDate = DateTime.now();
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime(1900, 1, 1),
                          maxTime: DateTime.now(),
                          onChanged: (date) {
                            print('change $date');
                          },
                          onConfirm: (date) {
                            print('confirm: $date');
                            setState(() {
                              _dateTo = DateFormat('MM-dd-yyyy').format(date);
                              print('_bdate - $_dateTo');
                            });
                          },
                          currentTime: DateTime(
                            _currentBirthDate.year,
                            _currentBirthDate.month,
                            _currentBirthDate.day,
                          ),
                          locale: LocaleType.en,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48.0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _dateTo != null && _dateTo != ''
                                ? 'To Date: $_dateTo'
                                : '* To Date (MM-dd-yyyy)',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_isCurrent,
                    child: SizedBox(
                      height: 12.0,
                    ),
                  ),
                  TextFormField(
                    key: Key('desc'),
                    // validator: (value) =>
                    // value.isEmpty ? 'Please enter your Job Description' : null,
                    controller: _descController,
                    autovalidateMode: AutovalidateMode.disabled,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
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
                        borderSide: BorderSide(width: 1.5, color: Colors.black),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      hintText: 'Job Description',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                      labelText: 'Job Description',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      errorText: _errorMsg,
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
                    maxLines: 4,
                    minLines: 4,
                    onSaved: (String val) {
                      _desc = val;
                    },
                    onChanged: (String val) {
                      _desc = val;
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: colorPrimary,
                          primary: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16.0,),
                        ),
                        onPressed: () {
                          if (_formPageKey.currentState.validate()) {
                            if (_dateFrom != null && _dateFrom != '') {
                              if (_isCurrent || (!_isCurrent && (_dateTo != null && _dateTo != ''))) {
                                setState(() {
                                  _isLoading = true;
                                });
                                addTraining().then((value) {
                                  print('addTraining value is $value');
                                  if (!value.contains('error')) {
                                    widget.refresh(null);
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                });
                              }
                            }
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          primary: colorPrimary,
                          padding: EdgeInsets.symmetric(horizontal: 16.0,),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Go Back',
                          style: TextStyle(
                            fontSize: 16.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _header
  => Row(
    children: [
      FaIcon(
        FontAwesomeIcons.codeBranch,
        size: 20.0,
        color: Colors.black,
      ),
      SizedBox(
        width: 8.0,
      ),
      Flexible(
        child: Text(
          'Add any emergency responder positions that you have had in the past',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    ],
  );
}
