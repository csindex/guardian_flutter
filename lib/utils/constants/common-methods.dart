import 'dart:io';
import 'dart:async';

import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'utils.dart';
import '../../services/web-service.dart';
import '../../provider/user/viewmodel-user-profile.dart';


void launchURL(BuildContext context, String url) async {
  try {
    await launch(
      url,
      option: new CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: new CustomTabsAnimation(
          startEnter: 'slide_up',
          startExit: 'android:anim/fade_out',
          endEnter: 'android:anim/fade_in',
          endExit: 'slide_down',
        ),
        extraCustomTabs: <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

void showError(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(message),
      backgroundColor: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: [
        FlatButton(
          child: Text("Ok"),
          textColor: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

Future<http.StreamedResponse> _editProfile(
    String token, Map<String, String> params, String path) async {
  // print('path: ${_image.path} x ${File(_image.path).path.split('/').last}');
  Map<String, String> header = {
    'Content-Type': 'multipart/form-data;',
    'Connection': 'keep-alive',
    'Accept': '*/*',
    'x-auth-token': token,
  };
  var request = http.MultipartRequest(
      'POST', Uri.parse('$secretHollowsEndPoint/api/profile'));
  request.headers.addAll(header);
  if (path != 'nopic') {
    request.files.add(await http.MultipartFile.fromPath('profilepic', path));
  }
  request.fields.addAll(params);
  var res = await request.send();
  return res;
  // http.Response.fromStream(res).then((response) {
  //   print('result? $response x ${response.statusCode} x ${response.body}');
  //   return response;
  // });
}

Future<List<UserProfileViewModel>> fetchUsers() async {
  var result = await Webservice().fetchUsers();
  var userList = result.map((item) => UserProfileViewModel(userDetails: item)).toList();
  return userList;
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permantly denied, we '
        'cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }
  return await Geolocator.getCurrentPosition();
}

Future<List<GeocodingResult>> getAddress(LatLon coor) async {
  var _googleGeocoder = GoogleGeocoding(gMAK);
  var response = await _googleGeocoder.geocoding.getReverse(coor);
  return response.results;
  // if (response != null && results != null) {
  //   // print(results[0].addressComponents);
  //   // for (var r in results) {`
  //   //   print('r: ${r.types}');
  //   //   for (var c in r.addressComponents) {
  //   //     print('${c.longName} x ${c.types} x ${c.shortName}');
  //   //   }
  //   // }
  //   // var address = '';
  //   // var addressComponent = results[1].addressComponents[0];
  //   // if (addressComponent.types[0] == 'street_number') {
  //   //   address = '${addressComponent.longName},';
  //   //   addressComponent = results[1].addressComponents[1];
  //   // }
  //   // address = '$address ${addressComponent.longName},';
  //   // addressComponent = results[2].addressComponents[0];
  //   // address = '$address ${addressComponent.longName},';
  //   // address = '$address ${results[4].formattedAddress}';
  //   return results[0].formattedAddress;//address;
  // } else {
  //   return 'Sorry! Address not found!';
  // }
}

Future<File> file(String filename) async {
  Directory dir = await getExternalStorageDirectory();
  String pathName = p.join(dir.path, filename);
  return File(pathName);
}