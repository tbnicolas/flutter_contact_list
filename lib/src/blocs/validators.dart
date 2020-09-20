import 'dart:async';

class Validators{

  //Validar Email atravez de una expresion regular
  final validarEmail = new StreamTransformer<String,String>.fromHandlers(
      handleData: (email, sink){

        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = new RegExp(pattern);

        if(regExp.hasMatch(email)){
          sink.add(email);
        }else{
          sink.addError('Formato email no correcto');
        }

      }
  );
  //Validar el nombre con base a su tamaño
  final validarName = new StreamTransformer<String,String>.fromHandlers(
    handleData: (name, sink){
      if(name.length>=1){
        sink.add(name);
      }else{
        sink.addError('Más de 1 caracter por favor');
      }
    }
  );
  //Validar el numero con base a su tamaño
 final validarNumber = new StreamTransformer<String,String>.fromHandlers(
    handleData: (number, sink){
      if(number.length>=10){
        sink.add(number);
      }else{
        sink.addError('Numero de 10 caracteres por favor');
      }
    }
  );
}