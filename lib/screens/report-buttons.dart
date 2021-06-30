import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guardian_flutter/utils/helpers/navigation-helper.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../provider/user/viewmodel-user.dart';
import '../provider/user/viewmodel-user-profile.dart';
import '../utils/constants/utils.dart';

class ReportButtons extends StatefulWidget {
  final UserProfileViewModel userVM;
  final String token;
  final ValueChanged<String> onReport;
  // final Function refresh;

  ReportButtons({
    this.userVM, this.token, this.onReport});

  @override
  _ReportButtonsState createState() => _ReportButtonsState();
}

class _ReportButtonsState extends State<ReportButtons> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/ic_firetruck.png',
                          height: 128.0,
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'FIRE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    widget.onReport('Fire');
                    Navigator.pop(context);
                  },
                  //onPressed: null, //Uncomment this statement to check disabled state.
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      } else if (states.contains(MaterialState.pressed)) {
                        return colorPrimary;
                      } else {
                        return colorPrimary;
                      }
                    }),
                    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.redAccent;
                      }
                      return Colors.transparent;
                    }),
                    side: MaterialStateProperty.resolveWith((states) {
                      Color _borderColor;
                      if (states.contains(MaterialState.disabled)) {
                        _borderColor = Colors.grey;
                      } else if (states.contains(MaterialState.pressed)) {
                        _borderColor = Colors.redAccent;
                      } else {
                        _borderColor = Colors.white;
                      }
                      return BorderSide(color: _borderColor, width: 2);
                    }),
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                      return RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0)));
                    }),
                  ),
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              Expanded(
                child: OutlinedButton(
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/ic_ambulance.png',
                          height: 128.0,
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'MEDICAL',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    widget.onReport('Medical');
                    Navigator.pop(context);
                  },
                  //onPressed: null, //Uncomment this statement to check disabled state.
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      } else if (states.contains(MaterialState.pressed)) {
                        return colorPrimary;
                      } else {
                        return colorPrimary;
                      }
                    }),
                    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blueAccent;
                      }
                      return Colors.transparent;
                    }),
                    side: MaterialStateProperty.resolveWith((states) {
                      Color _borderColor;
                      if (states.contains(MaterialState.disabled)) {
                        _borderColor = Colors.grey;
                      } else if (states.contains(MaterialState.pressed)) {
                        _borderColor = Colors.blueAccent;
                      } else {
                        _borderColor = Colors.white;
                      }
                      return BorderSide(color: _borderColor, width: 2);
                    }),
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                      return RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(16.0)));
                    }),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.0,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/ic_police.png',
                          height: 128.0,
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'CRIME',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    widget.onReport('Crime');
                    Navigator.pop(context);
                  },
                  //onPressed: null, //Uncomment this statement to check disabled state.
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      } else if (states.contains(MaterialState.pressed)) {
                        return colorPrimary;
                      } else {
                        return colorPrimary;
                      }
                    }),
                    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black;
                      }
                      return Colors.transparent;
                    }),
                    side: MaterialStateProperty.resolveWith((states) {
                      Color _borderColor;
                      if (states.contains(MaterialState.disabled)) {
                        _borderColor = Colors.grey;
                      } else if (states.contains(MaterialState.pressed)) {
                        _borderColor = Colors.black;
                      } else {
                        _borderColor = Colors.white;
                      }
                      return BorderSide(color: _borderColor, width: 2);
                    }),
                    // shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                    //   return RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(16.0)));
                    // }),
                  ),
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              Expanded(
                child: OutlinedButton(
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/ic_telephone.png',
                          height: 128.0,
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'GENERAL',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    widget.onReport('General');
                    Navigator.pop(context);
                  },
                  //onPressed: null, //Uncomment this statement to check disabled state.
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      } else if (states.contains(MaterialState.pressed)) {
                        return colorPrimary;
                      } else {
                        return colorPrimary;
                      }
                    }),
                    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.green.shade800;
                      }
                      return Colors.transparent;
                    }),
                    side: MaterialStateProperty.resolveWith((states) {
                      Color _borderColor;
                      if (states.contains(MaterialState.disabled)) {
                        _borderColor = Colors.grey;
                      } else if (states.contains(MaterialState.pressed)) {
                        _borderColor = Colors.green.shade800;
                      } else {
                        _borderColor = Colors.white;
                      }
                      return BorderSide(color: _borderColor, width: 2);
                    }),
                    // shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                    //   return RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(16.0)));
                    // }),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.0,
          ),
          Container(
            child: OutlinedButton(
              child: SizedBox(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/ic_corona_virus.png',
                        height: 72.0,
                        width: 72.0,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        width: 24.0,
                      ),
                      Text(
                        'CoVid-19',
                        style: TextStyle(
                          fontSize: 36.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onPressed: () {
                widget.onReport('Covid');
                Navigator.pop(context);
              },
              //onPressed: null, //Uncomment this statement to check disabled state.
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  } else if (states.contains(MaterialState.pressed)) {
                    return colorPrimary;
                  } else {
                    return colorPrimary;
                  }
                }),
                overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Color(0xFF800000);
                  }
                  return Colors.transparent;
                }),
                side: MaterialStateProperty.resolveWith((states) {
                  Color _borderColor;
                  if (states.contains(MaterialState.disabled)) {
                    _borderColor = Colors.grey;
                  } else if (states.contains(MaterialState.pressed)) {
                    _borderColor = Color(0xFF800000);
                  } else {
                    _borderColor = Colors.white;
                  }
                  return BorderSide(color: _borderColor, width: 2);
                }),
                shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                  );
                }),
              ),
            )/*ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0),),
              child: Material( // button color
                color: colorPrimary.withOpacity(0.6),
                child: InkWell(
                  splashColor: colorPrimary, // inkwell color
                  child: SizedBox(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/ic_corona_virus.png',
                            height: 72.0,
                            width: 72.0,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: 24.0,
                          ),
                          Text(
                            'CoVid-19',
                            style: TextStyle(
                              fontSize: 36.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    // TODO: COVID button
                  },
                ),
              ),
            )*/,
          ),
        ],
      ),
    );
  }
}
/*
*
c
d
a
a
a
d
a
d
c
c

t
t
t
f
t
t
t
f
t
t

f
g
h
i
c
d
a
j
b
e
* */