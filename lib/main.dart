import 'package:flutter/material.dart';
import 'package:flutter_contact_list/src/blocs/provider.dart';
import 'package:flutter_contact_list/src/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //FirebaseUserProvider firebaseUserProvider = new FirebaseUserProvider();
    return new FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        // Una vez completada, muestra Aplicacion
        if (snapshot.connectionState == ConnectionState.done) {
          return new Provider(
            child: new MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Contact List',
              routes: getRoutes(),
            ),
          );
        }

        // Otro caso, cargar loading
        return new Center(
          child: new CircularProgressIndicator(),
        );
      },
    );
  }
}
