import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';
import '../../utils/helpers/navigation-helper.dart';


class EditPersonalInfo extends StatefulWidget {
  final UserProfileViewModel userProfileVM;
  final String token;

  EditPersonalInfo({this.userProfileVM, this.token});

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
  double _lat = 0.0;
  double _lng = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.userProfileVM != null) {
      _bio = widget.userProfileVM.bio ?? '';
      _gender = widget.userProfileVM.gender;
      _civilStatus = widget.userProfileVM.civilStatus;
      _birthDate = widget.userProfileVM.birthDate;
      _homeAddress = widget.userProfileVM.homeAddress;
      _lat = widget.userProfileVM.lat ?? 0.0;
      _lng = widget.userProfileVM.lng ?? 0.0;
    }
  }

  void _onAddressSelected(AddressLatLng aLL) {
    print('address Selected x ${aLL.address} x ${aLL.lat} x ${aLL.lng}');
    setState(() {
      _homeAddress = aLL.address;
      _lat = aLL.lat;
      _lng = aLL.lng;
    });
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
          Padding(
            padding: EdgeInsets.only(left: 12.0,),
            child: Text(
              'Home Address',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              NavigationHelper.openSelectAddress(context, _onAddressSelected, LatLng(_lat, _lng));
            },
            child: Container(
              width: double.infinity,
              height: 48.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _homeAddress ?? 'Please select home address',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
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
            height: 16.0,
          ),
          TextFormField(
            initialValue: _bio,
            decoration: editInputDecoration.copyWith(
              labelText: 'Bio',
              hintText: 'Please tell us a little about yourself'
            ),
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
            value: _gender,
            decoration: editInputDecoration.copyWith(
              labelText: 'Gender',
            ),
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
            value: _civilStatus,
            decoration: editInputDecoration.copyWith(
              labelText: 'Civil Status',
            ),
            items: _civilStatusOptions.map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text('$c'),
              );
            }).toList(),
            onChanged: (val) => _civilStatus = val,
          ),
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0,),
            child: Text(
              'Birth date',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              DateTime _currentBirthDate;
              try {
                _currentBirthDate = DateTime.parse(DateFormat('yyyyMMdd')
                    .format(DateFormat('MM/dd/yyyy').parse(_birthDate)));
              } catch (e) {
                print(e);
                _currentBirthDate = DateTime.now();
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
                    fontWeight: FontWeight.normal,
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
                  // Map<String, String> params = {
                  //   'completeaddress' : address,
                  // };
                  // _editProfile(widget.token,).then((value) {
                  //   print('request ${value.reasonPhrase}');
                  //   http.Response.fromStream(value).then((response) {
                  //     print('save profile: ${response.body}');
                  //   });
                  // });
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
