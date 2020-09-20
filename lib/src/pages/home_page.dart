import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact_list/src/blocs/contact_bloc.dart';
import 'package:flutter_contact_list/src/blocs/provider.dart';
import 'package:flutter_contact_list/src/model/contac_model.dart';
import 'package:flutter_contact_list/src/pages/editContact_page.dart';
import 'package:flutter_contact_list/src/pages/info_page.dart';
import 'package:flutter_contact_list/src/provider/firebase_provider.dart';
import 'package:flutter_contact_list/src/util/screenArguments.dart';
import 'package:flutter_contact_list/src/util/search_delegate_utils.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firebaseUserProvider = new FirebaseUserProvider();
  @override
  Widget build(BuildContext context) {
    //Inicializamos el contactBloc envuelto en el provider para escuchar la informacion de las clases que 
    //Modifican el stream 
    final contactBloc = Provider.contactBlocOf(context);
    return new SafeArea(
      child: new Scaffold(
          body: _crearBody(contactBloc),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, ContactPage.routeName,
                  arguments: new ScreenArguments(
                      1,
                      ContactListModel.fromJson({
                        'nombre': '',
                        'numero': '',
                        'correo': '',
                        'id': '',
                        'photoUrl': null
                      })));
            },
            backgroundColor: Colors.pinkAccent,
            child: new Icon(Icons.add),
          )),
    );
  }

  Widget _crearBody(ContactBloc contactBloc) {
    return new StreamBuilder(
      stream: firebaseUserProvider.getAllContacts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return new CustomScrollView(
            slivers: <Widget>[
              _createAnimatedAppBar(context),
              _createSliverBody(
                  _obtenerList(snapshot.data.documents), contactBloc, context),
            ],
          );
        } else {
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _createAnimatedAppBar(BuildContext context) {
    final textoAppbar = new Text(
      'Contactos',
      style: new TextStyle(
          color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.w800),
      overflow: TextOverflow.ellipsis,
      //overflow: TextOverflow.ellipsis
    );

    return new SliverList(
        delegate: new SliverChildListDelegate([
      new Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          //color: Colors.lightBlue,
          alignment: Alignment.centerLeft,
          child: new Padding(
              padding: EdgeInsets.only(left: 15.0, top: 20),
              child: textoAppbar),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(52, 54, 101, 1.0),
                Color.fromRGBO(35, 37, 57, 1.0),
              ],
            ),
          ))
    ]));
  }

  Widget _createSliverBody(List dataList, ContactBloc contactBloc, BuildContext context) {
    final textoSearch = new Text(
      'A quien buscabas?',
      style: new TextStyle(
        color: Colors.black26,
        fontSize: 20.0,
      ),
      overflow: TextOverflow.ellipsis,
    );
    return new SliverStickyHeader(
      header: new GestureDetector(
        onTap: () {
          showSearch(context: context, delegate: new DataSearch());
        },
        child: new Container(
          height: 80.0,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(52, 54, 101, 1.0),
                Color.fromRGBO(35, 37, 57, 1.0),
              ],
            ),
          ),
          alignment: Alignment.centerLeft,
          child: new Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: new Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: new ListTile(
                  leading: new Icon(
                    Icons.search,
                    size: 40,
                  ),
                  title: textoSearch,
                ),
              ),
            ),
          ),
      ),
      sliver: new SliverList(
          delegate:
              new SliverChildBuilderDelegate((BuildContext context, int i) {
        return _crearListTile(dataList[i], contactBloc,i);
      }, childCount: dataList.length)),
    );
  }

  Widget _crearListTile(ContactListModel contact, ContactBloc contactBloc,int i) {
    return new GestureDetector(
      onTap: () {
        //Actualizamos el stream para que la clase Info Pueda usarlo dependiendo del contacto seleccionado
        contactBloc.updateContatc(contact);
        Navigator.pushNamed(context, InfoPage.routeName);
      },
      child: new FadeInLeft(
        delay: new Duration(milliseconds: 100*i),
        child: new Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: new Container(
            color: Colors.red,
            padding: EdgeInsets.only(right: 15),
            alignment: Alignment.centerRight,
            child: new Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 30,
            ),
          ),
          onDismissed: (direction) => firebaseUserProvider.deleteUser(contact.id),
          child: new ListTile(
            leading: contact.photoUrl != null
                ? new ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Container(
                    height: 40,
                    width: 40,
                    child: new FadeInImage(
                        placeholder: new AssetImage('assets/image/loading.gif'),
                        image:  new NetworkImage(contact.photoUrl),fit: BoxFit.cover,),
                  ),
                )
                : new Icon(Icons.person,size: 40,),
            title: new Text(contact.nombre),
            subtitle: new Text(contact.correo),
          ),
        ),
      ),
    );
  }
  //Transformamos la lista de QuerySnapshot de fireBase a una Lista de documentos
  //Esa lista de documentos la pasamos por nuestro constructor para que nos devuelva
  //Una lista de tipo Contact
  List _obtenerList(List list) {
    List<ContactListModel> listResp =
        list.map((e) => ContactListModel.fromJson(e.data())).toList();
    print(listResp);
    return listResp;
  }
}
