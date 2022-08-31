
class UserChat {
  late String id;
  late bool is_provider;
  late bool is_blocked;
  late bool is_new_message;
  late bool mute;
  late String name;
  late String? photoUrl;
  late String? token;
  late bool show_bot;
  late String block_by;
  late String ? idProduct;
  late String ? imageProduct;
  late String ? titleProduct;
  UserChat(
      {required this.id,
      required this.token,
        this.idProduct,
        this.imageProduct,
        this.titleProduct,
      required this.block_by,
      required this.show_bot,
      required this.is_blocked,
        required this.is_provider,
      required this.is_new_message,
      required this.mute,
      required this.name,
      required this.photoUrl});

  UserChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    is_provider = json['is_provider'];
    show_bot = json['show_bot'];
    token = json['token'];
    block_by = json['block_by'];
    is_blocked = json['is_blocked'];
    is_new_message = json['is_new_message'];
    mute = json['mute'];
    name = json['name'];
    photoUrl = json['photoUrl'];
    idProduct = json['idProduct'] !=null ? json['idProduct'] :"";
    imageProduct = json['imageProduct'] !=null ? json['imageProduct'] :"";
    titleProduct = json['titleProduct'] !=null ? json['titleProduct'] :"";
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> _d = Map<String, dynamic>();
    _d['block_by'] = this.block_by;
    _d['idProduct'] = this.idProduct;
    _d['imageProduct'] = this.imageProduct;
    _d['titleProduct'] = this.titleProduct;
    _d['is_provider'] = this.is_provider;
    _d['token'] = this.token;
    _d['id'] = this.id;
    _d['is_blocked'] = this.is_blocked;
    _d['is_new_message'] = this.is_new_message;
    _d['mute'] = this.mute;
    _d['show_bot'] = this.show_bot;
    _d['name'] = this.name;
    _d['photoUrl'] = this.photoUrl;
    return _d;
  }
}
