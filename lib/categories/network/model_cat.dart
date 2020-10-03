
class CategoriesModel {
  String docId;
  String name_ar;
  String name_en;
  bool active;
  String image;

  CategoriesModel.fromMap(Map<String, dynamic> data){
    docId = data['categ_id'];
    name_ar = data['name_ar'];
    name_en = data['name_en'];
    active = data['status'];
    image = data['image'];
  }
}