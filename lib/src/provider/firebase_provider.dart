

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contact_list/src/model/contac_model.dart';

class FirebaseUserProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //READ
  //Mandamos a pedir todos los contactos de la base de DAtos
  Stream getAllContacts () {
   return  _db.collection('contactList').snapshots();
  }
  //Insert
  //Añadimos un usuario a la base de Datos
  Future addUser(ContactListModel userData) async{
   return await  _db.collection('contactList').doc(userData.id).set(userData.toJson());
  }
  //Update
  //Actualizamos la info en la base de Datos
  Future updateUser(String docId, ContactListModel userData) async{
    _db.collection('contactList').doc(docId).update(userData.toJson());
  }
  //Delete
  //Borramos Informacion(EL Contacto) de La base de Datos con base al ID proporcionado
  Future deleteUser(String uid) {
  return  _db.collection('contactList')
    .doc(uid)
    .delete();
}
}