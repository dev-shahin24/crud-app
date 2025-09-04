import 'dart:convert';

import 'package:crudappp/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/urls.dart';
import '../widget/snackbar_message.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  bool updateProductInProgress = false;
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  TextEditingController _nameTEController = TextEditingController();
  TextEditingController _codeTEController = TextEditingController();
  TextEditingController _priceTEController = TextEditingController();
  TextEditingController _quantityTEController = TextEditingController();
  TextEditingController _imageTEController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.name;
    _codeTEController.text = widget.product.code.toString();
    _quantityTEController.text = widget.product.quantity.toString();
    _priceTEController.text = widget.product.unitPrice.toString();
    _imageTEController.text = widget.product.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update'),
      ),
      body: Form(
        key: _keyForm,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameTEController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Product Name',
                ),
                validator: (String? value){
                  if(value?.trim().isEmpty ?? true){
                    return 'Enter your product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _codeTEController,
                decoration: const InputDecoration(
                  labelText: 'Product Code',
                  hintText: 'Product code',
                ),
                validator: (String? value){
                  if(value?.trim().isEmpty ?? true){
                    return 'Enter your Product Code';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _quantityTEController,
                decoration: const InputDecoration(
                  labelText: 'quantity',
                  hintText: 'quantity',
                ),
                validator: (String? value){
                  if(value?.trim().isEmpty ?? true){
                    return 'Enter your quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _priceTEController,
                decoration: const InputDecoration(
                  labelText: 'Unit Price',
                  hintText: 'Unit Price',
                ),
                validator: (String? value){
                  if(value?.trim().isEmpty ?? true){
                    return 'Enter your Unit Price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageTEController,
                decoration: const InputDecoration(
                  labelText: 'Image',
                  hintText: 'Image',
                ),
                validator: (String? value){
                  if(value?.trim().isEmpty ?? true){
                    return 'Enter your Image';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Visibility(
                visible: updateProductInProgress == false,
                  replacement: CircularProgressIndicator(),
                  child: ElevatedButton(onPressed: _updateproduct, child: const Text('Update')))
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _updateproduct() async {
    if (_keyForm.currentState!.validate() == false) {
      return;
    }
    updateProductInProgress = true;
    setState(() {});
    Uri uri = Uri.parse(Urls.updateProductUrl(widget.product.id));

    int totalPrice = int.parse(_priceTEController.text) *
        int.parse(_quantityTEController.text);
    Map<String, dynamic> requestBody = {
      "ProductName": _nameTEController.text.trim(),
      "ProductCode": int.parse(_codeTEController.text.trim()),
      "Img": _imageTEController.text.trim(),
      "Qty": int.parse(_quantityTEController.text.trim()),
      "UnitPrice": int.parse(_priceTEController.text.trim()),
      "TotalPrice": totalPrice,
    };
    Response response = await post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody));
    print(response);
    print(response.body);
    updateProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      final decodeJson = jsonDecode(response.body);
      if (decodeJson['status'] == 'success') {
        showSnackBarMessage(context, 'update successful');
      } else {
        String errorMessage = decodeJson['data'];
        showSnackBarMessage(context, errorMessage);
      }
    }
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _codeTEController.dispose();
    _priceTEController.dispose();
    _quantityTEController.dispose();
    _imageTEController.dispose();
    super.dispose();
  }
}
