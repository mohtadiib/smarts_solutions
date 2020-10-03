
class ModelContact {

  String address;
  String address_en;
  String contactEmail;

  String contactPhone;

  String lat;
  String lng;

  ModelContact.fromMap(Map<String, dynamic> data){
    address = data['address'];

    contactEmail = data['contactEmail'];
    contactPhone = data['contactPhone'];
    address_en = data['address_en'];
    lat = data['lat'];
    lng = data['lng'];

  }
}