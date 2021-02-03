import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import './navigation/main-nav/splash-screen.dart';
import './provider/viewmodel-notification-list.dart';
import './provider/posts/viewmodel-posts-list.dart';
import './widgets/posts/list-posts.dart';
import './news-feed.dart';
import './utils/app-initializer.dart';
import './utils/dependency-injection.dart';

Injector injector;

void main() async {
  DependencyInjection().initialise(Injector());
  injector = Injector();
  await AppInitializer().initialise(injector);
  // runZoned(() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NotificationListViewModel(),
          child: NewsFeed(),
        ),
        ChangeNotifierProvider(
          create: (context) => PostsListViewModel(),
          child: PostsList(),
        ),
      ],
      child: MainApp(),
    ),
  );
  // }, onError: (dynamic error, dynamic stack) {
  //   print(error);
  //   print(stack);
  // });

  Directory dir = await getExternalStorageDirectory();
  Hive.init(dir.path);

  /*var box = */ await Hive.openBox('user_db');
}

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GUARDIAN',
      debugShowCheckedModeBanner: false,
//      theme: ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
//        primarySwatch: Colors.blue,
      // This makes the visual density adapt to the platform that you run
      // the app on. For desktop platforms, the controls will be smaller and
      // closer together (more dense) than on mobile platforms.
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
      home: SplashScreen(),
    );
  }
}

// void main() => runApp(MainApp());
//
// class MainApp extends StatefulWidget {
//   @override
//   _MainAppState createState() => _MainAppState();
// }
//
// class _MainAppState extends State<MainApp> {
//   GoogleMapController _mapController;
//
//   LatLng _center = LatLng(45.521563, -122.677433);
//
//   final Map<String, Marker> _markers = {};
//
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }
//
//   Position _pos;
//
//   /// Determine the current position of the device.
//   ///
//   /// When the location services are not enabled or permissions
//   /// are denied the `Future` will return an error.
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permantly denied, we cannot request permissions.');
//     }
//
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.whileInUse &&
//           permission != LocationPermission.always) {
//         return Future.error(
//             'Location permissions are denied (actual value: $permission).');
//       }
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _determinePosition().then((value) {
//       _pos = value;
//       _center = LatLng(_pos.latitude, _pos.longitude);
//       final MarkerId markerId = MarkerId('My Location');
//
//       // creating a new MARKER
//       final Marker marker = Marker(
//         markerId: markerId,
//         position: _center,
//         infoWindow: InfoWindow(title: 'My Location', snippet: '*'),
//         onTap: () {
//           // _onMarkerTapped(markerId);
//         },
//       );
//       setState(() {
//         _markers['My Location'] = marker;
//         _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _center, zoom:16.0)));
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Maps Sample App'),
//           backgroundColor: Colors.green[700],
//         ),
//         body: GoogleMap(
//           onMapCreated: _onMapCreated,
//           initialCameraPosition: CameraPosition(
//             target: _center,
//             zoom: 11.0,
//           ),
//           markers: Set<Marker>.of(_markers.values),
//         ),
//       ),
//     );
//   }
// }
