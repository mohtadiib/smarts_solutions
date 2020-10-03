
class ItemsDirectOrderModel {
  String name_ar;
  String name_en;
  String quantity;
  String price;
  String total;
  ItemsDirectOrderModel.fromMap(Map<String, dynamic> data){
    name_ar = data['productName_ar'];
    name_en = data['productName_en'];
    price = data['product_price'];
    quantity = data['product_quantity'];
    total = data['product_total'];
  }
}