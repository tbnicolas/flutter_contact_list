import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contact_list/src/blocs/contact_bloc.dart';
import 'package:flutter_contact_list/src/blocs/provider.dart';
import 'package:flutter_contact_list/src/blocs/user_bloc.dart';
import 'package:flutter_contact_list/src/model/contac_model.dart';
import 'package:flutter_contact_list/src/pages/info_page.dart';
import 'package:flutter_contact_list/src/provider/firebase_provider.dart';
import 'package:flutter_contact_list/src/util/screenArguments.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  static final String routeName = 'editContact';

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final firebaseUser = new FirebaseUserProvider();
  ContactBloc contactBloc;
  ScreenArguments args;
  File foto;
  UserBloc bloc;
  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    //Recibiremos los argumentos de las state class 'Home' e 'Info'
    args = ModalRoute.of(context).settings.arguments;
    //Utilizaremos el patron bloc antes creado, para tener un mejor manejo de los textFields
    bloc = new UserBloc();
    //Utilizaremos el patron bloc, pero esta vez envuelto en el provider para que cualquier en el arbol 
    //pueda escuchar, en nuestro caso la state class info
    contactBloc = Provider.contactBlocOf(context);
    //Asignaremos si viene de la state class info, es decir que viene con informacion
    //por lo cual la cargaremos en nuestro bloc, para que se dibuje los datos existentes 
    if (args.tipo == 0) {
      bloc.changeEmail(args.contactListModel.correo);
      bloc.changeName(args.contactListModel.nombre);
      bloc.changePhoneNumber(args.contactListModel.numero);
    }
    return new Scaffold(
      appBar: new AppBar(
        flexibleSpace: new Container(
            decoration: new BoxDecoration(
          gradient: new LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(52, 54, 101, 1.0),
                Color.fromRGBO(35, 37, 57, 1.0),
              ],
            ),
        )),
      ),
      body: new SingleChildScrollView(
        child: new Center(
          child: new Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              _mostrarFoto(),
              SizedBox(
                height: 50.0,
              ),
              _crearNumber(bloc),
              SizedBox(
                height: 50.0,
              ),
              _crearName(bloc),
              SizedBox(
                height: 50.0,
              ),
              _crearEmail(bloc),
              SizedBox(
                height: 50.0,
              ),
              _crearBoton(bloc, context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _mostrarFoto() {
    //Preguntamos si esta nulo para saber que imagen mostrar 
    if (args.contactListModel.photoUrl != null) {
      
      return new GestureDetector(
          onTap: _tomarFoto,
          child: new ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: new Container(
              height: 150,
              width: 150,
              child:new FadeInImage(
                      placeholder: new AssetImage('assets/image/loading.gif'),
                      image: new NetworkImage(
                          contactBloc.contactLastValue.photoUrl),
                      fit: BoxFit.cover,
                    ),
            ),
          ));
    } else {
      //Si entra en el if, significa que el usuario tomo la foto 
      if (foto != null) {
       
        return new GestureDetector(
          onTap: _tomarFoto,
          child: new Material(
            child: Image.file(
              foto,
              fit: BoxFit.cover,
              height: 150,
              width: 150,
            ),
            borderRadius: BorderRadius.all(Radius.circular(90)),
            clipBehavior: Clip.hardEdge,
          ),
        );
      }
      //En este caso el usuario no decidio agregar foto o es primera vez que va a guardar un contacto 
      return new GestureDetector(
        onTap: _tomarFoto,
        child: new CircleAvatar(
          radius: 50,
          child: new Icon(
            Icons.person_add,
            size: 50,
          ),
        ),
      );
    }
  }

  Widget _crearEmail(UserBloc bloc) {
    return new StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return new Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: new TextFormField(
              initialValue: args.contactListModel.correo,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  icon: new Icon(
                    Icons.alternate_email,
                    color: Color.fromRGBO(52, 54, 101, 1.0),
                  ),
                  hintText: 'ejemplo@correo.com',
                  labelText: 'Correo electronico',
                  counterText: snapshot.data,
                  errorText: snapshot.error),
              //El primer argumento del onChange(value) sera trasladado  a mi primer argumento del changeEmail
              onChanged: bloc.changeEmail,
            ),
          );
        });
  }

  Widget _crearName(UserBloc bloc) {
    return new StreamBuilder(
        stream: bloc.nameStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return new Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: new TextFormField(
              initialValue: args.contactListModel.nombre,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  icon: new Icon(
                    Icons.person,
                    color: Color.fromRGBO(52, 54, 101, 1.0),
                  ),
                  labelText: 'Nombre',
                  errorText: snapshot.error),
              //El primer argumento del onChange(value) sera trasladado  a mi primer argumento del changeName
              onChanged: bloc.changeName,
            ),
          );
        });
  }

  Widget _crearNumber(UserBloc bloc) {
    return new StreamBuilder(
        stream: bloc.phoneNumberStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return new Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: new TextFormField(
              initialValue: args.contactListModel.numero,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  icon: new Icon(
                    Icons.phone,
                    color: Color.fromRGBO(52, 54, 101, 1.0),
                  ),
                  labelText: 'Numero',
                  // counterText: snapshot.data,
                  errorText: snapshot.error),
              //El primer argumento del onChange(value) sera trasladado  a mi primer argumento del changePhoneNumber
              onChanged: bloc.changePhoneNumber,
            ),
          );
        });
  }

  Widget _crearBoton(UserBloc bloc, BuildContext context) {
    return new StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return new RaisedButton(
            child: new Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: new Text('Guardar'),
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.0,
            color: Colors.pinkAccent,
            textColor: Colors.white,
            onPressed: snapshot.hasData && !_guardando? () => _submit(bloc, context) : null,
          );
        });
  }
  
  //Se pasa procesar imagen por una funcion, por si mas adelante se desea pasar otro tipo de fuente
  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource fuente) async {
    final picker = new ImagePicker();
    var pickedFile = await picker.getImage(source: fuente);
    foto = File(pickedFile.path);
    //Aqui preguntamos si es null Porque quiere decir que el usuario va a cambiar o asignar una foto
    //Por lo cual como no viene precargada necesitamos asignarle null para que entre en el segundo condicional
    //Y asignar la foto no como un NetworImage ya que aun no se sube sino como un file 
    if (foto != null) {
      args.contactListModel.photoUrl = null;
    }
    setState(() {});
  }

  _submit(UserBloc bloc, BuildContext context) async {
    try {
      setState(() {
        _guardando = true; 
      });
      //Aqui pregunto si es tipo 1 para saber si viene de la state class Home
      if (args.tipo == 1) {
        final date = DateTime.now().millisecondsSinceEpoch.toString();
        String respUrl;
        //Ya que sabemos que viene de la state class Home se lo mandamos a la funcion
        //Siempre y cuando el usuario haya seleccionado una foto
        //Esto para indicarle que solo tiene que regrsarnos el link del FireBase Storage 
        if (foto != null) {
          respUrl = await bloc.subirFoto(foto, bloc.name, date, 1);
        }
        //Si nos regresan el link de Firebase se lo pasamos a la constructor
        //Caso contrario Se manda null ya que 'respUrl' no esta inicializada
        //Lo cual le indica que pasa el return por 'default' de mostrarFoto()
        final contactResp = ContactListModel.fromJson({
          'correo': bloc.email,
          'nombre': bloc.name,
          'numero': bloc.phoneNumber,
          'id': date,
          'photoUrl': respUrl
        });

        await firebaseUser.addUser(contactResp);
        Navigator.pop(context);
      } else {
        //Si entra en el 'else' quiere decir que la informacion viene
        //De la state Class info
        String respUrl;
        //Le asignamos 0 a la funcion para indicarle que va hacerle un update
        //Con base al id mandado 
        //Todo siempre y cuando el usuario elija una foto
        if (foto != null) {
          respUrl = await bloc.subirFoto(
              foto, bloc.name, args.contactListModel.id, 0);
          setState(() {});
        } else {
          //Le dejamos la foto con la cual venia
          respUrl = args.contactListModel.photoUrl;
        }
        final contactResp = ContactListModel.fromJson({
          'correo': bloc.email,
          'nombre': bloc.name,
          'numero': bloc.phoneNumber,
          'id': args.contactListModel.id,
          'photoUrl': respUrl
        });
        //Metemos en el flujo informcion de tipo ContactModel para que todas las clases puedan escuchar esa info
        contactBloc.updateContatc(contactResp);
        await firebaseUser.updateUser(args.contactListModel.id, contactResp);
        Navigator.popAndPushNamed(context, InfoPage.routeName);
      }
    } catch (e) {
      print('Entro error');
      print('Error: $e');
    }
  }
}
