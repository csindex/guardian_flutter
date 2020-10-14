import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:provider/provider.dart';
import './navigation/main-nav/splash-screen.dart';
import './provider/viewmodel-notification-list.dart';
import './news-feed.dart';
import './utils/app-initializer.dart';
import './utils/dependency-injection.dart';

Injector injector;

void main() async {
  DependencyInjection().initialise(Injector.getInjector());
  injector = Injector.getInjector();
  await AppInitializer().initialise(injector);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NotificationListViewModel(),
          child: NewsFeed(),
        ),
      ],
      child: MainApp(),
    ),
  );
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
