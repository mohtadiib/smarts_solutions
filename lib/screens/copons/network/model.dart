
class CoupModel {

  String cop_code;
  String user_id_coupon;

  int count_coupon;
  int sum_date_coupon;

  String doc_cuop;

  String price_coupon;
  String unit_coupon_ar;

  String unit_coupon_en;

  CoupModel.fromMap(Map<String, dynamic> data){
    doc_cuop = data['docId_coupon'];

    cop_code = data['cop_code'];
    user_id_coupon = data['user_id_coupon'];

    count_coupon = data['count_coupon'];
    sum_date_coupon = data['sum_date_coupon'];

    price_coupon = data['price_coupon'];
    unit_coupon_ar = data['unit_coupon_ar'];

    unit_coupon_en = data['unit_coupon_en'];

  }
}