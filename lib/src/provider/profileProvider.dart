import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileProvider{

  //Usamos el Storage Para Almacenar la imagen tomada y luego mandamos el link para: 
  //1.Guardar en la base de datos
  //2.Poder acceder a ella con facilidad 
Future<String> uploadFile(File imageFile, String name, String uid, int tipo) async {
    print('ENtro pProvider');
    String fileName = 'PROFILE:$name ${DateTime.now().millisecondsSinceEpoch.toString()}';
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    final linkFirebase =  await storageTaskSnapshot.ref.getDownloadURL();
    if (tipo == 0){
      await FirebaseFirestore.instance.collection('contactList').doc(uid).update({'photoUrl':linkFirebase});
    }
    print('LinkFirebase: $linkFirebase');
    return linkFirebase;
  }

}