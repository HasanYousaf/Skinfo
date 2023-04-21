import 'package:final_project/service/access_db.dart';
import 'package:flutter/material.dart';
import 'package:final_project/models/product.dart';
import 'package:final_project/screens/text_detector_view.dart';

class Manage {

  static Future<List<Product>> getProductList() async {
    List<Product> productList = await AccessDB.getProducts();
    return productList;
  }

  List<String> listIngredients (Product product) {
    String ingredients = product.ingredients;
    List<String> ingredientList;
      ingredientList = ingredients.split(",");
      return ingredientList;
    }



  Future<Product?> getProduct(String recognized) async{
    List<Product> products = await getProductList();
    Product found;
    recognized = recognized.replaceAll('*', '+');
    for (Product p in products) {
      if (recognized.toUpperCase().contains(p.name.toUpperCase())
      || p.name.toUpperCase().contains(recognized.toUpperCase())) {
         found = p;
        return found;
      }
      else {
        List<String> section = recognized.split(' ');
        int count = 0;
        if (recognized.toUpperCase().contains(p.brand.toUpperCase())) {
          for (String s in section) {
            if (s.toUpperCase() != "EAU" && s.toUpperCase() != "DE"
                && (p.name.toUpperCase().contains(s.toUpperCase())
                    || s.toUpperCase().contains(p.name.toUpperCase()))) {
              count ++;
            }
          }
          if (count > 1) {
            found = p;
            return found;
          }
        }
      }
    }
    return null;
  }

}
