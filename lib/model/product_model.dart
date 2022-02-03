class ProductDataModel {
  int id;
  String name;
  String barcode;
  String productNum;
  int checkStatus;
  int selectedUnit;
  String selectedUnitName;
  Prices prices;

  ProductDataModel(
      {this.id,
      this.name,
      this.barcode,
      this.productNum,
      this.checkStatus,
      this.selectedUnit,
      this.selectedUnitName,
      this.prices});

  ProductDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    barcode = json['barcode'];
    productNum = json['product_num'];
    checkStatus = json['check_status'];
    selectedUnit = json['selected_unit'];
    selectedUnitName = json['selected_unit_name'];
    prices =
        json['prices'] != null ? new Prices.fromJson(json['prices']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['barcode'] = this.barcode;
    data['product_num'] = this.productNum;
    data['check_status'] = this.checkStatus;
    data['selected_unit'] = this.selectedUnit;
    data['selected_unit_name'] = this.selectedUnitName;
    if (this.prices != null) {
      data['prices'] = this.prices.toJson();
    }
    return data;
  }
}

class Prices {
  String price;
  List<ListProductData> list;

  Prices({this.price, this.list});

  Prices.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    if (json['list'] != null) {
      list = <ListProductData>[];
      json['list'].forEach((v) {
        list.add(new ListProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListProductData {
  int id;
  int userGroupId;
  int selectUnitId;
  double price;
  String unit;
  int unitId;

  ListProductData(
      {this.id,
      this.userGroupId,
      this.selectUnitId,
      this.price,
      this.unit,
      this.unitId});

  ListProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userGroupId = json['user_group_id'];
    selectUnitId = json['select_unit_id'];
    price = json['price'];
    unit = json['unit'];
    unitId = json['unit_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_group_id'] = this.userGroupId;
    data['select_unit_id'] = this.selectUnitId;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['unit_id'] = this.unitId;
    return data;
  }
}
