import 'package:GUARDIAN/utils/helpers/dialog-helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../utils/constants/utils.dart';

class Special extends StatefulWidget {

  const Special({
    Key key,

    /// If set, enable the FusedLocationProvider on Android
    @required this.androidFusedLocation,
  }) : super(key: key);

  final bool androidFusedLocation;

  @override
  State<StatefulWidget> createState() => _SpecialState();

}

class _SpecialState extends State<Special> {

  MapboxMapController mapController;

//  Position _lastKnownLocation;
  Position _currentLocation;

//  CameraPosition _cameraPosition;
//  bool _isMoving = false;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
//    mapController.addListener(_onMapChanged);
//    _extractMapInfo();
    double lat = _currentLocation.latitude;
    double lng = _currentLocation.longitude;
    setState(() {
      print('sud ari? $_currentLocation');
      mapController.addSymbol(
        SymbolOptions(
          iconImage: 'assets/images/chibi-lelouch.jpg',
          iconSize: 0.1,
          geometry: LatLng(lat, lng),
        ),
      );
      mapController.moveCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), 11.0,),
        /*CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 270.0,
            target: LatLng(lat, lng),
            tilt: 30.0,
            zoom: 17.0,
          ),
        ),*/
      );
    });
  }

//  void _onMapChanged() {
//    setState(() {
//      _extractMapInfo();
//    });
//  }

//  @override
//  void dispose() {
//    if (mapController != null) {
//      mapController.removeListener(_onMapChanged);
//    }
//    super.dispose();
//  }

//  void _extractMapInfo() {
//    _cameraPosition = mapController.cameraPosition;
//    _isMoving = mapController.isCameraMoving;
//  }

  @override
  void initState() {
    super.initState();
    _initLastKnownLocation();
    _initCurrentLocation();
    print('initState');
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
//      _lastKnownLocation = null;
      _currentLocation = null;
    });

    _initLastKnownLocation().then((_) => _initCurrentLocation());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initLastKnownLocation() async {
    Position location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = !widget.androidFusedLocation;
      location = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
      print('location: $location');
    } on PlatformException {
      print('exception');
      location = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
//    setState(() {
//      _lastKnownLocation = location;
//    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = !widget.androidFusedLocation
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ).then((position) {
        print('current location = $position');
        if (mounted) {
          setState(() {
            _currentLocation = position;
          });
        }
      }).catchError((e) {
        print('exception - $e');
      });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeolocationStatus>(
      future: Geolocator().checkGeolocationPermissionStatus(),
      builder: (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
        if (!snapshot.hasData) {
          print('Snapshot? \n$snapshot');
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == GeolocationStatus.denied) {
          return const PlaceholderWidget(
              'Access to location denied',
              'Allow access to the location services for this App using the device settings.'
          );
        }
        return Stack(
          children: <Widget>[
            MapboxMap(
              onMapCreated: _onMapCreated,
              trackCameraPosition: true,
              initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0)),
//              styleString: 'mapbox://styles/scorpionmonkey/ckbj2pmw522191is3o7amye59',
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
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
                                  children: <Widget>[
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
                                DialogHelper.sendReport(context, 'Subangdaku, Mandaue City', 'Fire');
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
                                  children: <Widget>[
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
                                DialogHelper.sendReport(context, 'Subangdaku, Mandaue City', 'Medical');
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
                    children: <Widget>[
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
                                  children: <Widget>[
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
                                DialogHelper.sendReport(context, 'Subangdaku, Mandaue City', 'Crime');
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
                                  children: <Widget>[
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
                                DialogHelper.sendReport(context, 'Subangdaku, Mandaue City', 'General');
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
                                children: <Widget>[
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
                          onTap: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

}
