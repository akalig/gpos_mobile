import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  /** --------------------------------------------------------------------------------------- **/
  /** -------------------------------CREATE TABLES------------------------------------------- **/
  /** --------------------------------------------------------------------------------------- **/

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
      supplier_address TEXT,
      contact_person TEXT,
      contact_number TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
    print("...creating a supplier details table");
  }

  /// * Create Products Table *
  static Future<void> createProductsTable(sql.Database database) async {
    await database.execute("""CREATE TABLE products(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      product_code INTEGER,
      description TEXT,
      product_type TEXT,
      unit_cost DOUBLE,
      sell_price DOUBLE,
      supplier TEXT,
      is_tax_exempt BOOLEAN DEFAULT FALSE,
      is_discount BOOLEAN DEFAULT FALSE,
      manufactured_date DATE,
      expiration_date DATE,
      search_code TEXT,
      markup DOUBLE,
      ordering_level INTEGER,
      image BLOB,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
    print("...creating a products table");
  }

  /// * Create On Transaction Table *
  static Future<void> createOnTransactionTable(sql.Database database) async {
    await database.execute("""CREATE TABLE on_transaction(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      product_code INTEGER,
      description TEXT,
      sell_price DOUBLE,
      discount DOUBLE,
      ordering_level INTEGER,
      total DOUBLE,
      subtotal DOUBLE,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
    print("...creating a On Transaction table");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'gposmobile.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createProductTypesTable(database);
        await createSupplierDetailsTable(database);
        await createProductsTable(database);
        await createOnTransactionTable(database);
      },
    );
  }

  /** --------------------------------------------------------------------------------------- **/
  /** -------------------------------PRODUCT TYPES QUERIES----------------------------------- **/
  /** --------------------------------------------------------------------------------------- **/

  /// * Create Product Types *
  static Future<int> createProductTypes(
      String productType, String? description) async {
    final db = await SQLHelper.db();

    final data = {'product_type': productType, 'description': description};
    final id = await db.insert('product_types', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  /// * Get Products Types *
  static Future<List<Map<String, dynamic>>> getProductTypes() async {
    final db = await SQLHelper.db();
    return db.query('product_types', orderBy: "id DESC");
  }

  /// * Get Single Products Type *
  static Future<List<Map<String, dynamic>>> getProductType(int id) async {
    final db = await SQLHelper.db();
    return db.query('product_types',
        where: "id = ?", whereArgs: [id], limit: 1);
  }

  /// * Update Product Type *
  static Future<int> updateProductType(
      int id, String productType, String? description) async {
    final db = await SQLHelper.db();

    final data = {
      'product_type': productType,
      'description': description,
      'created_at': DateTime.now().toString()
    };

    final result = await db
        .update('product_types', data, where: "id = ?", whereArgs: [id]);
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

  /** --------------------------------------------------------------------------------------- **/
  /** -------------------------------SUPPLIER DETAILS QUERIES-------------------------------- **/
  /** --------------------------------------------------------------------------------------- **/

  /// * Create Supplier Details *
  static Future<int> createSupplierDetails(
      String supplier,
      String? supplierAddress,
      String contactPerson,
      String? contactNumber) async {
    final db = await SQLHelper.db();

    final data = {
      'supplier': supplier,
      'supplier_address': supplierAddress,
      'contact_person': contactPerson,
      'contact_number': contactNumber
    };
    final id = await db.insert('supplier_details', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  /// * Get Supplier Details *
  static Future<List<Map<String, dynamic>>> getSupplierDetails() async {
    final db = await SQLHelper.db();
    return db.query('supplier_details', orderBy: "id DESC");
  }

  /// * Get Single Supplier Details *
  static Future<List<Map<String, dynamic>>> getSupplierDetail(int id) async {
    final db = await SQLHelper.db();
    return db.query('supplier_details',
        where: "id = ?", whereArgs: [id], limit: 1);
  }

  /// * Update Supplier Detail *
  static Future<int> updateSupplierDetail(
      int id,
      String supplier,
      String? supplierAddress,
      String contactPerson,
      String? contactNumber) async {
    final db = await SQLHelper.db();

    final data = {
      'supplier': supplier,
      'supplier_address': supplierAddress,
      'contact_person': contactPerson,
      'contact_number': contactNumber,
      'created_at': DateTime.now().toString()
    };

    final result = await db
        .update('supplier_details', data, where: "id = ?", whereArgs: [id]);
    return result;
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

  /** --------------------------------------------------------------------------------------- **/
  /** -------------------------------PRODUCTS QUERIES---------------------------------------- **/
  /** --------------------------------------------------------------------------------------- **/

  /// * Create Products *
  static Future<int> createProductsDetails(
      String description,
      String productType,
      double unitCost,
      double sellPrice,
      String supplier,
      bool isTaxExempt,
      bool isDiscount,
      DateTime? manufacturedDate,
      DateTime? expirationDate,
      String searchCode,
      double markup,
      int orderingLevel,
      Uint8List? image) async {
    // Open the database
    final db = await SQLHelper.db();

    // Generate a unique product code
    List<Map<String, dynamic>> products = await getProductsDetails();
    int nextProductCode = 1000001;

    if (products.isNotEmpty) {
      // Find the highest existing product code
      int highestProductCode = products.first['product_code'];
      nextProductCode = highestProductCode + 1;
    }

    // Prepare data for insertion
    final data = {
      'product_code': nextProductCode,
      'description': description,
      'product_type': productType,
      'unit_cost': unitCost,
      'sell_price': sellPrice,
      'supplier': supplier,
      'is_tax_exempt': isTaxExempt ? 1 : 0,
      'is_discount': isDiscount ? 1 : 0,
      'manufactured_date': manufacturedDate?.toIso8601String(),
      'expiration_date': expirationDate?.toIso8601String(),
      'search_code': searchCode,
      'markup': markup,
      'ordering_level': orderingLevel,
      'created_at': DateTime.now().toIso8601String(),
      'image': image, // Assign the image directly
    };

    // Insert data into the database
    final id = await db.insert('products', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    print("Image blob: ${image.toString()}");

    return id;
  }

  /// * Get Products *
  static Future<List<Map<String, dynamic>>> getProductsDetails() async {
    final db = await SQLHelper.db();
    return db.query('products', orderBy: "id DESC");
  }

  /// * Get Single Product *
  static Future<List<Map<String, dynamic>>> getProduct(int id) async {
    final db = await SQLHelper.db();
    return db.query('products', where: "id = ?", whereArgs: [id], limit: 1);
  }

  /// * Update Product *
  static Future<int> updateProduct(
      int id,
      String description,
      String productType,
      double unitCost,
      double sellPrice,
      String supplier,
      bool isTaxExempt,
      bool isDiscount,
      DateTime? manufacturedDate,
      DateTime? expirationDate,
      String searchCode,
      double markup,
      int orderingLevel,
      Uint8List? image) async {
    final db = await SQLHelper.db();

    final data = {
      'description': description,
      'product_type': productType,
      'unit_cost': unitCost,
      'sell_price': sellPrice,
      'supplier': supplier,
      'is_tax_exempt': isTaxExempt,
      'is_discount': isDiscount,
      'manufactured_date': manufacturedDate,
      'expiration_date': expirationDate,
      'search_code': searchCode,
      'markup': markup,
      'ordering_level': orderingLevel,
      'created_at': DateTime.now().toString(),
      'image': image
    };

    final result =
        await db.update('products', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  /// * Delete Product *
  static Future<void> deleteProduct(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("products", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting the product: $err");
    }
  }

  /** --------------------------------------------------------------------------------------- **/
  /** -------------------------------ON TRANSACTION QUERIES---------------------------------- **/
  /** --------------------------------------------------------------------------------------- **/

  /// * Create On Transaction *
  static Future<int> createOnTransaction(int productCode, String description,
      double sellPrice, double discount) async {
    final db = await SQLHelper.db();
    int insertedId;
    int quantity = 1;

    List<Map<String, dynamic>> onTransaction = await db.query('on_transaction',
        where: 'product_code = ?', whereArgs: [productCode]);

    if (onTransaction.isNotEmpty) {
      int onTransactionQuantity = onTransaction.first['ordering_level'];
      quantity = onTransactionQuantity + 1;

      double updatedPrice = sellPrice * quantity;

      // Prepare data for update
      final data = {
        'ordering_level': quantity,
        'subtotal': updatedPrice,
        'total': updatedPrice,
      };

      insertedId = await db.update(
        'on_transaction',
        data,
        where: 'product_code = ?',
        whereArgs: [productCode],
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      // Prepare data for insertion
      final data = {
        'product_code': productCode,
        'description': description,
        'sell_price': sellPrice,
        'discount': discount,
        'ordering_level': quantity,
        'subtotal': sellPrice,
        'total': sellPrice,
      };

      insertedId = await db.insert('on_transaction', data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }

    return insertedId;
  }

  /// * Get On Transaction *
  static Future<List<Map<String, dynamic>>> getOnTransaction() async {
    final db = await SQLHelper.db();
    return db.query('on_transaction', orderBy: "id DESC");
  }

  /// * Update discount *
  static Future<int> updateDiscount(int productCode, double discount) async {
    final db = await SQLHelper.db();

    List<Map<String, dynamic>> onTransaction = await db.query('on_transaction',
        where: 'product_code = ?', whereArgs: [productCode]);

    if (onTransaction.isNotEmpty) {
      double total = onTransaction.first['subtotal'];

      // Compute the discounted value
      double discountedValue = total * (discount / 100);

      double updatedTotal = total - discountedValue;

      final data = {
        'discount': discountedValue,
        'total': updatedTotal,
      };

      final result =
      await db.update('on_transaction', data, where: "product_code = ?", whereArgs: [productCode]);
      return result;
    }

    return 0; // Return 0 if no transaction found
  }

}
