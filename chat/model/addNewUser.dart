class NewUserAddToChatModel {
  late String id;
  late String? titleProduct;
  late String? imageProduct;
  late String? idProduct;
  NewUserAddToChatModel({
    required this.id,
    this.idProduct,
    this.titleProduct,
    this.imageProduct,
  });
  NewUserAddToChatModel.fromJson(Map<String, dynamic> json) {
    id = this.id;
    titleProduct = this.titleProduct;
    imageProduct = this.imageProduct;
    idProduct = this.idProduct;
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> _d = Map<String, dynamic>();
    _d['id'] = this.id;
    _d['titleProduct'] = this.titleProduct;
    _d['imageProduct'] = this.imageProduct;
    _d['idProduct'] = this.idProduct;
    return _d;
  }
}
