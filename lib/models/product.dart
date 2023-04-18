class Product{
  final String name;
  final String brand;
  final String ingredients;

  Product({
    required this.name,
    required this.brand,
    required this.ingredients,
  });
  Map<String, dynamic> mapProduct() {
    return {
      'product_name' : name,
      'product_brand' : brand,
      'product_ingredients' : ingredients,
    };
  }

  @override
  String toString() {
    return 'Product{name: $name, brand: $brand, ingredients: $ingredients}';
  }
}