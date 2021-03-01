import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/constants/utils.dart';
import '../../utils/helpers/navigation-helper.dart';


class EditOrganizationInfo extends StatefulWidget {
  @override
  _EditOrganizationInfoState createState() => _EditOrganizationInfoState();
}

class _EditOrganizationInfoState extends State<EditOrganizationInfo> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _statusOptions = [
    'Emergency Dispatch Operator',
    'Emergency Medical Service',
    'Firefighter',
    'Police Officer',
    'Military',
    'Quick Response',
    'Traffic Enforcer',
    'LGU Frontliner',
    'Volunteer',
    'Others'
  ];

  final List<String> _initialTags= [
    'EMS',
    'CPR',
  ];

  String _organization;
  String _status;
  String _website;
  String _address;
  String _skills;

  void _onAddressSelected(AddressLatLng aLL) {

  }

  @override
  void initState() {
    super.initState();
    _organization = 'Minglanilla Sample Org.';
    _status = 'Volunteer';
    _website = 'https://blahblahblah.minglanillasampleorg.com';
    _address = 'Abuno, Tunghaan, Minglanilla, Cebu';
    _skills = 'EMT, CPR';
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
              'Update Organization Information',
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
            initialValue: _organization,
            decoration: editInputDecoration.copyWith(
              hintText: 'Please input your organization name',
              labelText: 'Organization',
            ),
            // validator: (val) => val.isEmpty ? 'Please enter your code' : null,
            onChanged: (val) => _organization = val,
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
            value: _status ?? _statusOptions[0],
            decoration: editInputDecoration.copyWith(
              labelText: 'Status',
            ),
            items: _statusOptions.map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text('$c'),
              );
            }).toList(),
            onChanged: (val) => _status = val,
          ),
          SizedBox(
            height: 16.0,
          ),
          FlatButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              NavigationHelper.openSelectAddress(context, _onAddressSelected, LatLng(0.0, 0.0));
            },
            child: Container(
              width: double.infinity,
              height: 48.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _address ?? 'Organization Address',
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
            initialValue: _website,
            decoration: editInputDecoration.copyWith(labelText: 'Organization website'),
            // validator: (val) => val.isEmpty ? 'Please enter your code' : null,
            onChanged: (val) => _website = val,
            minLines: 1,
            maxLines: 2,
          ),
          SizedBox(
            height: 16.0,
          ),
          TextFieldTags(
            initialTags: List<String>.of(_initialTags),
            textFieldStyler: TextFieldStyler(
              textFieldFilled: true,
              textFieldFilledColor: Colors.white,
              // contentPadding: EdgeInsets.all(12.0),
              textFieldEnabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorPrimary, width: 2.0),
              ),
              textFieldFocusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorPrimary, width: 2.0),
              ),
            ),
            tagsStyler: TagsStyler(
              tagTextStyle: TextStyle(
                color: Colors.white,
              ),
              tagDecoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.circular(4.0),
              ),
              tagPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            ),
            onTag: (tag) {

            },
            onDelete: (tag) {

            },
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
