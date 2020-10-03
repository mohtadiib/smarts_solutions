class Regions{
  String lat;
  String lng;

  Regions.fromMap(Map<String, dynamic> data){
    lat = data['lat'];
    lng = data['lng'];
  }
}
