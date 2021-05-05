import 'dart:io';
import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';

class ID extends StatefulWidget {
  final UserViewModel vm;
  final UserProfileViewModel userProfileVM;
  final UserProfileViewModel userOriginalVM;

  ID({this.vm, this.userProfileVM, this.userOriginalVM});

  @override
  _IDState createState() => _IDState();

}

class _IDState extends State<ID> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  Future<File> _file(String filename) async {
    Directory dir = await getExternalStorageDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _file('defaultProfPic.png'),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        Widget w;
        if (snapshot.hasData) {
          w = Container(
            child: FlipCard(
              key: cardKey,
              // direction: _direction,
              front: Column(
                children: [
                  SizedBox(height: 36.0,),
                  GestureDetector(
                    onTap: () {
                      cardKey.currentState.toggleCard();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(112.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade900,
                            spreadRadius:1.0,
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 100.0,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 98.0,
                          backgroundColor: Colors.white,
                          backgroundImage: (widget.userProfileVM == null) ?
                          NetworkToFileImage(
                            url: '$secretHollowsEndPoint/img/Spotter.png',
                            file: snapshot.data,
                            debug: true,
                          ) :
                          (widget.userProfileVM.profilePic == null ||
                              widget.userProfileVM.profilePic.contains('null')) ?
                          NetworkToFileImage(
                            url: '$secretHollowsEndPoint/img/Spotter.png',
                            file: snapshot.data,
                            debug: true,
                          ) :
                          NetworkImage(widget.userProfileVM.profilePic),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Column(
                    children: [
                      Text(
                        'Tap photo to show QR Code',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: colorPrimary,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.red,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: Text(
                              'Valid Until: DEC 31, 2021',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        '${widget.userProfileVM.user.lname}, ${widget.userProfileVM.user.name}',
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        height: 1.0,
                        width: double.infinity,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        'Complete Name',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.green,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 24.0,
                            ),
                            child: Text(
                              'Authorized Person Outside Residence',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Text(
                        '${widget.userProfileVM.positionStatus}',
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        'at',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        '${widget.userProfileVM.company}',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xffafbfc6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${widget.userProfileVM.location}',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(
                                    'Operation Center',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 49.0,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/images/mandaue-seal.png'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              back: GestureDetector(
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
                    embeddedImage: AssetImage('assets/images/guardian.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(48.0, 48.0),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          w = Container(color: Colors.black,);
        } else {
          w = Container(color: Colors.red,);
        }
        return w;
      },
    );
  }

}