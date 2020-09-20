import 'dart:io';

import 'package:flutter_contact_list/src/blocs/validators.dart';
import 'package:flutter_contact_list/src/provider/profileProvider.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _phoneNumberController = BehaviorSubject<String>();
  final _photoUrlController = BehaviorSubject<String>();
  final _userProvider           = new ProfileProvider();
  
// Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changePhoneNumber => _phoneNumberController.sink.add;
  Function(String) get changePhotoUrl => _photoUrlController.sink.add;


//Recuperar los datos del Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get nameStream =>
      _nameController.stream.transform(validarName);
  Stream<String> get phoneNumberStream =>
      _phoneNumberController.stream.transform(validarNumber);

//Combinamos los tres Streams(Email, PhoneNumber y Name) para poder mandar un resultado
  Stream<bool> get formValidStream => CombineLatestStream.combine3(
      emailStream, nameStream, phoneNumberStream, (e, n, p) => true);

//Obtener el ultimo valor agregado a los streams
  String get email => _emailController.value;
  String get name => _nameController.value;
  String get phoneNumber => _phoneNumberController.value;
  String get photoUrl => _photoUrlController.value;

//Subir Foto

  Future<String> subirFoto(File foto,String name, String uid, int tipo) async {
    print('String: $foto');
      final fotoUrl = await _userProvider.uploadFile(foto, name ,uid,tipo);
      return fotoUrl;
  }
//Cerramos los Streams
  dispose() {
    _emailController?.close();
    _nameController?.close();
    _phoneNumberController?.close();
    _photoUrlController?.close();
  }
}
