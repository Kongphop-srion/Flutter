import 'package:flutter/material.dart';

class formshopping extends StatelessWidget {
  formshopping(
      {Key? key,
      required this.productName,
      required this.customerName,
      required this.priceName,
      required this.numofproduct})
      : super(key: key);
  String productName, customerName, priceName, numofproduct;

  double calculateTotalPrice() {
    double price = double.parse(priceName);
    int quantity = int.parse(numofproduct);

    return price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    double totalPRICE = calculateTotalPrice();
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.account_balance_wallet_outlined),
              title: Text(
                'Product Name : ${productName}\n Customer Name : ${customerName}\n Total Price : ${totalPRICE}',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
