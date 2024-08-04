import 'package:flutter/material.dart';
import 'package:kpshop/shopping.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  var _productName;
  var _customerName;
  var _priceName;
  var _numofproName;

  final _productController = TextEditingController();
  final _customerController = TextEditingController();
  final _priceController = TextEditingController();
  final _numofproController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productController.addListener(_updateText);
    _customerController.addListener(_updateText);
    _priceController.addListener(_updateText);
    _numofproController.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      _productName = _productController.text;
      _customerName = _customerController.text;
      _priceName = _productController.text;
      _numofproName = _productController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Form Shop')),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _productController,
              decoration: InputDecoration(
                labelText: "Product Name",
                icon: Icon(Icons.verified_user_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0), // Adjusted spacing
            TextFormField(
              controller: _customerController,
              decoration: InputDecoration(
                labelText: "Customer Name",
                icon: Icon(Icons.verified_user_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0), // Adjusted spacing
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: "Price",
                icon: Icon(Icons.verified_user_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0), // Adjusted spacing
            TextFormField(
              controller: _numofproController,
              decoration: InputDecoration(
                labelText: "Num Of Product",
                icon: Icon(Icons.verified_user_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0), // Adjusted spacing
            MyBtn(context),
            Text(
              "Product Name is : $_productName",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "Customer Name is : $_customerName",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "Price Name is : $_priceName",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "Num Of Product is : $_numofproName",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Center MyBtn(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Go Shopping",
              style: TextStyle(fontSize: 15),
            ),
            Icon(Icons.add_shopping_cart_outlined),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return formshopping(
                  productName: _productController.text,
                  customerName: _customerController.text,
                  priceName: _priceController.text,
                  numofproduct: _numofproController.text,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
