import 'package:flutter/material.dart';

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';
import '../../widgets/ExpandableDropDownExperience.dart';
import '../../data/user/data-experience.dart';

import 'edit-organization-info.dart';

class OrganizationInfo extends StatefulWidget {
  final UserViewModel vm;
  final UserProfileViewModel userProfileVM;
  final UserProfileViewModel userOriginalVM;
  final String token;

  OrganizationInfo(
      {this.userProfileVM, this.vm, this.userOriginalVM, this.token});

  @override
  _OrganizationInfoState createState() => _OrganizationInfoState();
}

class _OrganizationInfoState extends State<OrganizationInfo> {
  @override
  Widget build(BuildContext context) {
    void _showModal() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  left: 16.0, top: 16.0, right: 16.0, bottom: 60.0),
              child: EditOrganizationInfo(),
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
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Organization Information',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: colorPrimary,
                      ),
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
                      ? _orgInfoCorner()
                      : ExpandableDropDownExperience(
                          (widget.userProfileVM != null)
                              ? widget.userProfileVM.experience ??
                                  <ExperienceData>[]
                              : <ExperienceData>[]);
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

  Widget _orgInfoCorner() => Padding(
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
                'Organization',
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
                '${(widget.userProfileVM != null) ? widget.userProfileVM.company ?? 'Nothing to show' : 'Nothing to show'}',
                // 'Minglanilla Sample Org.',
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
                'Status',
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
                '${(widget.userProfileVM != null) ? widget.userProfileVM.positionStatus ?? 'Nothing to show' : 'Nothing to show'}',
                // 'Volunteer',
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
                'Organization Address',
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
                  '${(widget.userProfileVM != null) ? widget.userProfileVM.location ?? 'Nothing to show' : 'Nothing to show'}',
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
                // '${widget.vm.name.substring(0, widget.vm.name.indexOf(' '))}*/\'s Bio',
                'Organization Website',
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
                  '${(widget.userProfileVM != null) ? widget.userProfileVM.website ?? 'Nothing to show' : 'Nothing to show'}',
                  // 'https://www.minglanillasampleorg.blahblahblah.com',
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
                // '${widget.vm.name.substring(0, widget.vm.name.indexOf(' '))}*/\'s Bio',
                'Skills',
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
                  '${(widget.userProfileVM != null) ? widget.userProfileVM.skills.toString().replaceAll('[', '✓ ').replaceAll(']', '').replaceAll(',', '    ✓') ?? 'Nothing to show' : 'Nothing to show'}',
                  // '✓ EMS  ✓ CPR',
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
