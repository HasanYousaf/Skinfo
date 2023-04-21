
import 'package:final_project/service/manage_products.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class IngredientsView extends StatefulWidget {

  const IngredientsView({required this.scanned, super.key});

  final String scanned;

  @override
  IngredientsViewState createState() => IngredientsViewState();
}

class IngredientsViewState extends State<IngredientsView> {
  late Product? product;


  final int listLength = 1;
  late List<dynamic> _selected;

  late String productName;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future <void> init() async {
    setState(() {
      productName = "Loading";
      _selected = List<String>.generate(listLength, (_) => 'Loading');
    });
    product = await Manage().getProduct(widget.scanned);
    List<String> ingredients = Manage().listIngredients(product!);
    setState(() {
    productName = product!.name;
    _selected = ingredients;
    });
  }

  @override
  void dispose() {
    _selected.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(productName),
        ),
        body: ListView.builder(
            itemCount: _selected.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text('${_selected[index]}'));
            }));
  }
}
