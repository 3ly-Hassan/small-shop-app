import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double price;
  final String description;

  DetailScreen({this.title, this.imageUrl, this.price, this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(imageUrl),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$$price',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            Container(
              width: double.infinity,
              child: Text(
                '$description',
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
