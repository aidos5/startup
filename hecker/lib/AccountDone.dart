import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hecker/Model/ShopDetail.dart';
import 'package:hecker/Model/UserCredential.dart';
import 'package:hecker/MongoDB/MongoDB.dart';
import 'package:localstorage/localstorage.dart';
import 'UI/LoginPage.dart';

import 'package:http/http.dart' as http;

class AccountDone extends StatefulWidget {
  AccountDone({Key? key}) : super(key: key);

  @override
  State<AccountDone> createState() => _AccountDoneState();
}

class _AccountDoneState extends State<AccountDone> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  var db = FirebaseFirestore.instance;

  var localStorageUser = new LocalStorage('userCred.json');
  var localStorageShop = new LocalStorage('shopDetail.json');
  UserCredential? userCred;
  ShopDetail? shopDetail;

  bool registered = false;

  // Get a response from cloud to confirm account creation
  // Show Account Created dialog

  @override
  void initState() {
    // TODO: implement initState

    SetupBusiness();
  }

  void SetupBusiness() async {
    // Get details from local storage
    userCred = await UserCredential.fromJson(localStorageUser.getItem('user'));
    shopDetail = await ShopDetail.fromJson(localStorageShop.getItem('shop'));

    String? shopID = "";

    while (shopID!.isEmpty) {
      shopID = await GetShopID();

      if (shopID == null) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Something seems to be wrong..."),
                actions: [TextButton(onPressed: () {}, child: Text("Retry"))],
              );
            });
      }
    }

    shopDetail!.id = shopID;
    userCred!.shopID = shopID;

    await localStorageShop.setItem('shop', shopDetail);
    await localStorageUser.setItem('user', userCred);

    // var doc = db
    //     .collection("transactions")
    //     .doc("${shopDetail!.shopType}")
    //     .collection("${shopDetail!.pincode}")
    //     .doc("${shopID}");

    // // Set shop details
    // var finalDoc = await doc.set(shopDetail!.toJson());

    if (userCred!.isOwner!) {
      // var ownerDoc = db
      //     .collection("transactions")
      //     .doc("${shopDetail!.shopType}")
      //     .collection("${shopDetail!.pincode}")
      //     .doc("${shopID}")
      //     .collection("people")
      //     .doc("ownerDetails");

      // var userCredDoc = db.collection("userCreds").doc("${userCred!.phoneNo}");
      // var shopDetailDoc =
      //     userCredDoc.collection("shopDetail").doc("shopDetail");

      // await ownerDoc.set(userCred!.toJson());
      // await userCredDoc.set(userCred!.toJson());
      // await shopDetailDoc.set(shopDetail!.toJson());

      shopDetail!.owner = userCred!;
    } else {
      // var workerDoc = db
      //     .collection("transactions")
      //     .doc("${shopDetail!.shopType}")
      //     .collection("${shopDetail!.pincode}")
      //     .doc("${shopID}")
      //     .collection("people")
      //     .doc("worker_${userCred!.phoneNo}");

      // var userCredDoc = db.collection("userCreds").doc("${userCred!.phoneNo}");
      // var shopDetailDoc =
      //     userCredDoc.collection("shopDetail").doc("shopDetail");

      // await workerDoc.set(userCred!.toJson());
      // await userCredDoc.set(userCred!.toJson());
      // await shopDetailDoc.set(shopDetail!.toJson());

      
    }

    // Update data to mongo db
    await MongoDB.db!.collection('users').insertOne(userCred!.toJson());//.catchError((e) => print(e));
    await MongoDB.db!.collection('shops').insertOne(shopDetail!.toJson());//.catchError((e) => print(e));

    setState(() {
      registered = true;
    });

    // super.initState();
  }

  Future<String?> GetShopID() async {
    var response = await http.get(Uri.parse("https://id.finsmart.workers.dev"));

    ShopID id = ShopID.fromJson(jsonDecode(response.body));

    return id.id ?? null;
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('FinSmart')),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: (registered)
            ? Container(
                width: screenwidth,
                height: screenheight,
                child: Column(
                  children: [
                    const Text(
                      'Account Created',
                      style: TextStyle(fontSize: 37),
                    ),
                    SizedBox(
                      child: Icon(
                        Icons.thumb_up_alt_rounded,
                        size: screenheight / 2.5,
                      ),
                    ),
                    SizedBox(
                      height: screenheight / 10,
                      child: MaterialButton(
                        color: Colors.redAccent,
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textColor: Colors.white,
                        child: Text(
                          "LOG IN",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Text("Setting Up Your Business :)..."),
      ),
    );
  }
}
