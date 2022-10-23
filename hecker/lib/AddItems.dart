import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hecker/Items.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Model/ModelItem.dart';

class AddItems extends StatefulWidget {
  AddItems({Key? key}) : super(key: key);

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final itemName = TextEditingController();
  final quantity = TextEditingController();
  final minimumQuantity = TextEditingController();
  final unit = TextEditingController();
  final rate = TextEditingController();
  final taxes = TextEditingController();
  final expDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        leading: MaterialButton(
          onPressed: (() {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Items()),
                (route) => false);
          }),
          child: Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
        ),
        title: Text(
          'FinSmart',
          style: TextStyle(fontSize: 37),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox(
          width: screenwidth,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Item Name', border: OutlineInputBorder()),
                  controller: itemName,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Quantity', border: OutlineInputBorder()),
                  controller: quantity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Minimum Quantity',
                      border: OutlineInputBorder()),
                  controller: minimumQuantity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Enter unit', border: OutlineInputBorder()),
                  controller: unit,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Selling Price', border: OutlineInputBorder()),
                  controller: rate,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Taxes', border: OutlineInputBorder()),
                  controller: taxes,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Expiry Date', border: OutlineInputBorder()),
                  controller: expDate,
                ),
              ),
              MaterialButton(
                onPressed: (() {
                  SaveAll();
                }),
                child: Text('Save'),
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future SaveAll() async {
    final item = ModelItem(
      name: itemName.text,
      quantity: int.parse(quantity.text),
      minimumQuantity: int.parse(minimumQuantity.text),
      unit: unit.text,
      rate: int.parse(rate.text),
      taxes: int.parse(taxes.text),
      expDate: DateTime.now(),
      itemPrice: (int.parse(rate.text) - int.parse(taxes.text)),
      total: int.parse(rate.text) * int.parse(quantity.text),
    );

    final doc = item.toJson();
    final docuser = FirebaseFirestore.instance
        .collection('transactions')
        .doc('category')
        .collection('pincode')
        .doc('shopid')
        .collection('items')
        .doc('${itemName.text + '_' + unit.text}');

    await docuser.set(doc);
  }
}
