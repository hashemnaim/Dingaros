class OrderModel {
  var status;
  String msg;
  List<Data> data;

  OrderModel({this.status, this.msg, this.data});

  OrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
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
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String user;
  String code;
  int statusId;
  String statusName;
  String deliveryDate;
  int count;

  Data(
      {this.id,
      this.user,
      this.code,
      this.statusId,
      this.statusName,
      this.deliveryDate,
      this.count});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    code = json['code'];
    statusId = json['status_id'];
    statusName = json['status_name'];
    deliveryDate = json['delivery_date'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['code'] = this.code;
    data['status_id'] = this.statusId;
    data['status_name'] = this.statusName;
    data['delivery_date'] = this.deliveryDate;
    data['count'] = this.count;
    return data;
  }
}
