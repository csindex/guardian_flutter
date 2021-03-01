import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../widgets/ExpandableDropDownEducation.dart';
import '../../widgets/ExpandableDropDownExperience.dart';

class ProfileScreen extends StatefulWidget {
  final UserViewModel vm;
  final UserProfileViewModel userProfileVM;
  final String token;
  final Function() editProfilePicture;

  ProfileScreen(
      {this.vm, this.userProfileVM, this.token, this.editProfilePicture});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    // var box = Hive.box('user_db');
    // print('user: ${box.get('name')} X ${box.get('token')} X ${box.get('id')} X ${widget.userProfileVM.location}');
    // print('${widget.userProfileVM.profilePic} X ${widget.vm.avatar}');
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    var _direction = _flipDirectionRandomizer();
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: height / 2.4,
              width: double.infinity,
              color: colorPrimary,
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 48.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      FlipCard(
                        key: cardKey,
                        direction: _direction,
                        // flipOnTouch: false,
                        onFlipDone: ((_) {
                          setState(() {
                            _direction = _flipDirectionRandomizer();
                          });
                        }),
                        front: GestureDetector(
                          onTap: () {
                            _displayBottomSheet(context);
                            // NavigationHelper.openProfPicFull(context,
                            //     (widget.userProfileVM.profilePic == null
                            //         || widget.userProfileVM.profilePic
                            //             .contains('null'))
                            //     ? (widget.vm == null )
                            //     ? 'https://blog.radware.com/wp-content/uploads/2020/06/anonymous.jpg'
                            //     : widget.vm.avatar
                            //     : widget.userProfileVM.profilePic);
                          },
                          child: CircleAvatar(
                            radius: 80.0,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 79.0,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                (widget.userProfileVM.profilePic == null ||
                                        widget.userProfileVM.profilePic
                                            .contains('null'))
                                    ? (widget.vm == null)
                                        ? 'https://blog.radware.com/wp-content/'
                                            'uploads/2020/06/anonymous.jpg'
                                        : widget.vm.avatar
                                    : widget.userProfileVM.profilePic,
                              ),
                            ),
                          ),
                        ),
                        back: GestureDetector(
                          onTap: () {
                            // _displayBottomSheet(context);
                            NavigationHelper.openQRFull(context, widget.vm.id);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            height: 160.0,
                            width: 160.0,
                            child: QrImage(
                              data: widget.vm.id,
                              version: QrVersions.auto,
                              size: 160.0,
                              gapless: false,
                              embeddedImage:
                                  AssetImage('assets/images/guardian.png'),
                              embeddedImageStyle: QrEmbeddedImageStyle(
                                size: Size(48.0, 48.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4.0,
                        right: 4.0,
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // button color
                            child: InkWell(
                              splashColor:
                                  Colors.grey.shade300, // inkwell color
                              child: SizedBox(
                                width: 36.0,
                                height: 36.0,
                                child: Icon(
                                  Icons.flip,
                                  color: colorPrimary,
                                ),
                              ),
                              onTap: () {
                                cardKey.currentState.toggleCard();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      (widget.vm == null)
                          ? 'Unknown?'
                          : widget.userProfileVM.user.name,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.briefcase,
                        size: 16.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        (widget.userProfileVM == null)
                            ? 'Status: \'N/A\' at Company: \'N/A\''
                            : /*'${widget.userProfileVM.status} at */'${widget.userProfileVM.company}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidBuilding,
                        size: 16.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        (widget.userProfileVM == null)
                            ? 'Address : \'N/A\''
                            : widget.userProfileVM.location,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Center(
                    child: ClipOval(
                      child: Material(
                        color: colorPrimary,
                        child: InkWell(
                          onTap: () {},
                          child: SizedBox(
                            child: FaIcon(
                              FontAwesomeIcons.globe,
                              color: Colors.white,
                              size: 36.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return (index == 0)
                      ? _bioSkillsCorner()
                      : (index == 1)
                          ? ExpandableDropDownExperience(
                              widget.userProfileVM.experience)
                          : ExpandableDropDownEducation(
                              widget.userProfileVM.education);
                },
                itemCount: 3,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bioSkillsCorner() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey)),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.vm.name.substring(0, widget.vm.name.indexOf(' '))}\'s Bio',
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
                  '${widget.userProfileVM.bio}',
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
                'Skill Set',
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
                  '✓ ${widget.userProfileVM.skills.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(',', '    ✓')}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  FlipDirection _flipDirectionRandomizer() {
    var flag = Random().nextBool();
    print('flag - $flag');
    return (flag) ? FlipDirection.HORIZONTAL : FlipDirection.VERTICAL;
  }

  void _displayBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (ctx) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                splashColor: Colors.grey,
                onPressed: () {
                  Navigator.pop(ctx);
                  NavigationHelper.openProfPicFull(
                      ctx,
                      (widget.userProfileVM.profilePic == null ||
                              widget.userProfileVM.profilePic.contains('null'))
                          ? (widget.vm == null)
                              ? 'https://blog.radware.com/wp-content/uploads/2020/06/anonymous.jpg'
                              : widget.vm.avatar
                          : widget.userProfileVM.profilePic);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    'View Full Screen',
                  ),
                ),
              ),
              FlatButton(
                splashColor: Colors.grey,
                onPressed: () {
                  if (widget.userProfileVM == null || widget.userProfileVM.gender == null) {
                    print('No Profile');
                  } else {
                    print('unsa d i sulod? ${widget.userProfileVM} X ${widget.userProfileVM.gender}');
                    Navigator.pop(ctx);
                    NavigationHelper.openCameraScreen(ctx, widget.token, widget.userProfileVM);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    'Take a Photo',
                  ),
                ),
              ),
              FlatButton(
                splashColor: Colors.grey,
                onPressed: () {
                  if (widget.userProfileVM == null) {
                    print('No Profile');
                  } else {
                    Navigator.pop(context);
                    NavigationHelper.openGalleryScreen(ctx, widget.token, widget.userProfileVM);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    'Select a Photo',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
