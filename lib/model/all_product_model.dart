class AllProductModel {
  int status;
  String message;
  List<Data> data;

  AllProductModel({this.status, this.message, this.data});

  AllProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String name;
  String productNum;
  String temperature;
  String barcode;

  Data({this.id, this.name, this.productNum, this.temperature, this.barcode});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productNum = json['product_num'];
    temperature = json['temperature'];
    barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['product_num'] = this.productNum;
    data['temperature'] = this.temperature;
    data['barcode'] = this.barcode;
    return data;
  }
}
