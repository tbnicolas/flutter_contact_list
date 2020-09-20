import 'package:flutter/material.dart';
import 'package:flutter_contact_list/src/blocs/contact_bloc.dart';
import 'package:flutter_contact_list/src/blocs/provider.dart';
import 'package:flutter_contact_list/src/pages/editContact_page.dart';
import 'package:flutter_contact_list/src/util/screenArguments.dart';

class InfoPage extends StatefulWidget {
  static final String routeName = 'info';

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  //Size size;

  @override
  Widget build(BuildContext context) {
    //size = MediaQuery.of(context).size;
    //Inicliazamos para poder estar al tanto de los cambios que se le hagan
    //al Stream 
    ContactBloc contactBloc = Provider.contactBlocOf(context);
    return new SafeArea(
      child: new Scaffold(
        appBar: new AppBar(
          iconTheme: new IconThemeData(
            color: Color.fromRGBO(52, 54, 101, 1.0), //change your color here
          ),
          elevation: 0,
          backgroundColor: Color.fromRGBO(248, 248, 249, 1.0),
          flexibleSpace: new FlexibleSpaceBar(
            title: _crearEditarButton(context, contactBloc),
          ),
        ),
        body: new SingleChildScrollView(
          child: new Column(
            children: [
              _crearTop(contactBloc),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: _crearBottom(contactBloc),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearTop(ContactBloc contactBloc) {
    //En la parte del ClipRREct preguntamos si el ultimo valor del stream viene el url
    //Para decidir si se muestra la Foto o el Icono 
    return new Container(
      height: 321.4545454545455,
      width: double.infinity,
      color: Color.fromRGBO(248, 248, 249, 1.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: new Container(
              color: Colors.blueGrey,
              height: 120,
              width: 120,
              child: contactBloc.contactLastValue.photoUrl != null
                  ? new FadeInImage(
                      placeholder: new AssetImage('assets/image/loading.gif'),
                      image: new NetworkImage(
                          contactBloc.contactLastValue.photoUrl),
                      fit: BoxFit.cover,
                    )
                  : new Icon(
                      Icons.person,
                      size: 80,
                    ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: new Text(
              contactBloc.contactLastValue.nombre,
              style: new TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: _crearRow(),
          )
        ],
      ),
    );
  }

  Widget _crearRow() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _crearIcons(Icons.message, 'Mensaje'),
        _crearIcons(Icons.call, 'Llamar'),
        _crearIcons(Icons.videocam, 'WhatsApp'),
        _crearIcons(Icons.mail, 'Correo'),
      ],
    );
  }

  Widget _crearIcons(IconData iconData, String iconName) {
    return new Column(
      children: [
        new ClipRRect(
          borderRadius: new BorderRadius.circular(30),
          child: new Container(
            height: 50,
            width: 50,
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromRGBO(52, 54, 101, 1.0),
                  Color.fromRGBO(35, 37, 57, 1.0),
                ],
              ),
            ),
            child: new Icon(
              iconData,
              color: Colors.white,
            ),
          ),
        ),
        new SizedBox(
          height: 8.0,
        ),
        new Text(iconName)
      ],
    );
  }

  Widget _crearBottom(ContactBloc contactBloc) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _crearNumero(contactBloc),
        new Divider(
          thickness: 1.0,
        ),
        _crearListTile('Enviar Mensaje'),
        new Divider(
          thickness: 1.0,
        ),
        _crearListTile('Compartir Contacto'),
        new Divider(
          thickness: 1.0,
        ),
        _crearListTile('Agregar a Favoritos'),
        new Divider(
          thickness: 1.0,
        ),
        _crearListTile('Compartir mi Ubicación'),
      ],
    );
  }

  Widget _crearNumero(ContactBloc contactBloc) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: new Text(
            'Numero',
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        new ListTile(
          title: new Text(contactBloc.contactLastValue.numero),
        ),
      ],
    );
  }

  Widget _crearListTile(String texto) {
    return new ListTile(
      title: new Text(texto),
    );
  }

  Widget _crearEditarButton(BuildContext context, ContactBloc contactBloc) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        new GestureDetector(
          onTap: () {
            Navigator.popAndPushNamed(context, ContactPage.routeName,
                arguments:
                    new ScreenArguments(0, contactBloc.contactLastValue));
          },
          child: new Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: new Text(
              'Editar',
              style: new TextStyle(color: Color.fromRGBO(52, 54, 101, 1.0)),
            ),
          ),
        )
      ],
    );
  }
}
