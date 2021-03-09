import 'dart:math';
import 'dart:io';
import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../utils/constants/utils.dart';

class ProfileHeader extends StatelessWidget {
  final UserViewModel vm;
  final UserProfileViewModel userProfileVM;
  final String token;
  final UserProfileViewModel userOriginalVM;

  ProfileHeader({this.vm, this.userProfileVM, this.token, this.userOriginalVM});

  FlipDirection _flipDirectionRandomizer() =>
      (Random().nextBool()) ? FlipDirection.HORIZONTAL : FlipDirection.VERTICAL;

  Future<File> _file(String filename) async {
    Directory dir = await getExternalStorageDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

    // var myFile = _file('defaultProfPic.png');

    var _direction;
    void _displayBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  splashColor: Colors.grey,
                  onPressed: () {
                    Navigator.pop(context);
                    NavigationHelper.openProfPicFull(
                        context,
                        (userProfileVM == null)
                            ? 'https://drive.google.com/uc?export=view&id=0BzgvL4WSy8RwZDhTMGo3LVA0akE'
                            : (userProfileVM.profilePic == null ||
                                    userProfileVM.profilePic.contains('null'))
                                ? 'https://drive.google.com/uc?export=view&id=0BzgvL4WSy8RwZDhTMGo3LVA0akE'
                                : userProfileVM.profilePic);
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
                    if (userProfileVM == null || userProfileVM.gender == null) {
                      print('No Profile');
                    } else {
                      print('unsa d i sulod? ${userProfileVM} X ${userProfileVM.gender}');
                      Navigator.pop(context);
                      NavigationHelper.openCameraScreen(context, token, userProfileVM);
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
                    if (userProfileVM == null || userProfileVM.gender == null) {
                      print('No Profile');
                    } else {
                      print('unsa d i sulod? ${userProfileVM} X ${userProfileVM.gender}');
                      Navigator.pop(context);
                      NavigationHelper.openGalleryScreen(context, token, userProfileVM);
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

    _direction = _flipDirectionRandomizer();
    return /*(userProfileVM.user.id == userOriginalVM.user.id) ?
    (userOriginalVM.profilePic != null || userOriginalVM.profilePic != '') ?*/
    FutureBuilder<File>(
      future: _file('defaultProfPic.png'),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        Widget w;
        if (snapshot.hasData) {
          print('Ikaw pala ${snapshot.data}');
          w = Container(
            padding: EdgeInsets.all(16.0),
            color: colorPrimary,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 36.0),
                (userProfileVM.user.id == userOriginalVM.user.id) ?
                Stack(
                  children: [
                    FlipCard(
                      key: cardKey,
                      direction: _direction,
                      front: GestureDetector(
                        onTap: _displayBottomSheet,
                        child: CircleAvatar(
                          radius: 80.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 79.0,
                            backgroundColor: Colors.white,
                            backgroundImage: (userProfileVM == null) ?
                            NetworkToFileImage(
                              url: '$secretHollowsEndPoint/img/Spotter.png',
                              file: snapshot.data,
                              debug: true,
                            ) :
                            (userProfileVM.profilePic == null ||
                                userProfileVM.profilePic.contains('null')) ?
                            NetworkToFileImage(
                              url: '$secretHollowsEndPoint/img/Spotter.png',
                              file: snapshot.data,
                              debug: true,
                            ) :
                            NetworkImage(userProfileVM.profilePic),
                          ),
                        ),
                      ),
                      back: GestureDetector(
                        onTap: () {
                          NavigationHelper.openQRFull(context, vm.id);
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
                            data: vm.id,
                            version: QrVersions.auto,
                            size: 160.0,
                            gapless: false,
                            embeddedImage: AssetImage('assets/images/guardian.png'),
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
                            splashColor: Colors.grey.shade300, // inkwell color
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
                ) :
                GestureDetector(
                  onTap: () {
                    NavigationHelper.openProfPicFull(
                      context,
                      (userProfileVM == null) ?
                      'https://drive.google.com/uc?export=view&id=0BzgvL4WSy8RwZDhTMGo3LVA0akE' :
                      (userProfileVM.profilePic == null ||
                          userProfileVM.profilePic.contains('null')) ?
                      'https://drive.google.com/uc?export=view&id=0BzgvL4WSy8RwZDhTMGo3LVA0akE' :
                      userProfileVM.profilePic,
                    );
                  },
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 79.0,
                      backgroundColor: Colors.white,
                      backgroundImage: (userProfileVM == null) ?
                      NetworkToFileImage(
                        url: '$secretHollowsEndPoint/img/Spotter.png',
                        file: snapshot.data,
                        debug: true,
                      ) :
                      (userProfileVM.profilePic == null ||
                          userProfileVM.profilePic.contains('null')) ?
                      NetworkToFileImage(
                        url: '$secretHollowsEndPoint/img/Spotter.png',
                        file: snapshot.data,
                        debug: true,
                      ) :
                      NetworkImage(userProfileVM.profilePic),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    (userProfileVM == null) ?
                    (vm == null) ?
                    'Unknown?' :
                    vm.name :
                    '${userProfileVM.user.name} ${userProfileVM.user.lname}',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          w = Container(color: Colors.black,);
        } else {
          w = Container(color: Colors.red,);
        }
        return w;
      },
    )/* :
    _body :
    _body*/;
  }

  /*Widget get body => Container(
    padding: EdgeInsets.all(16.0),
    color: colorPrimary,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 36.0),
        (userProfileVM.user.id == userOriginalVM.user.id) ?
        Stack(
          children: [
            FlipCard(
              key: cardKey,
              direction: _direction,
              front: GestureDetector(
                onTap: _displayBottomSheet,
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 79.0,
                    backgroundColor: Colors.white,
                    backgroundImage: (userProfileVM == null) ?
                    NetworkToFileImage(
                      url: '$secretHollowsEndPoint/img/Spotter.png',
                      file: snapshot.data,
                      debug: true,
                    ) :
                    (userProfileVM.profilePic == null ||
                        userProfileVM.profilePic.contains('null')) ?
                    NetworkToFileImage(
                      url: '$secretHollowsEndPoint/img/Spotter.png',
                      file: snapshot.data,
                      debug: true,
                    ) :
                    NetworkImage(userProfileVM.profilePic),
                  ),
                ),
              ),
              back: GestureDetector(
                onTap: () {
                  NavigationHelper.openQRFull(context, vm.id);
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
                    data: vm.id,
                    version: QrVersions.auto,
                    size: 160.0,
                    gapless: false,
                    embeddedImage: AssetImage('assets/images/guardian.png'),
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
                    splashColor: Colors.grey.shade300, // inkwell color
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
        ) :
        GestureDetector(
          onTap: () {
            NavigationHelper.openProfPicFull(
              context,
              (userProfileVM == null) ?
              'https://drive.google.com/uc?export=view&id=0BzgvL4WSy8RwZDhTMGo3LVA0akE' :
              (userProfileVM.profilePic == null ||
                  userProfileVM.profilePic.contains('null')) ?
              'https://drive.google.com/uc?export=view&id=0BzgvL4WSy8RwZDhTMGo3LVA0akE' :
              userProfileVM.profilePic,
            );
          },
          child: CircleAvatar(
            radius: 80.0,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 79.0,
              backgroundColor: Colors.white,
              backgroundImage: (userProfileVM == null) ?
              NetworkToFileImage(
                url: '$secretHollowsEndPoint/img/Spotter.png',
                file: snapshot.data,
                debug: true,
              ) :
              (userProfileVM.profilePic == null ||
                  userProfileVM.profilePic.contains('null')) ?
              NetworkToFileImage(
                url: '$secretHollowsEndPoint/img/Spotter.png',
                file: snapshot.data,
                debug: true,
              ) :
              NetworkImage(userProfileVM.profilePic),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            (userProfileVM == null) ?
            (vm == null) ?
            'Unknown?' :
            vm.name :
            '${userProfileVM.user.name} ${userProfileVM.user.lname}',
            maxLines: 2,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );*/
}
