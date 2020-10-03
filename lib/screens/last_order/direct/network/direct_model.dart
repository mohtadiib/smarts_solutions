
class DirectModel {
  bool isExpanded = false;
  String order_id;
  String order_docId;

  bool order_type;
  String order_status;

  String build_category;
  String order_time;

  String order_username;


  String order_date;
  String order_total;

  String order_tasleek;
  String order_damaan;

  String order_item_quantity;
  String order_user_id;

  String orderCapCode;

  String order_captin_name;
  String order_captin_phone;

  String lat;
  String lng;

  String payment_type;

  DirectModel.fromMap(Map<String, dynamic> data){
    order_captin_phone = data['order_captin_phone'];

    order_docId = data['order_docId'];
    order_username = data['order_user_name'];

    order_id = data['order_id'];
    orderCapCode = data['order_cap_code'];

    order_type = data['order_type'];

    order_status = data['order_status'];
    build_category = data['build_category'];

    order_time = data['order_time'];
    order_date = data['order_date'];

    lat = data['lat'];
    lng = data['lng'];

    order_tasleek = data['order_tasleek'];
    order_damaan = data['payment_damaan'];

    order_total = data['order_total'];
    order_item_quantity = data['order_item_quantity'];

    order_user_id = data['order_user_id'];
    order_captin_name = data['order_captin_name'];

    payment_type = data['payment_type'];

  }
}