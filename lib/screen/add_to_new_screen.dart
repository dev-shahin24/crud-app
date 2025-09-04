import 'dart:convert';

import 'package:crudappp/widget/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddToNewScreen extends StatefulWidget {
  const AddToNewScreen({super.key});

  @override
  State<AddToNewScreen> createState() => _AddToNewScreenState();
}

class _AddToNewScreenState extends State<AddToNewScreen> {
  bool addProductInProgress = false;
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: Form(
        key: _keyForm,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameTEController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Product Name',
                ),
                validator: (String? value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Enter your name';
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
                validator: (String? value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Enter your code';
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
                validator: (String? value) {
                  if (value?.trim().isEmpty ?? true) {
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
                validator: (String? value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Entery your unit price';
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
                validator: (String? value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Enter your image';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Visibility(
                visible: addProductInProgress == false,
                replacement: const CircleAvatar(),
                child: ElevatedButton(
                    onPressed: _onTapAddProductButton,
                    child: const Text('Submit')),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onTapAddProductButton() async {
    if (_keyForm.currentState!.validate() == false) {
      return;
    }
    addProductInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('http://35.73.30.144:2008/api/v1/CreateProduct');

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
    addProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      final decodeJson = jsonDecode(response.body);
      if (decodeJson['status'] == 'success') {
        clearTextFields();
        showSnackBarMessage(context, 'create successful');
      } else {
        String errorMessage = decodeJson['data'];
        showSnackBarMessage(context, errorMessage);
      }
    }
  }

  void clearTextFields() {
    _nameTEController.clear();
    _codeTEController.clear();
    _priceTEController.clear();
    _quantityTEController.clear();
    _imageTEController.clear();
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
