// import 'package:custom_map_markers/custom_map_markers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class ChangeAddressView extends StatefulWidget {
  const ChangeAddressView({super.key});

  @override
  State<ChangeAddressView> createState() => _ChangeAddressViewState();
}

class _ChangeAddressViewState extends State<ChangeAddressView> {
  // GoogleMapController? _controller;

  // final locations = const [
  //   LatLng(37.42796133580664, -122.085749655962),
  // ];

  // late List<MarkerData> _customMarkers;

  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.42796133580664, -122.085749655962),
  //     // tilt: 59.440717697143555,
  //     zoom: 14.151926040649414);

  // @override
  // void initState() {
  //   super.initState();
  //   _customMarkers = [
  //     MarkerData(
  //         marker:
  //             Marker(markerId: const MarkerId('id-1'), position: locations[0]),
  //         child: _customMarker('Everywhere\nis a Widgets', Colors.blue)),
  //   ];
  // }

  // _customMarker(String symbol, Color color) {
  //   return SizedBox(
  //     width: 100,
  //     child: Column(
  //       children: [
  //         Image.asset(
  //           'assets/img/map_pin.png',
  //           width: 35,
  //           fit: BoxFit.contain,
  //         )
  //       ],
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: TColor.white,
  //       leading: IconButton(
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         icon: Image.asset("assets/img/btn_back.png", width: 20, height: 20),
  //       ),
  //       centerTitle: false,
  //       title: Text(
  //         "Change Address",
  //         style: TextStyle(
  //             color: TColor.primaryText,
  //             fontSize: 20,
  //             fontWeight: FontWeight.w800),
  //       ),
  //     ),
  //     body: CustomGoogleMapMarkerBuilder(
  //       //screenshotDelay: const Duration(seconds: 4),
  //       customMarkers: _customMarkers,
  //       builder: (BuildContext context, Set<Marker>? markers) {
  //         if (markers == null) {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //         return GoogleMap(
  //           mapType: MapType.normal,
  //           initialCameraPosition: _kLake,
  //           compassEnabled: false,
  //           gestureRecognizers: Set()
  //             ..add(Factory<PanGestureRecognizer>(
  //               () => PanGestureRecognizer(),
  //             )),
  //           markers: markers,
  //           onMapCreated: (GoogleMapController controller) {
  //             _controller = controller;
  //           },
  //         );
  //       },
  //     ),
  //     bottomNavigationBar: BottomAppBar(
  //         child: SafeArea(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric( vertical: 15 , horizontal: 25),
  //           child: RoundTextfield(
  //             hintText: "Search Address",
  //             left: Icon(Icons.search, color: TColor.primaryText),
  //           ),
  //         ),

  //         Padding(
  //           padding: const EdgeInsets.symmetric( horizontal: 25),
  //           child: Row(children: [

  //             Image.asset('assets/img/fav_icon.png', width: 35, height: 35 ), 

  //             const SizedBox(width: 8,),

  //             Expanded(
  //               child: Text(
  //                 "Choose a saved place",
  //                 style: TextStyle(
  //                     color: TColor.primaryText,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w600),
  //               ),
  //             ),

  //             Image.asset('assets/img/btn_next.png', width: 15, height: 15, color: TColor.primaryText, )

  //           ]),
  //         ),


  //       ],
  //     ))),
  //   );
  // }

  GoogleMapController? mapController;
  LatLng? _selectedLocation;
  String _detailLocation = "";

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      print("Location permission denied");
    } else if (permission == LocationPermission.deniedForever) {
      print("Location permission denied forever");
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = [];

      placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // print("Latitudeee : ${position.latitude}, Longitudeee : ${position.longitude}");
      // print(placemarks);

      if (placemarks.isNotEmpty) {
        setState(() {
          Placemark place = placemarks[0];
          _detailLocation = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}";
        });
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
    }
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // print(
      //     "Latitude : ${position.latitude}, Longitude : ${position.longitude}");

      setState(() async {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        await _getAddressFromLatLng(_selectedLocation!);
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: TColor.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset("assets/img/btn_back.png", width: 20, height: 20),
            ),
            centerTitle: false,
            title: Text(
              "Change Address",
              style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
          ),
          body: Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (controller) {
                mapController = controller;
              },
              onTap: (latLng) async {
                setState(() {
                  _selectedLocation = latLng;
                });
                await _getAddressFromLatLng(latLng);
              },
              markers: _selectedLocation != null
                  ? {
                Marker(
                    markerId: const MarkerId('selectedLocation'),
                    position: _selectedLocation!,
                    infoWindow: InfoWindow(
                      title: 'Your Location',
                      snippet:
                      'Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}',
                    ))
              }
                  : {},
              initialCameraPosition: CameraPosition(
                  target: _selectedLocation ?? const LatLng(0, 0), zoom: 15),
              myLocationEnabled: true,
            ),
          ),
        );
    // return AlertDialog(
    //   contentPadding: EdgeInsets.all(0),
    //   content: SizedBox(
    //     width: double.maxFinite,
    //     height: MediaQuery.of(context).size.height * 0.8,
    //     child: Column(
    //       children: [
    //         Expanded(
    //           child: GoogleMap(
    //             mapType: MapType.normal,
    //             onMapCreated: (controller) {
    //               mapController = controller;
    //             },
    //             onTap: (latLng) async {
    //               setState(() {
    //                 _selectedLocation = latLng;
    //               });
    //               await _getAddressFromLatLng(latLng);
    //             },
    //             markers: _selectedLocation != null
    //                 ? {
    //                     Marker(
    //                         markerId: const MarkerId('selectedLocation'),
    //                         position: _selectedLocation!,
    //                         infoWindow: InfoWindow(
    //                           title: 'Your Location',
    //                           snippet:
    //                               'Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}',
    //                         ))
    //                   }
    //                 : {},
    //             initialCameraPosition: CameraPosition(
    //                 target: _selectedLocation ?? const LatLng(0, 0), zoom: 15),
    //             myLocationEnabled: true,
    //           ),
    //         ),
    //         Container(
    //           width: 300,
    //           margin: EdgeInsets.all(10),
    //           child: ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               backgroundColor: Colors.orange[800],
    //             ),
    //             onPressed: () async {
    //               if (_selectedLocation != null) {
    //                 print(
    //                     "Selected Location - Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation}");
    //                 Navigator.pop(context);
    //                 // widget.onLocationSelected?.call(_selectedLocation!, _detailLocation);
    //                 print(_detailLocation);
    //               } else {
    //                 // handle case where no location is selected
    //               }
    //             },
    //             child: Text(
    //               "Select this location",
    //               style: TextStyle(
    //                 color: Colors.orange[800]
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
