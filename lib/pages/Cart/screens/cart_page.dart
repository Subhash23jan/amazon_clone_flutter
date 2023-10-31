// ignore: file_names
import 'dart:async';
import 'dart:convert';

import 'package:amazon_clone_flutter/main.dart';
import 'package:amazon_clone_flutter/models/cartItem.dart';
import 'package:amazon_clone_flutter/models/user_model.dart';
import 'package:amazon_clone_flutter/pages/Cart/widgets/cart_items.dart';
import 'package:amazon_clone_flutter/pages/homeScreen/widgets/addressBox.dart';

import 'package:amazon_clone_flutter/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


import '../../../Screens/AuthPages/sign_in.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/product_model.dart';
import '../../../products/product_page.dart';
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  UserModel? _user;
  double totalSum=0;
  bool isLoaded=false;
  List<CartItem> cartItems = [];
  List<ProductModel>products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero,() {
    },);
  }

  getCartItems(BuildContext context) async {
    double sum=0;
    http.Response response = await http.get(
      Uri.parse(('${uri}api/user/cart')),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'email': _user!.email
      },
    );
    if (context.mounted) {
      httpErrorHandle(res: response, context: context, onSuccess: () async {
        List<dynamic>list = jsonDecode(response.body)['cart'];
        List<CartItem>items = [];
        List<ProductModel>productList=[];
        for (dynamic item in list) {
              items.add(CartItem(item['quantity'], item['productId'], _user?.email));
              ProductModel?  model= await getProduct(item['productId'], context);
              if(model!=null) {
                sum+=(model.price)*item['quantity'];
                productList.add(model);
              }
        }
        setState(() {
          cartItems = items;
          products=productList;
          totalSum=sum;
          isLoaded=true;
        });
      //  print(products.length);
      },);
    }
  }

  @override
  Widget build(BuildContext context){
    _user = Provider.of<UserProvider>(context, listen: false).user;
    getCartItems(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 2),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                            return const MainPage();
                          },));
                        },
                        child: Image.asset(
                            "assets/images/amazon_in.png", height: 40),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 22),
                          child: Icon(
                            Icons.notifications_none, color: Colors.black,
                            size: 28,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.search, color: Colors.black, size: 28,),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
      body: ((cartItems.length!=products.length) || !isLoaded)?const Center(child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 1,)):
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addressBox(),
            Padding(
              padding: const EdgeInsets.only(left: 65.0, top: 10),
              child: Text("Sub total : ₹$totalSum", style: GoogleFonts.aBeeZee(
                  fontSize: 16.5, fontWeight: FontWeight.w600),),
            ),
            InkWell(
              onTap: () {},
              child: Align(
                alignment: Alignment.center,
                child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33),
                      color: Colors.yellowAccent.shade700,
                    ),
                    height: 45,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.70,
                    alignment: Alignment.center,
                    child: Text("Proceed to Buy (1 item)",
                      style: GoogleFonts.aBeeZee(color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),)
                ),
              ),
            ),
            // ElevatedButton(onPressed: (){},
            //     child: Text("Deselect all items",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,color: Colors.blue.shade700,fontSize: 14),)),
            SizedBox(
              height: ((310*products.length)+10).toDouble(),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return cartProduct(context,products[index], cartItems[index]);
                },),
            )
          ],
        ),
      ),
        floatingActionButton: FloatingActionButton.extended(
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          icon:  const Icon(FontAwesomeIcons.road,color: Colors.yellowAccent,size: 22,),
          backgroundColor: Colors.redAccent,
          elevation: 12,
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return const MainPage();
            },));
          }, label:Container(
            alignment: Alignment.center,
            width: 105,
            child: Text("Way to Home",style: GoogleFonts.aBeeZee(fontSize: 16,color: Colors.yellow,fontWeight:FontWeight.bold),)), ),
    );
  }

  Future<ProductModel?> getProduct(String id, BuildContext context) async {
    ProductModel ? productModel;
    http.Response res = await http.get(Uri.parse('${uri}api/product/$id'));
    if (context.mounted) {
      //  print(res.body.toString());
      httpErrorHandle(res: res, context: context,
        onSuccess: () {
           productModel = ProductModel.fromJson(
              jsonDecode(res.body)['product']);
        },);
      return productModel;
    }
    return productModel;
  }
}
