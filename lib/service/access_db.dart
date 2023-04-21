import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:final_project/models/product.dart';

class AccessDB {
  static const String databaseName = "productDB.db";
  static Database? db;

  static Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "productDB.db");

    await deleteDatabase(path);

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    ByteData data = await rootBundle.load(join("assets", "productDB.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes, flush: true);

    var db = await openDatabase(path, readOnly: true);
    return db;
  }


  static Future<List<Product>> getProducts() async {
    final db = await AccessDB.initDB();

    final List<Map<String, Object?>> queryResult = await db.query('products');
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }
}

