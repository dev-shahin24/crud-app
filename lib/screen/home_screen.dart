import 'dart:convert';
import 'package:crudappp/models/product_model.dart';
import 'package:crudappp/screen/add_to_new_screen.dart';
import 'package:crudappp/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../widget/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> _productList = [];
  bool _getProductInProgress = false;

  @override
  void initState() {
    super.initState();
    getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
              onPressed: () {
                getProductList();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Visibility(
        visible: _getProductInProgress == false,
        replacement: Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.separated(
          itemCount: _productList.length,
          separatorBuilder: (context, index) {
            return const Divider(
              indent: 70,
            );
          },
          itemBuilder: (context, index) {
            return ProductItem(
              product: _productList[index],
              refreshProductList: () {
                getProductList();
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddToNewScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getProductList() async {
    _productList.clear();
    _getProductInProgress = true;
    setState(() {});

    Uri uri = Uri.parse(Urls.getProductUrl);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      final decodeJson = jsonDecode(response.body);

      for (Map<String, dynamic> productJson in decodeJson['data']) {
        ProductModel productModel = ProductModel.formJson(productJson);

        _productList.add(productModel);
        _getProductInProgress = false;
        setState(() {});
      }
    }
  }
}
