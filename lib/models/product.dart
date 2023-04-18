class ProductColumn {
  static final List<String> values = [
    name, brand, ingredients
  ];

  static const String name = 'product_name';
  static const String brand = 'product_brand';
  static const String ingredients = 'product_ingredients';
}

class Product {
  String name;
  String brand;
  String ingredients;

  Product({required this.name, required this.brand, required this.ingredients});


  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      ProductColumn.name:name,
      ProductColumn.brand:brand,
      ProductColumn.ingredients:ingredients,
    };
    return map;
}

  Product.fromMap(Map<String, dynamic> item)
      :
        name = item[ProductColumn.name],
        brand = item[ProductColumn.brand],
        ingredients = item[ProductColumn.ingredients];


@override
String toString() {
  return 'Product{name: $name, brand: $brand, ingredients: $ingredients}';
}}
