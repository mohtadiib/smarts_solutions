class PaymentModel {
  String docId;
  String name;
  bool active;
  String image;

  PaymentModel.fromMap(Map<String, dynamic> data){
    docId = data['docId'];
    name = data['name'];
    active = data['status'];
    image = data['image'];
  }
}