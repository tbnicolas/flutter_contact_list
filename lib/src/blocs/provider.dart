import 'package:flutter/material.dart';
import 'package:flutter_contact_list/src/blocs/contact_bloc.dart';
import 'package:flutter_contact_list/src/blocs/user_bloc.dart';
export 'user_bloc.dart';

class Provider extends InheritedWidget {
  final userBloc = new UserBloc();
  final contactBloc = new ContactBloc();

  static Provider _instancia;
//Modelo Singleton
  factory Provider({Key key, Widget child}) {
    //Si la instancia no esta creada, se crea
    //caso contrario se regresa la misma
    if (_instancia == null) {
      _instancia = new Provider._internal(
        key: key,
        child: child,
      );
    }
    return _instancia;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static UserBloc userBlocOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().userBloc;
  }

  static ContactBloc contactBlocOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().contactBloc;
  }
}
