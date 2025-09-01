import 'package:crudappp/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../screen/update_product_screen.dart';
import '../utils/urls.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.refreshProductList,
  });
  final ProductModel product;
  final VoidCallback refreshProductList;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _deleteInProgres = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.product.name),
      leading: CircleAvatar(
        child: Image.network(
          widget.product.image,
          errorBuilder: (_, __, ___) {
            return Icon(Icons.error_rounded);
          },
        ),
      ),
      trailing: Visibility(
        visible: _deleteInProgres == false,
        replacement: CircularProgressIndicator(),
        child: PopupMenuButton<ProductOptions>(
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                  value: ProductOptions.update, child: Text('Update')),
              const PopupMenuItem(
                  value: ProductOptions.delete, child: Text('Delete'))
            ];
          },
          onSelected: (ProductOptions SelectOption) {
            if (SelectOption == ProductOptions.delete) {
              deleteProduct();
            } else if (SelectOption == ProductOptions.update) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProductScreen(
                            product: widget.product,
                          )));
            }
          },
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('code: ${widget.product.code}'),
          Row(
            children: [
              Text('quantity: ${widget.product.quantity}'),
              Text('unit price: ${widget.product.unitPrice}'),
            ],
          )
        ],
      ),
    );
  }

  Future<void> deleteProduct() async {
    _deleteInProgres = true;
    setState(() {});

    Uri uri = Uri.parse(Urls.deleteProductUrl(widget.product.id));
    Response response = await get(uri);

    if (response.statusCode == 200) {
      widget.refreshProductList();
    }
    _deleteInProgres = true;
    setState(() {});
  }
}

enum ProductOptions {
  update,
  delete,
}
