
class MyLastOrder {
  bool isExpanded;
  String order_id;
  bool order_type;
  bool order_status;
  String build_category;
  String order_time;
  String order_date;
  String order_total;
  String order_tasleek;
  String order_damaan;

  String order_item_quantity;
  String order_user_id;
  String order_captin_name;
  String order_captin_phone;

  MyLastOrder.fromMap(Map<String, dynamic> data){
    isExpanded = data['isExpanded'];

    order_id = data['order_id'];
    order_type = data['order_type'];

    order_status = data['order_status'];
    build_category = data['build_category'];

    order_time = data['order_time'];
    order_date = data['order_date'];

    order_tasleek = data['order_tasleek'];
    order_damaan = data['payment_damaan'];

    order_total = data['order_total'];
    order_item_quantity = data['order_item_quantity'];

    order_user_id = data['order_user_id'];
    order_captin_name = data['order_captin_name'];

    order_captin_phone = data['order_captin_phone'];
  }
}