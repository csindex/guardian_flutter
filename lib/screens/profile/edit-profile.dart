import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';

import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';
import '../../utils/loading.dart';

class EditProfile extends StatefulWidget {
  final String token;
  final UserProfileViewModel userVM;
  final Function refresh;
  final bool isUpdate;

  EditProfile({
    Key key,
    this.token,
    this.userVM,
    this.refresh,
    this.isUpdate
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin<EditProfile>{

  final _formPageKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isExpandedPInfo = false;

  // Future<String> addEducation() async {
  //   print('$_school - $_degree - $_field - $_dateFrom - $_isCurrent - $_dateTo - $_desc');
  //   final url = "$secretHollowsEndPoint/api/profile/education";
  //   Map data = {
  //     'school' : _school,
  //     'degree' : _degree,
  //     'fieldofstudy' : _field,
  //     'from' : _dateFrom,
  //     'to' : _dateTo,
  //     'current' : '$_isCurrent',
  //     'description' : _desc,
  //   };
  //   print('data - $data');
  //   var reqBody = jsonEncode(data);
  //   final response = await http.put(
  //     url,
  //     headers: {
  //       'Cache-Control' : 'no-cache',
  //       'Accept' : '*/*',
  //       'Accept-Encoding' : 'gzip, deflate, br',
  //       'Connection' : 'keep-alive',
  //       'Content-Type': 'application/json',
  //       'x-auth-token': widget.token,
  //     },
  //     body: reqBody,
  //   );
  //   print('add education - ${response.body}');
  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     return 'failed';
  //   }
  // }

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'LGBT',
  ];

  final List<String> _civilStatusOptions = [
    'Single',
    'Married',
    'Widowed',
    'Separated',
  ];

  String _bio;
  String _gender;
  String _civilStatus;
  String _birthDate;
  String _homeAddress;
  double _lat = 0.0;
  double _lng = 0.0;

  GoogleMapController _mapController;
  LatLng _defaultLL = LatLng(0.0, 0.0);
  LatLng _acquiredLL;
  LatLng _selectedLL;
  final Map<String, Marker> _markers = {};
  String address;
  double lat, lng;
  GoogleGeocoding _googleGeocoder;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.setMapStyle('[{"elementType": "geometry",'
        '"stylers": [{"color": "#1d2c4d"}]},'
        '{"elementType":"labels.text.fill","stylers": [{"color": "#8ec3b9"}]},'
        '{"elementType": "labels.text.stroke",'
        '"stylers": [{"color": "#1a3646"}]},'
        '{"featureType": "administrative.country",'
        '"elementType": "geometry.stroke","stylers": [{"color": "#4b6878"}]},'
        '{"featureType": "administrative.land_parcel",'
        '"elementType": "labels.text.fill","stylers": [{"color": "#64779e"}]},'
        '{"featureType": "administrative.province",'
        '"elementType": "geometry.stroke","stylers": [{"color": "#4b6878"}]},'
        '{"featureType": "landscape.man_made",'
        '"elementType": "geometry.stroke","stylers": [{"color": "#334e87"}]},'
        '{"featureType": "landscape.natural",'
        '"elementType": "geometry","stylers": [{"color": "#023e58"}]},'
        '{"featureType":"poi","elementType": "geometry",'
        '"stylers": [{"color": "#283d6a"}]},{"featureType": "poi",'
        '"elementType": "labels.text.fill","stylers": [{"color": "#6f9ba5"}]},'
        '{"featureType": "poi","elementType": "labels.text.stroke",'
        '"stylers": [{"color": "#1d2c4d"}]},{"featureType": "poi.park",'
        '"elementType": "geometry.fill","stylers": [{"color": "#023e58"}]},'
        '{"featureType": "poi.park","elementType": "labels.text.fill",'
        '"stylers": [{"color": "#3C7680"}]},{"featureType": "road",'
        '"elementType": "geometry","stylers": [{"color": "#304a7d"}]},'
        '{"featureType": "road","elementType": "labels.text.fill",'
        '"stylers": [{"color": "#98a5be"}]},{"featureType": "road",'
        '"elementType": "labels.text.stroke","stylers": [{"color": "#1d2c4d"}]},'
        '{"featureType": "road.highway",'
        '"elementType": "geometry","stylers": [{"color": "#2c6675"}]},'
        '{"featureType": "road.highway","elementType": "geometry.stroke",'
        '"stylers": [{"color": "#255763"}]},{"featureType": "road.highway",'
        '"elementType": "labels.text.fill","stylers": [{"color": "#b0d5ce"}]},'
        '{"featureType": "road.highway","elementType": "labels.text.stroke",'
        '"stylers": [{"color": "#023e58"}]},{"featureType": "transit",'
        '"elementType": "labels.text.fill","stylers": [{"color": "#98a5be"}]},'
        '{"featureType": "transit","elementType": "labels.text.stroke",'
        '"stylers": [{"color": "#1d2c4d"}]},{"featureType": "transit.line",'
        '"elementType": "geometry.fill","stylers": [{"color": "#283d6a"}]},'
        '{"featureType": "transit.station","elementType": "geometry",'
        '"stylers": [{"color": "#3a4762"}]},{"featureType": "water",'
        '"elementType": "geometry","stylers": [{"color": "#0e1626"}]},'
        '{"featureType": "water","elementType": "labels.text.fill",'
        '"stylers": [{"color": "#4e6d70"}]}]');
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
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

  Future<String> _getAddress(LatLon coor) async {
    var response = await _googleGeocoder.geocoding.getReverse(coor);
    var results = response.results;
    if (response != null && results != null) {
      // print(results[0].formattedAddress);
      // var address = '';
      // var addressComponent = results[1].addressComponents[0];
      // if (addressComponent.types[0] == 'street_number') {
      //   address = '${addressComponent.longName},';
      //   addressComponent = results[1].addressComponents[1];
      // }
      // address = '$address ${addressComponent.longName},';
      // addressComponent = results[2].addressComponents[0];
      // address = '$address ${addressComponent.longName},';
      // address = '$address ${results[4].formattedAddress}';
      return results[0].formattedAddress;//address;
    } else {
      return 'Sorry! Address not found!';
    }
  }

  Future<void> _addMarker(LatLng latlng) {
    lat = latlng.latitude;
    lng = latlng.longitude;
    _getAddress(LatLon(lat, lng)).then((value) {
      print('address($lat, $lng)');
      final MarkerId markerId = MarkerId('selectedLocation');
      setState(() {
        // creating a new MARKER
        final Marker marker = Marker(
          markerId: markerId,
          position: latlng,
          draggable: true,
          infoWindow: InfoWindow(title: 'Selected Address', snippet: value),
          onTap: () {
            // _onMarkerTapped(markerId);
          },
          onDragEnd: _addMarker,
        );
        _markers.clear();
        _markers['selectedLocation'] = marker;
        address = value;
        try {
          _mapController.hideMarkerInfoWindow(_markers['selectedLocation'].markerId);
        } catch (e) {
          print('No marker displayed currently.');
        }
        _mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: latlng, zoom: 16.0)));
        try {
          _mapController.showMarkerInfoWindow(_markers['selectedLocation'].markerId);
        } catch (e) {
          print('exception $e X ${_markers.length} x $_markers}');
        }
      });
    });
    return Future.value();
  }

  Future<File> _file(String filename) async {
    Directory dir = await getExternalStorageDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
  }

  @override
  void initState() {
    super.initState();
    _googleGeocoder = GoogleGeocoding(gMAK);
    if (widget.userVM == null || widget.userVM.lat == null) {
      _determinePosition().then((value) {
        var lat = value.latitude;
        var lng = value.longitude;
        _acquiredLL = LatLng(lat, lng);
        _addMarker(_acquiredLL);
      });
    } else {
      _addMarker(LatLng(widget.userVM.lat, widget.userVM.lng));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 16.0,),
                  ),
                  onPressed: () {
                    // if (userProfileVM == null || userProfileVM.gender == null) {
                    //   print('No Profile');
                    // } else {
                    //   print('unsa d i sulod? $userProfileVM X ${userProfileVM.gender}');
                    //   Navigator.pop(context);
                    //   NavigationHelper.openCameraScreen(context, token, userProfileVM);
                    // }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.camera,
                        size: 16.0,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Take a Photo',
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 16.0,),
                  ),
                  onPressed: () {
                    // if (userProfileVM == null || userProfileVM.gender == null) {
                    //   print('No Profile');
                    // } else {
                    //   print('unsa d i sulod? $userProfileVM X ${userProfileVM.gender}');
                    //   Navigator.pop(context);
                    //   NavigationHelper.openCameraScreen(context, token, userProfileVM);
                    // }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidImage,
                        size: 16.0,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Select a Photo',
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return _isLoading ? Loading() : (widget.userVM == null
        || widget.userVM.profilePic == null
        || widget.userVM.profilePic.contains('null')) ? FutureBuilder<File>(
      future: _file('defaultProfPic.png'),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        Widget w;
        if (snapshot.hasData) {
          print('Ikaw pala ${snapshot.data}');
          w = Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: SafeArea(
              child: Form(
                key: _formPageKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            '${(widget.isUpdate ? 'Update' : 'Create')} Your Profile',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: colorPrimary,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        _header,
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          '* = required field',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: _displayBottomSheet,
                                child: CircleAvatar(
                                  radius: 80.0,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 79.0,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkToFileImage(
                                      url: '$secretHollowsEndPoint/img/Spotter.png',
                                      file: snapshot.data,
                                      debug: true,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8.0,
                                right: 8.0,
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.transparent, // button color
                                    child: InkWell(
                                      splashColor: Colors.grey.shade500, // inkwell color
                                      child: SizedBox(
                                        width: 36.0,
                                        height: 36.0,
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          color: colorPrimary,
                                        ),
                                      ),
                                      onTap: _displayBottomSheet,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        _expandablePersonalInfo,
                      ],
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
    ) : Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Form(
          key: _formPageKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      '${(widget.isUpdate ? 'Update' : 'Create')} Your Profile',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: colorPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  _header,
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    '* = required field',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _header
  => Row(
    children: [
      FaIcon(
        FontAwesomeIcons.solidUser,
        size: 16.0,
        color: Colors.black,
      ),
      SizedBox(
        width: 8.0,
      ),
      Flexible(
        child: Text(
          '${(widget.isUpdate ? 'Update' : 'Let\'s get some')} '
              'information to make your profile stand out.',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    ],
  );

  Widget get _expandablePersonalInfo
  => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () => setState(() {
          if (_mapController != null) {
            if (!_isExpandedPInfo) {
              if (_selectedLL == null) {
                if (_acquiredLL != null) {
                  _mapController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: _acquiredLL, zoom: 16.0)));
                }
              } else {
                _mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: _selectedLL, zoom: 16.0)));
              }
            }
          }
          _isExpandedPInfo = !_isExpandedPInfo;
        }),
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FaIcon(
                FontAwesomeIcons.solidAddressBook,
                size: 16.0,
                color: colorPrimary,
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '* Personal Information',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: colorPrimary,
                    ),
                  ),
                ),
              ),
              FaIcon(
                (_isExpandedPInfo)
                    ? FontAwesomeIcons.angleUp
                    : FontAwesomeIcons.angleDown,
                color: colorPrimary,
                // size: 16.0,
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 4.0,
      ),
      AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 350),
        child: ConstrainedBox(
          constraints: _isExpandedPInfo
              ? BoxConstraints()
              : BoxConstraints(maxHeight: 0.0),
          child: Container(
            width: double.infinity,
            height: 256.0,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              trafficEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(0.0, 0.0),// TODO: change to initialLL
              ),
              markers: Set<Marker>.of(_markers.values),
            ),
          ),
        ),
      ),
    ],
  );
}
