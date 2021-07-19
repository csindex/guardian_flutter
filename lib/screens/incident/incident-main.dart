import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_geocoding/google_geocoding.dart';

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../../utils/helpers/dialog-helper.dart';

class IncidentMain extends StatefulWidget {
  final UserProfileViewModel userVM;
  final UserViewModel uVM;
  final String token;
  // final Function refresh;

  IncidentMain({this.userVM, this.token, this.uVM});

  @override
  _IncidentMainState createState() => _IncidentMainState();
}

class _IncidentMainState extends State<IncidentMain>
    with AutomaticKeepAliveClientMixin<IncidentMain> {

  final _formPageKey = GlobalKey<FormState>();

  bool _isLoading = false;

  String btnAsset = 'assets/buttons/ic_emergency.png';
  String state = 'noIncident';
  String type;
  String iconAsset = 'assets/images/ic_ambulance.png';

  GoogleMapController _mapController;
  final Map<String, Marker> _markers = {};
  LatLng _acquiredLL;
  double lat, lng;

  String _reportAddress;
  TextEditingController _reportAddressController;

  String _stateAddress;
  String _city;
  String _area;

  void _onReport(String type) {
    setState(() {
      state = 'report';
      this.type = type;
      switch (type) {
        case 'Crime': {
          iconAsset = 'assets/images/ic_police.png';
          break;
        }
        // case 'Medical': {
        //   iconAsset = 'assets/ic_ambulance.png';
        //   break;
        // }
        case 'Fire': {
          iconAsset = 'assets/images/ic_firetruck.png';
          break;
        }
        // case 'Covid': {
        //   iconAsset = 'assets/ic_ambulance.png';
        //   break;
        // }
        default: {
          iconAsset = 'assets/images/ic_ambulance.png';
          break;
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.userVM == null || widget.userVM.lat == null) {
      determinePosition().then((value) {
        var lat = value.latitude;
        var lng = value.longitude;
        _acquiredLL = LatLng(lat, lng);
        _addMarker(_acquiredLL);
      });
    } else {
      _addMarker(LatLng(widget.userVM.lat, widget.userVM.lng));
    }
    _reportAddressController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();
    if (_mapController != null) {
      _mapController.dispose();
    }
    _reportAddressController.dispose();
  }

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

  Future<void> _addMarker(LatLng latlng) {
    lat = latlng.latitude;
    lng = latlng.longitude;
    getAddress(LatLon(lat, lng)).then((value) {
      var a = value[0].formattedAddress;
      print('address($lat, $lng)');
      var cty, area, stateA;
      for (var g in value) {
        for (var c in g.addressComponents) {
          if (c.types == ['locality', 'political']) {
            cty = c.longName;
          }
          if (c.types == ['administrative_area_level_5', 'political']) {
            area = c.longName;
          }
          if (c.types == ['administrative_area_level_2', 'political']) {
            stateA = c.longName;
          }
          else {
            continue;
          }
        }
      }
      final MarkerId markerId = MarkerId('selectedLocation');
      setState(() {
        // creating a new MARKER
        final Marker marker = Marker(
          markerId: markerId,
          position: latlng,
          draggable: true,
          infoWindow: InfoWindow(title: 'Selected Address', snippet: a),
          onTap: () {
            // _onMarkerTapped(markerId);
          },
          onDragEnd: _addMarker,
        );
        _markers.clear();
        _markers['selectedLocation'] = marker;
        _reportAddress = a;
        _stateAddress = stateA;
        _area = area;
        _city = cty;
        _reportAddressController.text = _reportAddress;
        try {
          print('${markerId.value} x ${_markers['selectedLocation'].markerId.value}');
          if (_mapController != null) {
            _mapController.hideMarkerInfoWindow(
                _markers['selectedLocation'].markerId);
          }
        } catch (e) {
          print('No marker displayed currently.');
        }
        _mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: latlng, zoom: 16.0)))?.then((_) {
          try {
            _mapController.showMarkerInfoWindow(_markers['selectedLocation'].markerId);
          } catch (e) {
            print('exception $e X ${_markers.length} x $_markers}');
          }
        });
      });
    });
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    switch (state) {
      case 'report': {
        return _stateReport;
      }
      case 'activeIncident': {
        return _stateActiveIncident;
      }
      default: return _stateNoIncident;
    }
  }

  Widget get _stateNoIncident => Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 32.0),
    child: Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            vSpacer(h: 16.0,),
            Text(
              '* Inactive / Past Incidents display here',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            vSpacer(h: 8.0,),
            Text(
              '* Pull incident by user_id',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32.0,),
            child: Listener(
              onPointerDown: (PointerEvent p) {
                setState(() {
                  btnAsset = 'assets/buttons/ic_emergency_pressed.png';
                });
              },
              onPointerUp: (PointerEvent p) {
                setState(() {
                  btnAsset = 'assets/buttons/ic_emergency.png';
                });
              },
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    DialogHelper.showReportButtons(context, widget.userVM, widget.token, _onReport);
                  },
                  child: Image.asset(
                    btnAsset,
                    height: 96.0,
                    width: 96.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget get _stateReport => Scaffold(
    backgroundColor: Colors.grey.shade300,
    body: SafeArea(
      child: Form(
        key: _formPageKey,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16.0,),
            padding: EdgeInsets.all(16.0,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                width: 1.0,
                color: Colors.white,
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Incident details',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colorPrimary,
                  ),
                ),
                vSpacer(h: 16.0,),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: 'Send Incident type, "',),
                      TextSpan(
                        text: '$type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: '"... please verify the location.',),
                    ],
                  ),
                ),
                vSpacer(h: 8.0,),
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
                      target: LatLng(0.0, 0.0),// TODO: change to initialLL
                    ),
                    markers: Set<Marker>.of(_markers.values),
                    onLongPress: (latlng) {
                      print('on Long Press: $latlng');
                      _addMarker(latlng);
                    },
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      new Factory<OneSequenceGestureRecognizer>(
                            () => new EagerGestureRecognizer(),
                      ),
                    ].toSet(),
                  ),
                ),
                vSpacer(h: 8.0,),
                TextFormField(
                  // key: Key('homeAddress'),
                  validator: (value) =>
                  value.isEmpty ? '* Home Address' : null,
                  controller: _reportAddressController,
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
                    hintText: 'Incident location',
                    errorStyle: TextStyle(
                      fontSize: 0.0,
                    ),
                    // errorText: _errHomeAdd,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  minLines: 1,
                  // onSaved: (String val) {
                  //   _homeAddress = val;
                  // },
                  onChanged: (String val) {
                    _reportAddress = val;
                  },
                ),
                vSpacer(h: 4.0,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Incident location',
                    style: TextStyle(
                      // fontSize: 12.0,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                vSpacer(h: 12.0,),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: colorPrimary,
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0,),
                  ),
                  onPressed: () {
                    if (_formPageKey.currentState.validate()) {
                      // TODO: send button
                    }
                    _reportIncident().then((value) {
                      // print('report - $value');
                      if (!value.contains('error')) {
                        setState(() {
                          state = 'activeIncident';
                        });
                      }
                    });
                  },
                  child: Container(
                    height: 48.0,
                    child: Center(
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 24.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                vSpacer(h: 8.0,),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0,),
                  ),
                  onPressed: () {
                    if (_formPageKey.currentState.validate()) {
                      // TODO: cancel button
                    }
                    setState(() {
                      state = 'noIncident';
                    });
                  },
                  child: Container(
                    height: 48.0,
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget get _stateActiveIncident => Scaffold(
    backgroundColor: Colors.grey.shade300,
    body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16.0,),
          padding: EdgeInsets.all(16.0,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              width: 1.0,
              color: Colors.white,
            ),
            color: Colors.white,
          ),
          child: Container(
            margin: EdgeInsets.all(16.0,),
            padding: EdgeInsets.all(4.0,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                width: 2.0,
                color: Colors.grey.shade300,
              ),
              color: Colors.grey.shade300,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // margin: EdgeInsets.all(16.0,),
                  padding: EdgeInsets.symmetric(vertical: 24.0,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                    // image: DecorationImage(
                    //   image: NetworkImage('$secretHollowsEndPoint/incidentGraphics/call.jpg'),
                    //   fit: BoxFit.contain,
                    // ),
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/loading.gif',
                        image: '$secretHollowsEndPoint/incidentGraphics/call.jpg',
                        fit: BoxFit.cover,
                        height: 200.0,
                        width: 200.0,
                      ),
                    ),
                  ),
                ),
                vSpacer(h: 6.0,),
                Container(
                  // margin: EdgeInsets.all(16.0,),
                  padding: EdgeInsets.symmetric(vertical: 16.0,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                        hSpacer(w: 56.0,),
                        Text(
                          'ETA: ',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                vSpacer(h: 6.0,),
                Container(
                  // margin: EdgeInsets.all(16.0,),
                  padding: EdgeInsets.symmetric(vertical: 16.0,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        hSpacer(w: 8.0,),
                        Image.asset(
                          iconAsset,
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.contain,
                        ),
                        hSpacer(w: 8.0,),
                        Flexible(
                          child: Text(
                            _reportAddress ?? 'Address/Location',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                vSpacer(h: 6.0,),
                Container(
                  // margin: EdgeInsets.all(16.0,),
                  padding: EdgeInsets.symmetric(vertical: 16.0,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                          child: GestureDetector(
                            onTapDown: (TapDownDetails d) {
                              // TODO: audio call button
                            },
                            child: Container(
                              width: 32.0,
                              height: 32.0,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.phone,
                                color: Colors.grey.shade300,
                                size: 16.0,
                              ),
                            ),
                          ),
                        ),
                        ClipOval(
                          child: GestureDetector(
                            onTapDown: (TapDownDetails d) {
                              // TODO: video call button
                            },
                            child: Container(
                              width: 32.0,
                              height: 32.0,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.video,
                                color: Colors.grey.shade300,
                                size: 16.0,
                              ),
                            ),
                          ),
                        ),
                        ClipOval(
                          child: GestureDetector(
                            onTapDown: (TapDownDetails d) {
                              // TODO: chat button
                            },
                            child: Container(
                              width: 32.0,
                              height: 32.0,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.solidComment,
                                color: Colors.grey.shade300,
                                size: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                vSpacer(h: 6.0,),
                Container(
                  // margin: EdgeInsets.all(16.0,),
                  padding: EdgeInsets.symmetric(vertical: 16.0,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      'Operation Center',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                vSpacer(h: 8.0,),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0,),
                  ),
                  onPressed: () {
                    // TODO: Cancel Report Button
                    setState(() {
                      state = 'noIncident';
                    });
                  },
                  child: Container(
                    height: 48.0,
                    child: Center(
                      child: Text(
                        'Cancel Report',
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Future<String> _reportIncident() async {
    var url = Uri.parse('$secretHollowsEndPoint/api/incident');
    Map data = {
      'user': widget.userVM == null ? widget.uVM.id : widget.userVM.id,
      "type": type,
      "scompleteaddress": _reportAddress,
      "scity": _city,
      "sstate": _stateAddress,
      "sarea": _area,
      "slat": lat,
      "slng": lng,
    };
    var reqBody = json.encode(data);
    var response = await http.post(
      url,
      headers: {
        'Cache-Control' : 'no-cache',
        // 'Postman-Token' : '<calculated when request is sent>',
        // 'Content-Length' : '<calculated when request is sent>',
        // 'Host' : '<calculated when request is sent>',
        'Accept' : '*/*',
        'Accept-Encoding' : 'gzip, deflate, br',
        'Connection' : 'keep-alive',
        'Content-Type': 'application/json',
        'x-auth-token': widget.token,
      },
      body: reqBody,
    );
    print('report r: $response X ${response.body}');
    // final body = jsonDecode(response.body);
    // return body["success"];
    return response.body;
  }
}
