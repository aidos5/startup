import 'package:flutter/material.dart';
import 'ModelItem.dart';

class TabClass {
  List<int>? count = [];
  Tab? billtabs;
  List<TextEditingController>? quantityEditor = [];
  List<ModelItem>? foundItems;
  List<ModelItem>? billedItems;
  List<Map<String, dynamic>>? billJson;
  String? billNo;
  int? totalCost;

  TabClass(
      {this.foundItems,
      this.billedItems,
      this.billtabs,
      this.billJson,
      this.billNo,
      this.totalCost,
      this.count,
      this.quantityEditor});
}
