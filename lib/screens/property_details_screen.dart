import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final String propertyId;

  PropertyDetailsScreen({required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('properties').doc(propertyId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final property = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: Text(property['title'])),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(property['imageUrl']),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(property['description']),
                ),
                Text('Price: \$${property['price']}'),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Location: ${property['location']}'),
                ),
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(property['location'].latitude, property['location'].longitude),
                      zoom: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
