import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String uid;
  String name;
  num totalCans;
  String defaultCenter;
  num defaultZip;
  String email;

  UserData({
    required this.uid,
    required this.name,
    required this.totalCans,
    required this.defaultCenter,
    required this.defaultZip,
    required this.email,
  });
  static UserData fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    UserData user = UserData(
        uid: snap.id,
        name: data['name'],
        totalCans: data['totalCans'],
        defaultCenter: data['defaultCenter'],
        defaultZip: data['defaultZip'],
        email: data['email']);
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "totalCans": totalCans,
      "defaultCenter": defaultCenter,
      "defaultZip": defaultZip,
      "email": email
    };
  }
}
