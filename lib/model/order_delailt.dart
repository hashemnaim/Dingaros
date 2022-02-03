class OrderDetailsModel {
  int id;
  String user;
  String code;
  int statusId;
  String statusName;
  String deliveryDate;
  List<OrderDetails> orderDetails;

  OrderDetailsModel(
      {this.id,
      this.user,
      this.code,
      this.statusId,
      this.statusName,
      this.deliveryDate,
      this.orderDetails});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    code = json['code'];
    statusId = json['status_id'];
    statusName = json['status_name'];
    deliveryDate = json['delivery_date'];
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['code'] = this.code;
    data['status_id'] = this.statusId;
    data['status_name'] = this.statusName;
    data['delivery_date'] = this.deliveryDate;
    if (this.orderDetails != null) {
      data['orderDetails'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  int id;
  int productId;
  int unitId;
  String unitName;
  String productName;
  String price;
  int qty;
  int isSacnBarcode;
  int scanStatus;
  List<String> barcode;
    String barcodeBefore;

 List<ListOrderDetailsOut> list;
  OrderDetails(
      {this.id,
      this.productId,
      this.unitId,
      this.unitName,
      this.productName,
      this.price,
      this.qty,
      this.isSacnBarcode,
      this.scanStatus,
      this.barcode,
      this.barcodeBefore,
      this.list
      });

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    unitId = json['unit_id'];
    unitName = json['unit_name'];
    productName = json['product_name'];
    price = json['price'];
    qty = json['qty'];
    isSacnBarcode = json['is_sacn_barcode'];
    scanStatus = json['scan_status'];
    barcodeBefore = json['barcode_before'];
    barcode = json['barcode'].cast<String>();
    if (json['list'] != null) {
      list = <ListOrderDetailsOut>[];
      json['list'].forEach((v) {
        list.add(new ListOrderDetailsOut.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['unit_id'] = this.unitId;
    data['unit_name'] = this.unitName;
    data['product_name'] = this.productName;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['is_sacn_barcode'] = this.isSacnBarcode;
    data['scan_status'] = this.scanStatus;
    data['barcode'] = this.barcode;
    data['barcode_before'] = this.barcodeBefore;
     if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class ListOrderDetailsOut {
  int isOutput;
  String batchNum;
  String weight;
  String temperature;
  String stkCount;

  ListOrderDetailsOut(
      {this.isOutput,
      this.batchNum,
      this.weight,
      this.temperature,
      this.stkCount});

  ListOrderDetailsOut.fromJson(Map<String, dynamic> json) {
    isOutput = json['is_output'];
    batchNum = json['batch_num'];
    weight = json['weight'];
    temperature = json['temperature'];
    stkCount = json['stk_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_output'] = this.isOutput;
    data['batch_num'] = this.batchNum;
    data['weight'] = this.weight;
    data['temperature'] = this.temperature;
    data['stk_count'] = this.stkCount;
    return data;
  }
}
