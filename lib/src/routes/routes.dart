import 'package:flutter/material.dart';
import 'package:flutter_contact_list/src/pages/editContact_page.dart';
import 'package:flutter_contact_list/src/pages/home_page.dart';
import 'package:flutter_contact_list/src/pages/info_page.dart';

Map<String,WidgetBuilder> getRoutes(){
 return<String, WidgetBuilder>{
   '/':(BuildContext context)=> new HomePage(),
   InfoPage.routeName:(BuildContext context)=> new InfoPage(),
   ContactPage.routeName:(BuildContext context)=> new ContactPage(),
 };
}