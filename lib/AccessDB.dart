import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'package:final_project/models/product.dart';

class AccessDB {

  String dbName = "productDB.db";

  late Database _database;
  Future<Database> get db async {
    _database = await initDB();
    return _database;
  }


  initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "productDB.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    } else {
      print("Opening existing database");
    }

// open the database
    return await openDatabase(path);

  }


  Future<List<Product>> getProducts() async {
    final curDB = await db;
    final List<Map<String, dynamic>> productMaps = await curDB.query('products');
    return List.generate(productMaps.length, (i) {
      return Product(
        name: productMaps[i]['product_name'],
        brand: productMaps[i]['product_brand'],
        ingredients: productMaps[i]['product_ingredients'],
      );
    });
  }
}
