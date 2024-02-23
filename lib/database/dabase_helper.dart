import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{

  /// * Create Product Types Table *
  static Future<void> createProductTypesTable(sql.Database database) async {
    await database.execute("""CREATE TABLE product_types(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      product_type TEXT,
      description TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
    print("...creating a product types table");
  }

  /// * Create Supplier Details Table *
  static Future<void> createSupplierDetailsTable(sql.Database database) async {
    await database.execute("""CREATE TABLE supplier_details(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      supplier TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
    print("...creating a supplier details table");
  }

  static Future<sql.Database> db() async {

    return sql.openDatabase(
      'gposmobile.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createProductTypesTable(database);
        await createSupplierDetailsTable(database);
      },
    );
  }

  /// * Create Product Types *
  static Future<int> createProductTypes(String product_type, String? description) async {
    final db = await SQLHelper.db();

    final data = {'product_type': product_type, 'description': description};
    final id = await db.insert('product_types', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  /// * Create Supplier Details *
  static Future<int> createSupplierDetails(String supplier) async {
    final db = await SQLHelper.db();

    final data = {'supplier': supplier};
    final id = await db.insert('supplier_details', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  /// * Get Products Types *
  static Future<List<Map<String, dynamic>>> getProductTypes() async {
    final db = await SQLHelper.db();
    return db.query('product_types', orderBy: "id DESC");
  }

  /// * Get Supplier Details *
  static Future<List<Map<String, dynamic>>> getSupplierDetails() async {
    final db = await SQLHelper.db();
    return db.query('supplier_details', orderBy: "id DESC");
  }

  /// * Get Single Products Type *
  static Future<List<Map<String, dynamic>>> getProductType(int id) async {
    final db = await SQLHelper.db();
    return db.query('product_types', where: "id = ?", whereArgs: [id], limit: 1);
  }

  /// * Get Single Supplier Details *
  static Future<List<Map<String, dynamic>>> getSupplierDetail(int id) async {
    final db = await SQLHelper.db();
    return db.query('supplier_details', where: "id = ?", whereArgs: [id], limit: 1);
  }

  /// * Update Product Type *
  static Future<int> updateProductType(int id, String product_type, String? description) async {
    final db = await SQLHelper.db();

    final data = {
      'product_type': product_type,
      'description': description,
      'created_at': DateTime.now().toString()
    };

    final result = await db.update('product_types', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  /// * Update Supplier Detail *
  static Future<int> updateSupplierDetail(int id, String supplier) async {
    final db = await SQLHelper.db();

    final data = {
      'supplier': supplier,
      'created_at': DateTime.now().toString()
    };

    final result = await db.update('supplier_details', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  /// * Delete Product Type *
  static Future<void> deleteProductType(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("product_types", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting the product type: $err");
    }
  }

  /// * Delete Supplier Detail *
  static Future<void> deleteSupplierDetail(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("supplier_details", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting the product type: $err");
    }
  }
}