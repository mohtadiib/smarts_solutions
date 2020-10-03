
class LastVisit {
  bool isExpanded = false;
  String create_time;
  String create_date;

  String lat;
  String lng;

  String visit_time;
  String visit_date;

  String order_id;

  String order_docId;
  String order_status;

  bool   order_type;
  String order_user_id;
  String orderCapCode;

  String order_captin_name;
  String order_unit;
  String order_captin_phone;

  LastVisit.fromMap(Map<String, dynamic> data){
    create_date = data['create_date'];
    create_time = data['create_time'];
    order_docId = data['order_docId'];

    lat = data['lat'];
    lng = data['lng'];

    visit_time = data['visit_time'];
    visit_date = data['visit_date'];

    order_id = data['order_id'];
    orderCapCode = data['order_cap_code'];
    order_unit = data['order_unit'];

    order_status = data['order_status'];

    order_type = data['order_type'];
    order_user_id = data['user_id'];

    order_captin_name  = data['order_captin_name'];
    order_captin_phone = data['order_captin_phone'];
  }
}