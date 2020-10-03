import 'iteme_order_items.dart';

class MyCart {
  String id;
  String name_ar;
  String name_en;
  String quantity;
  String price;
  String total;

  MyCart.fromMap(Map<String, dynamic> data){
    id = data['category_id'];
    name_ar = data['title_ar'];

    name_en = data['title_en'];
    price = data['price'];

    quantity = data['quantity'];
    total = data['total'];
  }
}