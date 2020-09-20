import 'dart:convert';

ContactListModel contactListModelFromJson(String str) => ContactListModel.fromJson(json.decode(str));

String contactListModelToJson(ContactListModel data) => json.encode(data.toJson());

class ContactListModel {
    ContactListModel({
        this.numero ,
        this.nombre ,
        this.correo,
        this.id,
        this.photoUrl 
    });

    String numero;
    String nombre;
    String correo;
    String id;
    String photoUrl;
    
    //Arroja el modelo apartir de un Mapa
    factory ContactListModel.fromJson(Map<String, dynamic> json) => ContactListModel(
        numero  : json["numero"],
        nombre  : json["nombre"],
        correo  : json["correo"],
        id      : json['id'],
        photoUrl: json['photoUrl']
    );
    //Se utilizara cuando Tengamos el modelo inicializado y queramos convertirlo a un Mapa
    Map<String, dynamic> toJson() => {
        "numero": numero,
        "nombre": nombre,
        "correo": correo,
        "id"    : id,
        "photoUrl": photoUrl
    };
}