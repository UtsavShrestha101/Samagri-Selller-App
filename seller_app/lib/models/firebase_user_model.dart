import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserModel {
  final String uid;
  final String email;
  final String name;
  final String AddedOn;
  final String password;
  final String imageUrl;
  final String phone;
  final String location;
  

  FirebaseUserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.AddedOn,
    required this.password,
    required this.imageUrl,
    required this.phone,
    required this.location,
   
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'AddedOn': AddedOn,
      'password': password,
      'imageUrl': imageUrl,
      'phone': phone,
      'Location': location,
      
    };
  }

  factory FirebaseUserModel.fromMap(Map<String, dynamic> map) {
    return FirebaseUserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      AddedOn: map['AddedOn'] ?? '',
      password: map['password'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
     
    );
  }
}
