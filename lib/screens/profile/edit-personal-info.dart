import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/utils.dart';

class EditPersonalInfo extends StatefulWidget {
  @override
  _EditPersonalInfoState createState() => _EditPersonalInfoState();
}

class _EditPersonalInfoState extends State<EditPersonalInfo> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'LGBT',
  ];

  final List<String> _civilStatusOptions = [
    'Single',
    'Married',
    'Widowed',
    'Separated',
  ];

  String _bio;
  String _gender;
  String _civilStatus;
  String _birthDate;
  String _homeAddress;

  @override
  void initState() {
    super.initState();
    _bio = 'This is a sample bio.';
    _gender = 'LGBT';
    _civilStatus = 'Single';
    _birthDate = '03/23/1993';
    _homeAddress = 'Unit 210, KRC Building, Subangdaku, Mandaue City, Cebu';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Update Personal Information',
              style: TextStyle(
                color: colorPrimary,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          TextFormField(
            initialValue: _homeAddress,
            decoration: textInputDecoration,
            // validator: (val) => val.isEmpty ? 'Please enter your code' : null,
            onChanged: (val) => _homeAddress = val,
            minLines: 1,
            maxLines: 2,
          ),
          SizedBox(
            height: 16.0,
          ),
          TextFormField(
            initialValue: _bio,
            decoration: textInputDecoration,
            // validator: (val) => val.isEmpty ? 'Please enter your code' : null,
            onChanged: (val) => _bio = val,
            minLines: 1,
            maxLines: 2,
          ),
          SizedBox(
            height: 16.0,
          ),
          DropdownButtonFormField(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            value: _gender ?? _genderOptions[0],
            decoration: textInputDecoration,
            items: _genderOptions.map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text('$c'),
              );
            }).toList(),
            onChanged: (val) => _gender = val,
          ),
          SizedBox(
            height: 16.0,
          ),
          DropdownButtonFormField(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            value: _civilStatus ?? _civilStatusOptions[0],
            decoration: textInputDecoration,
            items: _civilStatusOptions.map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text('$c'),
              );
            }).toList(),
            onChanged: (val) => _civilStatus = val,
          ),
          SizedBox(
            height: 16.0,
          ),
          FlatButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              DateTime _currentBirthDate = DateTime.now();
              try {
                _currentBirthDate = DateTime.parse(DateFormat('yyyyMMdd')
                    .format(DateFormat('MM/dd/yyyy').parse(_birthDate)));
              } catch (e) {
                print(e);
              }
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
                    _birthDate = DateFormat('MM/dd/yyyy').format(date);
                    print('_bdate - $_birthDate');
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
                  _birthDate ?? 'Select Birth date (mm/dd/yyyy)',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: BorderSide(
                color: colorPrimary,
                width: 2.0,
              ),
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          Center(
            child: RaisedButton(
              color: colorPrimary,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
