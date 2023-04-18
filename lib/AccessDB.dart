import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'models/product.dart';

class AccessDB {

  // late Database _db;

  // Future<Database> get db async {
  //   if (_db != null) return _db;
  //   _db = await initDB();
  //   return _db;
  // }
  static const String databaseName = "productDB.db";
  static Database? db;

  static Future<Database> initDB() async {

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "productDB.db");

// delete existing if any
    await deleteDatabase(path);

// Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

// Copy from asset
    ByteData data = await rootBundle.load(join("assets", "productDB.db"));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes, flush: true);

// open the database
    var db = await openDatabase(path, readOnly: true);
    return db;
    }

//   initDB() async{
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, "productDB.db");
//
// // Only copy if the database doesn't exist
//     if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
//       // Load database from asset and copy
//       ByteData data = await rootBundle.load(join('assets', 'productDB.db'));
//       List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//
//       // Save copied asset to documents
//       await new File(path).writeAsBytes(bytes);
//
//     }
//   }


      // Directory appDocDir = await getApplicationDocumentsDirectory();
      // String databasePath = join(appDocDir.path, 'asset_database.db');
      // this.db = await openDatabase(databasePath);
      // initialized = true;

  static Future<List<Product>> getProducts() async {
    final db = await AccessDB.initDB();

    final List<Map<String, Object?>> queryResult = await db.query('products');
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }
  }

  Future<List<Product>> getProductByName(String name) async {
  final db = await AccessDB.initDB();
  List<Map<String, Object?>> result = await db.query("products", where: "product_name = ", whereArgs: [name]);
  return result.map ((e) => Product.fromMap(e)).toList();
  }


