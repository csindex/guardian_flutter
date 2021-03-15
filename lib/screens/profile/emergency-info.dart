import 'package:flutter/material.dart';

import '../../utils/constants/utils.dart';

import 'edit-personal-info.dart';

class EmergencyInfo extends StatefulWidget {
  @override
  _EmergencyInfoState createState() => _EmergencyInfoState();
}

class _EmergencyInfoState extends State<EmergencyInfo> {
  @override
  Widget build(BuildContext context) {
    void _showModal() {
      // showModalBottomSheet(
      //   context: context,
      //   builder: (context) {
      //     return Container(
      //       padding: EdgeInsets.only(
      //           left: 16.0, top: 16.0, right: 16.0, bottom: 60.0),
      //       child: EditPersonalInfo(),
      //     );
      //   },
      // );
    }

    return Card(
      // color: colorPrimary,
      child: Container(
        // color: colorPrimary,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Emergency Information',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: colorPrimary,
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: _showModal,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  shape: CircleBorder(),
                  color: colorPrimary,
                ),
              ],
            ),
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => _emergencyInfoCorner(),
                itemCount: 1,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emergencyInfoCorner() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact Person',
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                'Gabii Garcia',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.grey,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                // '${widget.vm.name.substring(0, widget.vm.name.indexOf(' '))}*/\'s Bio',
                'Address',
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  // '${widget.userProfileVM.bio}',
                  'Abuno, Tunghaan, Minglanilla, Cebu',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.grey,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Contact Number',
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                '09123456789',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.grey,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Relationship',
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                'Best friend',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.grey,
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Blood Type',
                          style: TextStyle(
                            color: colorPrimary,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          'A+',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40.0,
                    width: 0.5,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Body Build',
                          style: TextStyle(
                            color: colorPrimary,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          'Large',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.grey,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Birth Mark',
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  '3 Moles on Chest',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.grey,
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Height',
                          style: TextStyle(
                            color: colorPrimary,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          '165 cm',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40.0,
                    width: 0.5,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Weight',
                          style: TextStyle(
                            color: colorPrimary,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          '73 KG',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40.0,
                    width: 0.5,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Insured',
                          style: TextStyle(
                            color: colorPrimary,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
