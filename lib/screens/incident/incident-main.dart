import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guardian_flutter/utils/helpers/navigation-helper.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';

class IncidentMain extends StatefulWidget {
  final UserProfileViewModel userVM;
  final String token;
  // final Function refresh;

  IncidentMain({
    this.userVM, this.token});

  @override
  _IncidentMainState createState() => _IncidentMainState();
}

class _IncidentMainState extends State<IncidentMain> {

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
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0)),
                  child: Material( // button color
                    color: colorPrimary.withOpacity(0.6),
                    child: InkWell(
                      splashColor: colorPrimary, // inkwell color
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
                      onTap: () {
                        // TODO: FIRE button
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(16.0)),
                  child: Material( // button color
                    color: colorPrimary.withOpacity(0.6),
                    child: InkWell(
                      splashColor: colorPrimary, // inkwell color
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      onTap: () {
                        // TODO: MEDICAL button
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0)),
                  child: Material( // button color
                    color: colorPrimary.withOpacity(0.6),
                    child: InkWell(
                      splashColor: colorPrimary, // inkwell color
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      onTap: () {
                        // TODO: CRIME button
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(16.0)),
                  child: Material( // button color
                    color: colorPrimary.withOpacity(0.6),
                    child: InkWell(
                      splashColor: colorPrimary, // inkwell color
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      onTap: () {
                        // TODO: GENERAL button
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
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Material( // button color
                color: colorPrimary.withOpacity(0.6),
                child: InkWell(
                  splashColor: colorPrimary, // inkwell color
                  child: SizedBox(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/images/ic_corona_virus.png',
                            height: 72.0,
                            width: 72.0,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            'Coronavirus',
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
            ),
          ),
        ],
      ),
    );
  }
}
