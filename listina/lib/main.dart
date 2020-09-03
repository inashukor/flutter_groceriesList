import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listina/models/place.dart';
import 'package:listina/services/geolocator_service.dart';
import 'package:listina/services/place_service.dart';
import 'package:listina/views/first_view.dart';
import 'package:listina/views/navigation_view.dart';
import 'package:listina/views/sign_up_view.dart';
import 'package:listina/services/auth_service.dart';
import 'package:listina/widgets/provider_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_messaging/firebase_messaging.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(create: (context) => locatorService.getLocation()),
        FutureProvider(create: (context){
          ImageConfiguration configuration = createLocalImageConfiguration(context);
          return BitmapDescriptor.fromAssetImage(configuration, 'assets/img/shoppingcart_icon.png');
        },),
        ProxyProvider2<Position,BitmapDescriptor,Future<List<Place>>>(
          update: (context,position,icon,places){
            return (position !=null) ? placesService.getPlaces(position.latitude, position.longitude, icon) : null;
          },
        )
      ],
      child: Provide(
        auth: AuthService(),
        db: Firestore.instance,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            textTheme: TextTheme(
                body1: GoogleFonts.bitter(fontSize: 14.0)
            ),
          ),
          home: HomeController(),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => HomeController(),
            '/signUp': (BuildContext context) => SignUpView(authFormType: AuthFormType.signUp),
            '/signIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.signIn),
//          '/anonymousSignIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.anonymous),
//          '/convertUser': (BuildContext context) => SignUpView(authFormType: AuthFormType.convert),
          },
        ),
      ),

    );
  }
}

class HomeController extends StatefulWidget {
  HomeController({Key key}) : super(key: key);

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  ///////////////////////notification permission/////////////////

  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
      _fcm.onIosSettingsRegistered.listen((event) {
        print("IOS Registered");
      });
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        //when in the app and notification is received
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        // when launch app after a notification received
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        // when open the app after a notification received AND
        //app was running in the background
        print("onResume: $message");
      },
    );
  }


  ////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provide.of(context).auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? Home() : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}



