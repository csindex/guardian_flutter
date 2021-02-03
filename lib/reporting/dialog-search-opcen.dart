import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constants/utils.dart';
import '../utils/helpers/navigation-helper.dart';

// ignore: must_be_immutable
class SearchOpcenDialog extends StatefulWidget {
  String _location;
  String _type;

  SearchOpcenDialog(this._location, this._type);

  @override
  _SearchOpcenDialogState createState() =>
      _SearchOpcenDialogState(_location, _type.toLowerCase());
}

class _SearchOpcenDialogState extends State<SearchOpcenDialog> {
  String _status = 'Searching';
  String _opcen = 'Nearest Operation Center';
  String _type;
  String _location;

  _SearchOpcenDialogState(this._location, this._type);

  @override
  void initState() {
    super.initState();

    _mockCheckForSession(3000).then((value) {
      setState(() {
        _status = 'Found';
        _opcen = 'Bantay Mandaue Command Center';
      });
      _mockCheckForSession(1000).then((value) {
        setState(() {
          _status = 'Connecting';
        });
        _mockCheckForSession(1500).then((value) {
          setState(() {
            _status = 'Acknowledge';
          });
          Navigator.pop(context);
          NavigationHelper.navigateToCall(context);
        });
      });
    });
  }

  Future<void> _mockCheckForSession(int duration) async {
    await Future.delayed(Duration(milliseconds: duration), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(context) => Container(
        padding: EdgeInsets.all(32.0),
        width: 354.0,
        height: 406.0,
        decoration: BoxDecoration(
            color: dialogColor, borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55.0,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: _getReportType(),
              ),
              backgroundColor: Colors.white,
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/map-pin.svg',
                  height: 24.0,
                  width: 24.0,
                  color: colorPrimary,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  _location,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              _status,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Text(
              _opcen,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                letterSpacing: 1.3,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Container(
              width: 56.0,
              height: 56.0,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );

  Widget _getReportType() {
    switch (_type) {
      case 'fire':
        return Image.asset(
          'assets/images/ic_fire_full.png',
          fit: BoxFit.contain,
        );
        break;
      case 'medical':
        return Image.asset(
          'assets/images/ic_medical_full.png',
          fit: BoxFit.contain,
        );
        break;
      case 'crime':
        return Image.asset(
          'assets/images/ic_crime_full.png',
          fit: BoxFit.contain,
        );
        break;
      case 'general':
        return Image.asset(
          'assets/images/ic_general_full.png',
          fit: BoxFit.contain,
        );
        break;
      default:
        return Container();
        break;
    }
  }
}
