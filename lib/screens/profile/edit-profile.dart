import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guardian_flutter/data/user/data-user-details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:address_search_field/address_search_field.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart' as gmws;
import 'package:popup_menu/popup_menu.dart';

import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../../utils/helpers/navigation-helper.dart';

class EditProfile extends StatefulWidget {
  final String token;
  final UserProfileViewModel userVM;
  final Function refresh;
  final bool isUpdate;

  EditProfile({Key key, this.token, this.userVM, this.refresh, this.isUpdate})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin<EditProfile> {
  final _formPageKey = GlobalKey<FormState>();

  gmws.GoogleMapsPlaces _places = gmws.GoogleMapsPlaces(apiKey: gMAK);

  Offset o;

  final geoMethods = GeoMethods(
    googleApiKey: gMAK,
    language: 'en',
    countryCode: 'ph',
    countryCodes: ['ph'],
    country: 'Philippines',
    city: 'Cebu',
  );

  // bool _isLoading = false;
  bool _isExpandedPInfo = false;
  bool _isExpandedOInfo = false;
  bool _isExpandedEInfo = false;
  bool _isExpandedSNInfo = false;

  final picker = ImagePicker();
  File _imageFile;
  String _imagePath;

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

  String _homeAddress = '';
  String _gender;
  String _civilStatus;
  String _birthDate;
  String _bio = '';
  double _lat = 0.0;
  double _lng = 0.0;
  String _city = '';
  String _state = '';
  String _area = '';

  String _nHomeAddress = '';
  String _nGender = '';
  String _nCivilStatus = '';
  String _nBirthDate = '';
  String _nBio = '';
  double _nLat = 0.0;
  double _nLng = 0.0;
  String _nCity = '';
  String _nState = '';
  String _nArea = '';

  bool _errPInfo = false;
  String _errHomeAdd, _errGender, _errCivilStatus, _errBio;
  bool _isBDayError = false;

  GoogleMapController _mapController;
  LatLng _defaultLL = LatLng(0.0, 0.0);
  LatLng _acquiredLL;
  LatLng _selectedLL;
  final Map<String, Marker> _markers = {};
  double lat, lng;
  GoogleGeocoding _googleGeocoder;

  TextEditingController _homeAddressController;
  TextEditingController _bioController;
  TextEditingController _searchAddressController;

  final List<RespStatus> _respStatusOptions = [
    RespStatus(v: 'Dispatch', txt: 'Emergency Dispatch Operator'),
    RespStatus(v: 'EMS', txt: 'Emergency Medical Service'),
    RespStatus(v: 'Fireman', txt: 'Firefighter'),
    RespStatus(v: 'Policeman', txt: 'Police Officer'),
    RespStatus(v: 'Military', txt: 'Military'),
    RespStatus(v: 'QRT', txt: 'Quick Response'),
    RespStatus(v: 'Traffic Dept.', txt: 'Traffic Enforcer'),
    RespStatus(v: 'LGU Frontliner', txt: 'LGU Frontliner'),
    RespStatus(v: 'Volunteer', txt: 'Volunteer'),
    RespStatus(v: 'Others', txt: 'Others'),
  ];

  String _responderStatus;
  String _org = '';
  String _website = '';
  String _orgAddress = '';
  String _skills = '';

  String _nResponderStatus = '';
  String _nOrg = '';
  String _nWebsite = '';
  String _nOrgAddress = '';
  String _nSkills = '';

  bool _errOInfo = false;
  String _errRespStatus, _errOrg, _errWebsite, _errOrgAddress, _errSkills;

  TextEditingController _organizationController;
  TextEditingController _websiteController;
  TextEditingController _orgAddressController;
  TextEditingController _skillsController;

  final List<String> _insuranceOptions = [
    'Yes',
    'No',
  ];

  final List<String> _bloodTypeOptions = [
    'A-',
    'A+',
    'B-',
    'B+',
    'AB-',
    'AB+',
    'O-',
    'O+',
  ];

  String _contactPerson;
  String _relationship;
  String _contactNumber;
  String _contactAddress;
  String _bloodType;
  String _isInsured;

  TextEditingController _contactPersonController;
  TextEditingController _relationshipController;
  TextEditingController _contactNumberController;
  TextEditingController _contactAddressController;

  String _twUrl;
  String _fbUrl;
  String _ytUrl;
  String _inUrl;
  String _igUrl;

  TextEditingController _twUrlController;
  TextEditingController _fbUrlController;
  TextEditingController _ytUrlController;
  TextEditingController _inUrlController;
  TextEditingController _igUrlController;

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
      return results[0].formattedAddress; //address;
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
          // infoWindow: InfoWindow(title: 'Selected Address', snippet: value),
          // onTap: () {
          // _onMarkerTapped(markerId);
          // },
          onDragEnd: _addMarker,
        );
        _markers.clear();
        _markers['selectedLocation'] = marker;
        if (value != _homeAddress) {
          _nHomeAddress = value;
        } else {
          _nHomeAddress = '';
        }
        _homeAddressController.text =
            '${_nHomeAddress.isEmpty ? _homeAddress : _nHomeAddress}';
        try {
          print(
              '${markerId.value} x ${_markers['selectedLocation'].markerId.value}');
          if (_mapController != null) {
            _mapController
                .hideMarkerInfoWindow(_markers['selectedLocation'].markerId);
          }
        } catch (e) {
          print('No marker displayed currently.');
        }
        _mapController
            .animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: latlng, zoom: 16.0)))
            .then((_) {
          try {
            _mapController
                .showMarkerInfoWindow(_markers['selectedLocation'].markerId);
          } catch (e) {
            print('exception $e X ${_markers.length} x $_markers}');
          }
        });
      });
    });
    return Future.value();
  }

  Future<File> file(String filename) async {
    Directory dir = await getExternalStorageDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
  }

  handleImagePath(String value) {
    print('CAMERA - $value');
    setState(() {
      _imagePath = value;
      _imageFile = File(_imagePath);
    });
  }

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var _image = pickedFile;
      setState(() {
        _imagePath = _image.path;
        _imageFile = File(_imagePath);
      });
    } else {
      print('No image selected.');
    }
  }

  bool _isValidMinAge() {
    if (_nBirthDate.isEmpty) {
      return true;
    } else {
      String datePattern = "MM/dd/yyyy";

      // Current time - at this moment
      DateTime today = DateTime.now();

      // Parsed date to check
      DateTime birthDate = DateFormat(datePattern).parse(_nBirthDate);

      // Date to check but moved 18 years ahead
      DateTime adultDate = DateTime(
        birthDate.year + 7,
        birthDate.month,
        birthDate.day,
      );
      return adultDate.isBefore(today);
    }
  }

  bool _isValidMaxAge() {
    if (_nBirthDate.isEmpty) {
      return true;
    } else {
      String datePattern = "MM/dd/yyyy";

      // Current time - at this moment
      DateTime today = DateTime.now();

      // Parsed date to check
      DateTime birthDate = DateFormat(datePattern).parse(_nBirthDate);

      // Date to check but moved 18 years ahead
      DateTime adultDate = DateTime(
        birthDate.year + 140,
        birthDate.month,
        birthDate.day,
      );
      return adultDate.isAfter(today);
    }
  }

  bool _validatePersonalInfo() {
    bool flag = true;
    String errorMsg = '';
    if (_homeAddress.isEmpty && _nHomeAddress.isEmpty) {
      errorMsg += '- home address is empty.\n';
      _errHomeAdd = 'error';
      flag = false;
    } else {
      _errHomeAdd = null;
    }
    if ((_gender == null || _gender.isEmpty) && _nGender.isEmpty) {
      errorMsg += '- gender is empty.\n';
      _errGender = 'error';
      flag = false;
    } else {
      _errGender = null;
    }
    if ((_civilStatus == null || _civilStatus.isEmpty) &&
        _nCivilStatus.isEmpty) {
      errorMsg += '- civil status is empty.\n';
      _errCivilStatus = 'error';
      flag = false;
    } else {
      _errCivilStatus = null;
    }
    if ((_birthDate == null || _birthDate.isEmpty) && _nBirthDate.isEmpty) {
      errorMsg += '- birth date is empty.\n';
      _isBDayError = true;
      flag = false;
    } else if (!_isValidMinAge()) {
      errorMsg +=
          '- birth date is invalid. You are too young to use this application.\n';
      _isBDayError = true;
      flag = false;
    } else if (!_isValidMaxAge()) {
      errorMsg +=
          '- birth date is invalid. You are too old to use this application.\n';
      _isBDayError = true;
      flag = false;
    } else {
      _isBDayError = false;
    }
    if (!flag) {
      setState(() {});
      showMessageDialog(
          context,
          '${widget.isUpdate ? 'Editing' : 'Creating'} Profile failed',
          errorMsg);
    }
    return flag;
  }

  Future<Null> displayPrediction(gmws.Prediction p) async {
    if (p != null) {
      gmws.PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      // var address = await _getAddress(LatLon(lat, lng));

      // print(lat);
      // print(lng);
      _addMarker(new LatLng(lat, lng));
    }
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

    if (widget.userVM != null) {
      _homeAddress = widget.userVM.homeAddress ?? '';
      _gender = widget.userVM.gender;
      _civilStatus = widget.userVM.civilStatus;
      _birthDate = widget.userVM.birthDate;
      _bio = widget.userVM.bio ?? '';

      if (widget.userVM.positionStatus != null) {
        for (int i = 0; i < _respStatusOptions.length; i++) {
          RespStatus r = _respStatusOptions[i];
          if (r.v.toLowerCase() == widget.userVM.positionStatus.toLowerCase()) {
            _responderStatus = r.txt;
          }
        }
      }
      _org = widget.userVM.company;
      _orgAddress = widget.userVM.location;
      _website = widget.userVM.website;
      _skills = widget.userVM.skills
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '');
    } else {
      _homeAddress = '';
      _bio = '';

      _org = '';
      _orgAddress = '';
      _website = '';
      _skills = '';
    }

    _homeAddressController = TextEditingController(
        text: (widget.userVM == null || widget.userVM.homeAddress == null)
            ? ''
            : widget.userVM.homeAddress);
    _bioController = TextEditingController(
        text: (widget.userVM == null || widget.userVM.bio == null)
            ? ''
            : widget.userVM.bio);
    _searchAddressController = TextEditingController(text: '');

    _organizationController = TextEditingController(
        text: (widget.userVM == null || widget.userVM.company == null)
            ? ''
            : widget.userVM.company);
    _websiteController = TextEditingController(
        text: (widget.userVM == null || widget.userVM.website == null)
            ? ''
            : widget.userVM.website);
    _orgAddressController = TextEditingController(
        text: (widget.userVM == null || widget.userVM.location == null)
            ? ''
            : widget.userVM.location);
    _skillsController = TextEditingController(
        text: (widget.userVM == null || widget.userVM.skills.length == 0)
            ? ''
            : widget.userVM.skills.toString());

    _contactPersonController = TextEditingController(text: '');
    _relationshipController = TextEditingController(text: '');
    _contactNumberController = TextEditingController(text: '');
    _contactAddressController = TextEditingController(text: '');

    _twUrlController = TextEditingController(text: '');
    _fbUrlController = TextEditingController(text: '');
    _ytUrlController = TextEditingController(text: '');
    _inUrlController = TextEditingController(text: '');
    _igUrlController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _mapController.dispose();

    _homeAddressController.dispose();
    _bioController.dispose();
    _searchAddressController.dispose();

    _organizationController.dispose();
    _websiteController.dispose();
    _orgAddressController.dispose();
    _skillsController.dispose();

    _contactPersonController.dispose();
    _relationshipController.dispose();
    _contactNumberController.dispose();
    _contactAddressController.dispose();

    _twUrlController.dispose();
    _fbUrlController.dispose();
    _ytUrlController.dispose();
    _inUrlController.dispose();
    _igUrlController.dispose();

    super.dispose();
  }

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
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  NavigationHelper.openCameraProfile(
                      context, widget.token, handleImagePath);
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
                    hSpacer(
                      w: 8.0,
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
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _getImage();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.solidImage,
                      size: 16.0,
                      color: Colors.grey,
                    ),
                    hSpacer(
                      w: 8.0,
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

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    print('edit-profile build x $_imagePath X $_imageFile');
    return ((widget.userVM == null ||
                widget.userVM.profilePic == null ||
                widget.userVM.profilePic.contains('null')) &&
            _imagePath == null)
        ? FutureBuilder<File>(
            future: file('defaultProfPic.png'),
            builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
              Widget w;
              if (snapshot.hasData) {
                print('Ikaw pala ${snapshot.data}');
                _imageFile = snapshot.data;
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
                              _header,
                              Align(
                                alignment: Alignment.center,
                                child: Stack(
                                  children: [
                                    _defaultProfPic,
                                    _cameraIcon,
                                  ],
                                ),
                              ),
                              vSpacer(
                                h: 16.0,
                              ),
                              _expandablePersonalInfo,
                              _expandableOrganizationInfo,
                              _expandableEmergencyInfo,
                              _expandableSocialNetworkLinks,
                              vSpacer(
                                h: 8.0,
                              ),
                              _buttons,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                w = Container(
                  color: Colors.black,
                );
              } else {
                w = Container(
                  color: Colors.red,
                );
              }
              return w;
            },
          )
        : Scaffold(
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
                        _header,
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              _profPic,
                              _cameraIcon,
                            ],
                          ),
                        ),
                        vSpacer(
                          h: 16.0,
                        ),
                        _expandablePersonalInfo,
                        _expandableOrganizationInfo,
                        _expandableEmergencyInfo,
                        _expandableSocialNetworkLinks,
                        vSpacer(
                          h: 8.0,
                        ),
                        _buttons,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget get _header => Column(
        mainAxisSize: MainAxisSize.min,
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
          vSpacer(
            h: 16.0,
          ),
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.solidUser,
                size: 16.0,
                color: Colors.black,
              ),
              hSpacer(
                w: 8.0,
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
          ),
          vSpacer(
            h: 16.0,
          ),
          Text(
            '* = required field',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w400,
            ),
          ),
          vSpacer(
            h: 16.0,
          ),
        ],
      );

  Widget get _defaultProfPic => GestureDetector(
        onTap: _displayBottomSheet,
        child: CircleAvatar(
          radius: 80.0,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 79.0,
            backgroundColor: Colors.white,
            backgroundImage: _imagePath != null
                ? FileImage(_imageFile)
                : NetworkToFileImage(
                    url: '$secretHollowsEndPoint:5000/Spotter.png',
                    file: _imageFile,
                    debug: true,
                  ),
          ),
        ),
      );

  Widget get _profPic => GestureDetector(
        onTap: _displayBottomSheet,
        child: CircleAvatar(
          radius: 80.0,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 79.0,
            backgroundColor: Colors.white,
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile)
                : NetworkImage(
                    widget.userVM.profilePic,
                  ),
          ),
        ),
      );

  Widget get _cameraIcon => Positioned(
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
      );

  Widget _buildFormLabel(String label, bool flag, IconData ic) => Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FaIcon(
              ic,
              size: 16.0,
              color: colorPrimary,
            ),
            hSpacer(
              w: 8.0,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: colorPrimary,
                  ),
                ),
              ),
            ),
            FaIcon(
              (flag) ? FontAwesomeIcons.angleUp : FontAwesomeIcons.angleDown,
              color: colorPrimary,
              // size: 16.0,
            ),
          ],
        ),
      );

  Widget _buildLabel(String label) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            // fontSize: 12.0,
            color: Colors.grey.shade800,
          ),
        ),
      );

  Widget get _buildHomeAddress => TextFormField(
        controller: _homeAddressController,
        autovalidateMode: AutovalidateMode.disabled,
        enabled: false,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
        decoration: editInputDecoration2.copyWith(
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          hintText: '* Home Address',
          errorStyle: TextStyle(
            fontSize: 0.0,
          ),
          errorText: _errHomeAdd,
        ),
        keyboardType: TextInputType.text,
        maxLines: 1,
        minLines: 1,
        onChanged: (val) {
          if (val != _homeAddress) {
            _nHomeAddress = val;
          } else {
            _nHomeAddress = '';
          }
        },
      );

  Widget get _buildGender => DropdownButtonFormField(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        value: _nGender.isEmpty ? _gender : _nGender,
        decoration: editInputDecoration2.copyWith(
          hintText: '* Gender',
          errorStyle: TextStyle(
            fontSize: 0.0,
          ),
          errorText: _errGender,
        ),
        items: _genderOptions.map((c) {
          return DropdownMenuItem(
            value: c,
            child: Text('$c'),
          );
        }).toList(),
        onChanged: (val) {
          if (val != _gender) {
            _nGender = val;
          } else {
            _nGender = '';
          }
        },
      );

  Widget get _buildCivilStatus => DropdownButtonFormField(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        value: _civilStatus,
        decoration: editInputDecoration2.copyWith(
          hintText: '* Civil Status',
          errorStyle: TextStyle(
            fontSize: 0.0,
          ),
          errorText: _errCivilStatus,
        ),
        items: _civilStatusOptions.map((c) {
          return DropdownMenuItem(
            value: c,
            child: Text('$c'),
          );
        }).toList(),
        onChanged: (val) {
          if (val != _civilStatus) {
            _nCivilStatus = val;
          } else {
            _nCivilStatus = '';
          }
        },
      );

  Widget get _buildBirthDate => TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          primary: _birthDate == null ? Colors.grey : Colors.black,
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          side: BorderSide(
            color: _isBDayError ? Colors.red : Colors.black,
            width: 2.0,
          ),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          DateTime _currentDate;
          try {
            if (_nBirthDate.isNotEmpty) {
              _currentDate = DateTime.parse(DateFormat('yyyyMMdd')
                  .format(DateFormat('MM/dd/yyyy').parse(_nBirthDate)));
            } else {
              if (_birthDate == null) {
                _currentDate = DateTime.now();
              } else {
                _currentDate = DateTime.parse(DateFormat('yyyyMMdd')
                    .format(DateFormat('MM/dd/yyyy').parse(_birthDate)));
              }
            }
          } catch (e) {
            print(e);
            _currentDate = DateTime.now();
          }
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(1900, 1, 1),
            maxTime: DateTime.now(),
            onChanged: (date) {
              print('change $date');
            },
            onConfirm: (date) {
              print('confirm: $date');
              String tempBDate = DateFormat('MM/dd/yyyy').format(date);
              if (tempBDate != _birthDate) {
                setState(() {
                  _nBirthDate = tempBDate;
                });
              } else {
                setState(() {
                  _nBirthDate = '';
                });
              }
              print('_bdate - $_nBirthDate');
            },
            currentTime: DateTime(
              _currentDate.year,
              _currentDate.month,
              _currentDate.day,
            ),
            locale: LocaleType.en,
          );
        },
        child: Container(
          width: double.infinity,
          height: 48.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${_nBirthDate.isEmpty ? _birthDate ?? '* Select Birth date (mm/dd/yyyy)' : _nBirthDate}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      );

  Widget get _buildBio => TextFormField(
        controller: _bioController,
        autovalidateMode: AutovalidateMode.disabled,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
        decoration: editInputDecoration2.copyWith(
          hintText: 'Bio',
          errorStyle: TextStyle(
            fontSize: 0.0,
          ),
          errorText: _errBio,
        ),
        keyboardType: TextInputType.text,
        maxLines: 4,
        minLines: 4,
        onChanged: (val) {
          if (val != _bio) {
            _nBio = val;
          } else {
            _nBio = '';
          }
        },
      );

  Widget get _expandablePersonalInfo => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              if (_mapController != null) {
                if (!_isExpandedPInfo) {
                  if (_selectedLL == null) {
                    if (_acquiredLL != null) {
                      if (_mapController != null) {
                        _mapController
                            .animateCamera(CameraUpdate.newCameraPosition(
                                CameraPosition(
                                    target: _acquiredLL, zoom: 16.0)))
                            .then((_) {
                          try {
                            _mapController.showMarkerInfoWindow(
                                _markers['selectedLocation'].markerId);
                          } catch (e) {
                            print(
                                'exception $e X ${_markers.length} x $_markers}');
                          }
                        });
                      }
                    }
                  } else {
                    if (_mapController != null) {
                      _mapController
                          .animateCamera(CameraUpdate.newCameraPosition(
                              CameraPosition(target: _selectedLL, zoom: 16.0)))
                          .then((_) {
                        try {
                          _mapController.showMarkerInfoWindow(
                              _markers['selectedLocation'].markerId);
                        } catch (e) {
                          print(
                              'exception $e X ${_markers.length} x $_markers}');
                        }
                      });
                    }
                  }
                }
              }
              _isExpandedPInfo = !_isExpandedPInfo;
            }),
            child: _buildFormLabel(
              '* Personal Information',
              _isExpandedPInfo,
              FontAwesomeIcons.solidAddressBook,
            ),
          ),
          vSpacer(
            h: 4.0,
          ),
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 350),
            child: ConstrainedBox(
              constraints: _isExpandedPInfo
                  ? BoxConstraints()
                  : BoxConstraints(maxHeight: 0.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 228.0,
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          compassEnabled: false,
                          trafficEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target:
                                LatLng(0.0, 0.0), // TODO: change to initialLL
                          ),
                          markers: Set<Marker>.of(_markers.values),
                          onLongPress: (latlng) {
                            print('on Long Press: $latlng');
                            _addMarker(latlng);
                          },
                          gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>[
                            new Factory<OneSequenceGestureRecognizer>(
                              () => new EagerGestureRecognizer(),
                            ),
                          ].toSet(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Material(
                          color: Color(0xB0FFFFFF), // button color
                          child: InkWell(
                            splashColor: Colors.grey.shade500, // inkwell color
                            child: SizedBox(
                              width: 36.0,
                              height: 36.0,
                              child: Icon(
                                Icons.search,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            onTap: () async {
                              // show input autocomplete with selected mode
                              // then get the Prediction selected
                              gmws.Prediction p = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: gMAK,
                                radius: 10000.0,
                                region: 'ph',
                                language: 'en',
                                types: [''],
                                mode: Mode.overlay,
                                strictbounds: false,
                                components: [
                                  new gmws.Component(
                                      gmws.Component.country, 'ph')
                                ],
                              );
                              displayPrediction(p);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*TextField(
                decoration: editInputDecoration2,
                onTap: () async {
                  // show input autocomplete with selected mode
                  // then get the Prediction selected
                  gmws.Prediction p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: gMAK,
                    radius: 10000.0,
                    region: 'ph',
                    language: 'en',
                    types: [''],
                    mode: Mode.overlay,
                    strictbounds: false,
                    components: [new gmws.Component(gmws.Component.country, 'ph')],
                  );
                  displayPrediction(p);
                },
              ),*/
                  /*AddressSearchBuilder(
                geoMethods: geoMethods,
                controller: _searchAddressController,
                builder: (
                    BuildContext context,
                    AsyncSnapshot<List<Address>> snapshot,
                    TextEditingController controller,
                    Future<void> Function() searchAddress,
                    Future<Address> Function(Address address) getGeometry,
                    ) {
                  return EditText(
                    snapshot: snapshot,
                    controller: controller,
                    searchAddress: searchAddress,
                    getGeometry: getGeometry,
                    onDone: (Address address) => null,
                  );
                },
              ),*/
                  /*AddressSearchBuilder.deft(
                geoMethods: geoMethods,
                controller: _searchAddressController,
                builder: AddressDialogBuilder(),
                onDone: (Address address) => null,
              ),*/
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildHomeAddress,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('* Home Address'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildGender,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('* Gender'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildCivilStatus,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('* Civil Status'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildBirthDate,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('* Birth Date'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildBio,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('Please tell us a little about yourself'),
                  vSpacer(
                    h: 8.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget get _buildResponderStatus => DropdownButtonFormField(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        value: _responderStatus,
        decoration: editInputDecoration2.copyWith(
          hintText: '* Responder Status',
        ),
        items: _respStatusOptions.map((c) {
          return DropdownMenuItem(
            value: c.v,
            child: Text('${c.txt}'),
          );
        }).toList(),
        onChanged: (val) {
          if (val != _responderStatus) {
            _nResponderStatus = val;
          } else {
            _nResponderStatus = '';
          }
        },
      );

  Widget get _buildOrganizationName => TextFormField(
        controller: _organizationController,
        autovalidateMode: AutovalidateMode.disabled,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
        decoration: editInputDecoration2.copyWith(
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          hintText: 'Organization Name',
        ),
        keyboardType: TextInputType.text,
        maxLines: 2,
        minLines: 1,
        onChanged: (val) {
          if (val != _org) {
            _nOrg = val;
          } else {
            _nOrg = '';
          }
        },
      );

  Widget get _buildOrgWebsite => TextFormField(
        controller: _websiteController,
        autovalidateMode: AutovalidateMode.disabled,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
        decoration: editInputDecoration2.copyWith(
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          hintText: 'Organization Website',
        ),
        keyboardType: TextInputType.url,
        maxLines: 2,
        minLines: 1,
        onChanged: (val) {
          if (val != _website) {
            _nWebsite = val;
          } else {
            _nWebsite = '';
          }
        },
      );

  Widget get _buildOrgAddress => TextFormField(
        controller: _orgAddressController,
        autovalidateMode: AutovalidateMode.disabled,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
        decoration: editInputDecoration2.copyWith(
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          hintText: '* Organization Address',
        ),
        keyboardType: TextInputType.text,
        maxLines: 2,
        minLines: 1,
        onChanged: (String val) {
          if (val != _orgAddress) {
            _nOrgAddress = val;
          } else {
            _nOrgAddress = '';
          }
        },
      );

  Widget get _buildSkills => TextFormField(
        controller: _skillsController,
        autovalidateMode: AutovalidateMode.disabled,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
        decoration: editInputDecoration2.copyWith(
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          hintText: '* Skills',
        ),
        keyboardType: TextInputType.text,
        maxLines: 4,
        minLines: 1,
        onChanged: (String val) {
          if (val != _skills) {
            _nSkills = val;
          } else {
            _nSkills = '';
          }
        },
      );

  Widget get _expandableOrganizationInfo => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              _isExpandedOInfo = !_isExpandedOInfo;
            }),
            child: _buildFormLabel(
              'Organization/Company',
              _isExpandedOInfo,
              FontAwesomeIcons.solidBuilding,
            ),
          ),
          vSpacer(
            h: 4.0,
          ),
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 350),
            child: ConstrainedBox(
              constraints: _isExpandedOInfo
                  ? BoxConstraints()
                  : BoxConstraints(maxHeight: 0.0),
              child: Column(
                children: [
                  _buildResponderStatus,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel(
                      '* Give us an idea of where you are at in your emergency response career'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildOrganizationName,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('* Organization you are affiliated/member'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildOrgWebsite,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('Organization Website'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildOrgAddress,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel(
                      '* City or Municipality where organization is located'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildSkills,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel(
                      '* Please use comma separated values (eg. Patient Care, EMS, EMT, CPR, Hazardous Materials, Trauma)'),
                  vSpacer(
                    h: 8.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget get _buildContactPerson => TextFormField(
        key: Key('contactPerson'),
        validator: (value) => value.isEmpty ? '* Contact Person' : null,
        controller: _contactPersonController,
        autovalidateMode: AutovalidateMode.disabled,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
        decoration: editInputDecoration2.copyWith(
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          hintText: '* Contact Person',
        ),
        keyboardType: TextInputType.text,
        maxLines: 1,
        minLines: 1,
        onSaved: (String val) {
          _contactPerson = val;
        },
        onChanged: (String val) {
          _contactPerson = val;
        },
      );

  Widget get _buildRelationship => TextFormField(
        key: Key('relationship'),
        validator: (value) => value.isEmpty ? '* Relationship' : null,
        controller: _relationshipController,
        autovalidateMode: AutovalidateMode.disabled,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
        decoration: editInputDecoration2.copyWith(
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          hintText: '* Relationship',
        ),
        keyboardType: TextInputType.text,
        maxLines: 1,
        minLines: 1,
        onSaved: (String val) {
          _relationship = val;
        },
        onChanged: (String val) {
          _relationship = val;
        },
      );

  Widget get _buildContactNumber => TextFormField(
        key: Key('contactNumber'),
        validator: (value) => value.isEmpty ? '* Contact Number' : null,
        controller: _contactNumberController,
        autovalidateMode: AutovalidateMode.disabled,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
        decoration: editInputDecoration2.copyWith(
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          hintText: '* Contact Number',
        ),
        keyboardType: TextInputType.text,
        maxLines: 1,
        minLines: 1,
        onSaved: (String val) {
          _contactNumber = val;
        },
        onChanged: (String val) {
          _contactNumber = val;
        },
      );

  Widget get _buildContactAddress => TextFormField(
        key: Key('contactAddress'),
        validator: (value) => value.isEmpty ? '* Contact Address' : null,
        controller: _contactAddressController,
        autovalidateMode: AutovalidateMode.disabled,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
        decoration: editInputDecoration2.copyWith(
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          hintText: '* Contact Address',
        ),
        keyboardType: TextInputType.text,
        maxLines: 1,
        minLines: 1,
        onSaved: (String val) {
          _contactAddress = val;
        },
        onChanged: (String val) {
          _contactAddress = val;
        },
      );

  Widget get _buildBloodType => DropdownButtonFormField(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        value: _bloodType,
        decoration: editInputDecoration2.copyWith(
          hintText: 'Blood Type',
        ),
        items: _bloodTypeOptions.map((c) {
          return DropdownMenuItem(
            value: c,
            child: Text('$c'),
          );
        }).toList(),
        onChanged: (val) => _bloodType = val,
      );

  Widget get _buildInsurance => DropdownButtonFormField(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        value: _isInsured,
        decoration: editInputDecoration2.copyWith(
          hintText: 'Insured?',
        ),
        items: _insuranceOptions.map((c) {
          return DropdownMenuItem(
            value: c,
            child: Text('$c'),
          );
        }).toList(),
        onChanged: (val) => _isInsured = val,
      );

  Widget get _expandableEmergencyInfo => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              _isExpandedEInfo = !_isExpandedEInfo;
            }),
            child: _buildFormLabel(
              'Emergency Information',
              _isExpandedEInfo,
              FontAwesomeIcons.solidBuilding,
            ),
          ),
          vSpacer(
            h: 4.0,
          ),
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 350),
            child: ConstrainedBox(
              constraints: _isExpandedEInfo
                  ? BoxConstraints()
                  : BoxConstraints(maxHeight: 0.0),
              child: Column(
                children: [
                  _buildContactPerson,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel(
                      '* Name of person you wish to contact in case of emergency'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildRelationship,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('* Relationship to contact person'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildContactNumber,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('* Contact Number of your contact person'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildContactAddress,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('* Address of your contact person'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildBloodType,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('Blood Type'),
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildInsurance,
                  vSpacer(
                    h: 4.0,
                  ),
                  _buildLabel('Do you have an insurance policy?'),
                  vSpacer(
                    h: 8.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget get _buildTwitter => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FaIcon(
            FontAwesomeIcons.twitter,
            size: 24.0,
            color: Color(0xff38a1f3),
          ),
          hSpacer(
            w: 11.5,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                key: Key('twUrl'),
                validator: (value) => value.isEmpty ? 'Twitter URL' : null,
                controller: _twUrlController,
                autovalidateMode: AutovalidateMode.disabled,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                textAlignVertical: TextAlignVertical.top,
                decoration: editInputDecoration2.copyWith(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  hintText: 'Twitter URL',
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                minLines: 1,
                onSaved: (String val) {
                  _twUrl = val;
                },
                onChanged: (String val) {
                  _twUrl = val;
                },
              ),
            ),
          ),
        ],
      );

  Widget get _buildFacebook => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FaIcon(
            FontAwesomeIcons.facebook,
            size: 24.0,
            color: Color(0xff3b5998),
          ),
          hSpacer(
            w: 11.5,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                key: Key('fbUrl'),
                validator: (value) => value.isEmpty ? 'Facebook URL' : null,
                controller: _fbUrlController,
                autovalidateMode: AutovalidateMode.disabled,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                textAlignVertical: TextAlignVertical.top,
                decoration: editInputDecoration2.copyWith(
                  hintText: 'Facebook URL',
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                minLines: 1,
                onSaved: (String val) {
                  _fbUrl = val;
                },
                onChanged: (String val) {
                  _fbUrl = val;
                },
              ),
            ),
          ),
        ],
      );

  Widget get _buildYoutube => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FaIcon(
            FontAwesomeIcons.youtube,
            size: 24.0,
            color: Color(0xffc4302b),
          ),
          hSpacer(
            w: 8.0,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                key: Key('ytUrl'),
                validator: (value) => value.isEmpty ? 'Youtube URL' : null,
                controller: _ytUrlController,
                autovalidateMode: AutovalidateMode.disabled,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                textAlignVertical: TextAlignVertical.top,
                decoration: editInputDecoration2.copyWith(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  hintText: 'Youtube URL',
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                minLines: 1,
                onSaved: (String val) {
                  _ytUrl = val;
                },
                onChanged: (String val) {
                  _ytUrl = val;
                },
              ),
            ),
          ),
        ],
      );

  Widget get _buildLinkedIn => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FaIcon(
            FontAwesomeIcons.linkedin,
            size: 24.0,
            color: Color(0xff0077b5),
          ),
          hSpacer(
            w: 14.0,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                key: Key('inUrl'),
                validator: (value) => value.isEmpty ? 'LinkedIn URL' : null,
                controller: _inUrlController,
                autovalidateMode: AutovalidateMode.disabled,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                textAlignVertical: TextAlignVertical.top,
                decoration: editInputDecoration2.copyWith(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  hintText: 'LinkedIn URL',
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                minLines: 1,
                onSaved: (String val) {
                  _inUrl = val;
                },
                onChanged: (String val) {
                  _inUrl = val;
                },
              ),
            ),
          ),
        ],
      );

  Widget get _buildInstagram => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FaIcon(
            FontAwesomeIcons.instagram,
            size: 24.0,
            color: Color(0xff3f729b),
          ),
          hSpacer(
            w: 13.5,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                key: Key('igUrl'),
                validator: (value) => value.isEmpty ? 'Instagram URL' : null,
                controller: _igUrlController,
                autovalidateMode: AutovalidateMode.disabled,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                textAlignVertical: TextAlignVertical.top,
                decoration: editInputDecoration2.copyWith(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  hintText: 'Instagram URL',
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                minLines: 1,
                onSaved: (String val) {
                  _igUrl = val;
                },
                onChanged: (String val) {
                  _igUrl = val;
                },
              ),
            ),
          ),
        ],
      );

  Widget get _expandableSocialNetworkLinks => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              _isExpandedSNInfo = !_isExpandedSNInfo;
            }),
            child: _buildFormLabel(
              'Social Network Links',
              _isExpandedSNInfo,
              FontAwesomeIcons.desktop,
            ),
          ),
          vSpacer(
            h: 4.0,
          ),
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 350),
            child: ConstrainedBox(
              constraints: _isExpandedSNInfo
                  ? BoxConstraints()
                  : BoxConstraints(maxHeight: 0.0),
              child: Column(
                children: [
                  _buildTwitter,
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildFacebook,
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildYoutube,
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildLinkedIn,
                  vSpacer(
                    h: 8.0,
                  ),
                  _buildInstagram,
                  vSpacer(
                    h: 8.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget get _submitBtn => TextButton(
        style: TextButton.styleFrom(
          backgroundColor: colorPrimary,
          primary: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (_validatePersonalInfo()) {
            if (_isExpandedOInfo) {}
            if (_isExpandedEInfo) {
            } else {
              if (_imageFile == null &&
                  _nHomeAddress.isEmpty &&
                  _nGender.isEmpty &&
                  _nCivilStatus.isEmpty &&
                  _nBirthDate.isEmpty &&
                  _nBio.isEmpty) {
                final _snackBar = SnackBar(
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.redAccent,
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  content: Text(
                    'No changes were made',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: ((BuildContext context) {
                    return Dialog(
                      backgroundColor: colorPrimary1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${widget.isUpdate ? 'Updating' : 'Creating'} Profile',
                              style: TextStyle(
                                fontSize: 36.0,
                                color: Colors.white,
                              ),
                            ),
                            vSpacer(
                              h: 16.0,
                            ),
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
                _submitEdit();
              }
            }
          }
        },
        child: Text(
          'Submit',
          style: TextStyle(
            fontSize: 16.0,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  Widget get _backBtn => TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          primary: colorPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Go Back',
          style: TextStyle(
            fontSize: 16.0,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  Widget get _buttons => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _submitBtn,
          hSpacer(
            w: 2.0,
          ),
          _backBtn,
        ],
      );

  void _submitEdit() {
    try {
      if (_imageFile == null) {
        _submitEditApiNoPic().then((val) {
          if (!val.toLowerCase().contains('error')) {
            final _snackBar = SnackBar(
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              content: Text(
                'Profile successfully ${widget.isUpdate ? 'updated' : 'created'}.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            );
            _nHomeAddress = '';
            _nGender = '';
            _nCivilStatus = '';
            _nBirthDate = '';
            _nBio = '';
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
            UserDetailsData d = UserDetailsData.fromJsonMap2(
                jsonDecode(val), widget.userVM.user);
            widget.refresh(UserProfileViewModel(userDetails: d));
          }
        });
      } else {
        _submitEditApiPic().then((val) {
          if (!val.toLowerCase().contains('error')) {
            final _snackBar = SnackBar(
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              content: Text(
                'Profile successfully ${widget.isUpdate ? 'updated' : 'created'}.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            );
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
            UserDetailsData d = UserDetailsData.fromJsonMap2(
                jsonDecode(val), widget.userVM.user);
            widget.refresh(UserProfileViewModel(userDetails: d));
          }
        });
      }
    } catch (e) {}
  }

  Future<String> _submitEditApiPic() async {
    Map<String, String> header = {
      'Content-Type': 'multipart/form-data;',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'x-auth-token': widget.token,
    };
    Map<String, String> params = {
      'completeaddress':
          '${_nHomeAddress.isEmpty ? _homeAddress : _nHomeAddress}',
      'gender': '${_nGender.isEmpty ? _gender : _nGender}',
      'civilstatus': '${_nCivilStatus.isEmpty ? _civilStatus : _nCivilStatus}',
      'birthday': '${_nBirthDate.isEmpty ? _birthDate : _nBirthDate}',
      'bio': '${_nBio.isEmpty ? _bio : _nBio}',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('$secretHollowsEndPoint/api/profile'));
    request.headers.addAll(header);
    request.files
        .add(await http.MultipartFile.fromPath('profilepic', _imageFile.path));
    request.fields.addAll(params);
    var res = await request.send();
    // return res;
    var r = http.Response.fromStream(res).then((response) {
      print('editRes? $response x ${response.statusCode} x ${response.body}');
      return response.body;
    });
    return r;
  }

  Future<String> _submitEditApiNoPic() async {
    var url = Uri.parse('$secretHollowsEndPoint/api/profile');
    Map<String, String> params = {
      'completeaddress':
          '${_nHomeAddress.isEmpty ? _homeAddress : _nHomeAddress}',
      'gender': '${_nGender.isEmpty ? _gender : _nGender}',
      'civilstatus': '${_nCivilStatus.isEmpty ? _civilStatus : _nCivilStatus}',
      'birthday': '${_nBirthDate.isEmpty ? _birthDate : _nBirthDate}',
      'bio': '${_nBio.isEmpty ? _bio : _nBio}',
    };
    var reqBody = json.encode(params);
    var response = await http
        .post(
      url,
      headers: {
        'Cache-Control': 'no-cache',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'Content-Type': 'application/json',
        'x-auth-token': widget.token,
      },
      body: reqBody,
    )
        .onError((error, stackTrace) {
      // setState(() {
      //   _isLoading = false;
      // });
      showMessageDialog(
          context,
          '${widget.isUpdate ? 'Editing' : 'Creating'} profile failed',
          '- can\'t connect to server.');
      return error;
    });
    print('editRes: $response X ${response.body}');
    return response.body;
  }

  void _showPopupMenu(Offset offset) {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        maxColumn: 1,
        items: [
          MenuItem(
            title: 'Remove',
            image: FaIcon(
              FontAwesomeIcons.trashAlt,
              color: Colors.white,
            ),
          ),
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(rect: Rect.fromPoints(offset, offset));
  }

  void stateChanged(bool isShow) {
    // print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(MenuItemProvider item) {
    // print('Click menu -> ${item.menuTitle}');
  }

  void onDismiss() {
    // print('Menu is dismiss');
  }
}

class RespStatus {
  String v;
  String txt;

  RespStatus({this.v, this.txt});
}
