import 'package:cloud_firestore/cloud_firestore.dart';

class ModelItem {
  String name;
  String description;
  int quantity;
  String id;

  String unit;
  int rate;
  int taxes;
  String expDate;
  int itemPrice;
  int total;

  ModelItem({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    this.unit = '',
    required this.rate,
    this.taxes = 0,
    required this.expDate,
    required this.itemPrice,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
        'id':id,
        'name': name,
        'description': description,
        'quantity': quantity,
        'unit': unit,
        'rate': rate,
        'taxes': taxes,
        'expDate': expDate,
        'itemPrice': (rate - taxes),
        'total': quantity * rate
      };

  static ModelItem fromJson(Map<String, dynamic> json) => ModelItem(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        quantity: json['quantity'],
        unit: json['unit'],
        rate: json['rate'],
        taxes: json['taxes'],
        expDate: (json['expDate']),
        itemPrice: json['itemPrice'],
        total: json['total'],
      );
}

class SerialNumber {
  String? id;

  SerialNumber({this.id});

  factory SerialNumber.fromJson(Map<String, dynamic> json) =>
      SerialNumber(id: json['id']);
}
