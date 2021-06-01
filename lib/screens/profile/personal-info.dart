import 'package:flutter/material.dart';

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';
import '../../widgets/ExpandableDropDownEducation.dart';
import '../../data/user/data-education.dart';

import 'edit-personal-info.dart';

class PersonalInfo extends StatefulWidget {
  final UserViewModel vm;
  final UserProfileViewModel userProfileVM;
  final String token;
  final UserProfileViewModel userOriginalVM;

  PersonalInfo({this.vm, this.userProfileVM, this.token, this.userOriginalVM});

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  @override
  Widget build(BuildContext context) {
    print('NAME: ${widget.vm.name}');
    void _showModal() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  left: 16.0, top: 16.0, right: 16.0, bottom: 60.0),
              child: EditPersonalInfo(
                userProfileVM: widget.userProfileVM,
                token: widget.token,
              ),
            ),
          );
        },
      );
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
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                    ),
                  ),
                ),
                Visibility(
                  visible: ((widget.userOriginalVM != null &&
                          widget.userOriginalVM.user.id ==
                              widget.userProfileVM.user.id) ||
                      (widget.userProfileVM == null ||
                          widget.userProfileVM.user.id == widget.vm.id)),
                  child: FlatButton(
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
                ),
              ],
            ),
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return (index == 0)
                      ? _personalInfoCorner()
                      : ExpandableDropDownEducation((widget.userProfileVM !=
                              null)
                          ? widget.userProfileVM.education ?? <EducationData>[]
                          : <EducationData>[]);
                },
                itemCount: 2,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _personalInfoCorner() => Padding(
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
                '${(widget.userProfileVM != null) ? widget.userProfileVM.user.name.substring(0, widget.userProfileVM.user.name.length) : widget.vm.name}\'s Bio',
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
                  (widget.userProfileVM != null)
                      ? widget.userProfileVM.bio ?? 'Nothing to show'
                      : 'Nothing to show',
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
                          'Gender',
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
                          (widget.userProfileVM != null)
                              ? widget.userProfileVM.gender
                              : 'N/A',
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
                          'Civil Status',
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
                          (widget.userProfileVM != null)
                              ? widget.userProfileVM.civilStatus
                              : 'N/A',
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
                'Birth date',
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
                (widget.userProfileVM != null)
                    ? widget.userProfileVM.birthDate
                    : 'N/A',
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
                'Home Address',
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
                  (widget.userProfileVM != null)
                      ? widget.userProfileVM.homeAddress
                      : 'N/A',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
