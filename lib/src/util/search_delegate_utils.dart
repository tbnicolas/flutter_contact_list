import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact_list/src/blocs/provider.dart';
import 'package:flutter_contact_list/src/model/contac_model.dart';
import 'package:flutter_contact_list/src/pages/info_page.dart';

class DataSearch extends SearchDelegate {
  /* @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }
 */

  String seleccion = '';
  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro Appbar( Ejmplo poder limpiarlo o cancelar la busqueda)
    return [
      new IconButton(
          icon: new Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Es un Widget que aparece al izquierda del Appbar
    return new IconButton(
        icon: new AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final contactBloc = Provider.contactBlocOf(context);

    // Crea los resultados que vamos a mostrar
    if (query.isEmpty) {
      return new Container();
    }
    return new StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('contactList')
            .where("nombre", isEqualTo: query)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final listaContacto = snapshot.data.docs;
            return new ListView(
              children: listaContacto.map((contacto) {
                return new ListTile(
                  leading: new ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: new Container(
                      //color: Colors.blueGrey,
                      height: 50,
                      width: 50,
                      child: contacto.data()['photoUrl'] != null
                          ? new FadeInImage(
                              placeholder:
                                  new AssetImage('assets/image/no-image.jpg'),
                              image: new NetworkImage(
                                  contacto.data()['photoUrl']),
                              fit: BoxFit.cover,
                            )
                          : new Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                    ),
                  ),
                  title: new Text(contacto.data()['nombre']),
                  subtitle: new Text(contacto.data()['correo']),
                  onTap: () {
                    close(context, null);
                    contactBloc.updateContatc(
                        ContactListModel.fromJson(contacto.data()));
                    Navigator.pushNamed(context, InfoPage.routeName);
                  },
                );
              }).toList(),
            );
          } else {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final contactBloc = Provider.contactBlocOf(context);
    if (query.isEmpty) {
      return new Container();
    }
    return new StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('contactList')
            .where("nombre", isEqualTo: query)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final listaContactos = snapshot.data.docs;
            return new ListView(
              children: listaContactos.map((contacto) {
                return new ListTile(
                  leading: new ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: new Container(
                      //color: Colors.blueGrey,
                      height: 50,
                      width: 50,
                      child: contacto.data()['photoUrl'] != null
                          ? new FadeInImage(
                              placeholder:
                                  new AssetImage('assets/image/no-image.jpg'),
                              image: new NetworkImage(
                                  contacto.data()['photoUrl']),
                              fit: BoxFit.cover,
                            )
                          : new Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                    ),
                  ),
                  title: new Text(contacto.data()['nombre']),
                  subtitle: new Text(contacto.data()['correo']),
                  onTap: () {
                    close(context, null);
                    contactBloc.updateContatc(
                        ContactListModel.fromJson(contacto.data()));
                    Navigator.pushNamed(context, InfoPage.routeName);
                  },
                );
              }).toList(),
            );
          } else {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
        });
  }
}
