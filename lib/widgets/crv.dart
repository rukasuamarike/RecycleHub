import 'package:cloud_firestore/cloud_firestore.dart';

class CRV {
  String City;
  String FacilityName;
  String Phone;
  num PostalCode;
  String StreetAddress;
  String Type;
  CRV(
      {required this.City,
      required this.FacilityName,
      required this.Phone,
      required this.PostalCode,
      required this.StreetAddress,
      required this.Type});

  static CRV fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    CRV cr = CRV(
      City: data['City'],
      FacilityName: data['FacilityName'],
      Phone: data['Phone'],
      PostalCode: data['PostalCode'],
      StreetAddress: data['StreetAddress'],
      Type: data['Type'],
    );

    return cr;
  }

  Map<String, dynamic> toJson() {
    return {
      "City": City,
      "FacilityName": FacilityName,
      "Phone": Phone,
      "PostalCode": PostalCode,
      "StreetAddress": StreetAddress,
      "Type": Type
    };
  }
}
