import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';

import '../../utils/constants/utils.dart';


class SelectAddress extends StatefulWidget {
  final ValueChanged<AddressLatLng> onAddressSelected;
  final LatLng initialLL;

  SelectAddress({this.onAddressSelected, this.initialLL});

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  GoogleMapController _mapController;
  LatLng _defaultLL = LatLng(0.0, 0.0);
  final Map<String, Marker> _markers = {};
  String address;
  double lat, lng;
  GoogleGeocoding _googleGeocoder;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
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

  @override
  void initState() {
    super.initState();
    _googleGeocoder = GoogleGeocoding(gMAK);
    if (widget.initialLL == _defaultLL) {
      _determinePosition().then((value) {
        var lat = value.latitude;
        var lng = value.longitude;
        _addMarker(LatLng(lat, lng));
      });
    } else {
      _addMarker(widget.initialLL);
    }
  }

  void _addMarker(LatLng latlng) {
    lat = latlng.latitude;
    lng = latlng.longitude;
    _getAddress(LatLon(lat, lng)).then((value) async {
      print('address($lat, $lng)');
      final MarkerId markerId = MarkerId('selectedLocation');
      await setState(() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            trafficEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: widget.initialLL,
            ),
            markers: Set<Marker>.of(_markers.values),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 72.0),
              child: RaisedButton(
                color: colorPrimary,
                child: Container(
                  width: double.infinity,
                  height: 48.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Select Address',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                onPressed: () async {
                  widget.onAddressSelected(AddressLatLng(
                    address: address, lat: lat, lng: lng));
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              margin: EdgeInsets.only(top: 56.0),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Selected Address',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 3.5, ),
                  Container(
                    color: Colors.grey,
                    height: 1.0,
                    width: 256.0,
                  ),
                  SizedBox(height: 3.5, ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      address ?? '',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
