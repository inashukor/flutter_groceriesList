import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mecommerce/model/place.dart';
import 'package:mecommerce/screen/menu.dart';
import 'package:mecommerce/services/geolocator_service.dart';
import 'package:mecommerce/services/place_service.dart';
import 'package:provider/provider.dart';

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Menu(),
      ),
    );
  }
}
