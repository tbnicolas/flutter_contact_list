import 'package:flutter_contact_list/src/model/contac_model.dart';
import 'package:rxdart/rxdart.dart';


class ContactBloc {
final _contactController = BehaviorSubject<ContactListModel>();
// Insertar valores al Stream
  Function(ContactListModel) get updateContatc => _contactController.sink.add;
//Recuperar los datos del Stream
  Stream<ContactListModel> get contactStream => _contactController.stream;
//Obtenemos el ultimo valor del stream  
  ContactListModel get contactLastValue => _contactController.value;
  dispose() {
    _contactController?.close();
  }
}