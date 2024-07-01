import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:intl/intl.dart';

class SQLHelper {
  /** --------------------------------------------------------------------------------------- **/
  /** -------------------------------CREATE TABLES------------------------------------------- **/
  /** --------------------------------------------------------------------------------------- **/

  /// * Create User Account Table *
  static Future<void> createUserAccountTable(sql.Database database) async {
    await database.execute("""CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      first_name TEXT,
      middle_name TEXT,
      last_name TEXT,
      suffix_name TEXT,
      contact_number TEXT,
      username TEXT,
      password TEXT,
      user_type TEXT,
      is_logged_in INTEGER,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
    print("...creating a product types table");
  }

  /// * Create Company Table *
  static Future<void> createCompanyDetailsTable(sql.Database database) async {
    await database.execute("""CREATE TABLE company(
      company_name TEXT,
      company_address TEXT,
      company_mobile_number TEXT,
      company_email TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
    print("...creating a product types table");
  }

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

  /// * Create Sales Details Table *
  static Future<void> createSalesDetailsTable(sql.Database database) async {
    await database.execute("""CREATE TABLE sales_details(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      transaction_code INTEGER,
      product_code INTEGER,
      description TEXT,
      sell_price DOUBLE,
      discount DOUBLE,
      ordering_level INTEGER,
      total DOUBLE,
      subtotal DOUBLE,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
    print("...creating a sales details table");
  }

  /// * Create Sales Headers Table *
  static Future<void> createSalesHeadersTable(sql.Database database) async {
    await database.execute("""CREATE TABLE sales_headers(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    transaction_code INTEGER,
    subtotal DOUBLE,
    total_discount DOUBLE,
    total DOUBLE,
    amount_paid DOUBLE,
    change DOUBLE,
    status TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  )""");
    print("...creating a Sales headers table");
  }

  /// * Create User Transaction Table *
  static Future<void> createUserTransactionTable(sql.Database database) async {
    await database.execute("""CREATE TABLE user_transaction(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    staff_name TEXT,
    staff_id INTEGER,
    transaction_code INTEGER,
    status TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP`
  )""");
    print("...creating a user transaction table");
  }

  /// * Create Receipt Footer Table *
  static Future<void> createReceiptFooterTable(sql.Database database) async {
    await database.execute("""CREATE TABLE receipt_footer(
      line_one TEXT,
      line_two TEXT
      )""");
    print("...creating a receipt footer table");
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
        await createSalesDetailsTable(database);
        await createSalesHeadersTable(database);
        await createUserAccountTable(database);
        await createCompanyDetailsTable(database);
        await createUserTransactionTable(database);
        await createReceiptFooterTable(database);
      },
    );
  }

  /** --------------------------------------------------------------------------------------- **/
  /** -------------------------------RECEIPT FOOTER QUERIES---------------------------------- **/
  /** --------------------------------------------------------------------------------------- **/

  /// * Create Default Receipt Footer *
  static Future<int> createDefaultFooter(
      String? lineOne, String? lineTwo) async {
    final db = await SQLHelper.db();

    final data = {'line_one': lineOne, 'line_two': lineTwo};
    final id = await db.insert('receipt_footer', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getReceiptFooter() async {
    final db = await SQLHelper.db();
    return db.query('receipt_footer');
  }

  /// * Update Product Type *
  static Future<int> updateReceiptFooter(
      String? lineOne, String? lineTwo) async {
    final db = await SQLHelper.db();

    final data = {'line_one': lineOne, 'line_two': lineTwo};

    final result = await db.update('receipt_footer', data);
    return result;
  }

  /** --------------------------------------------------------------------------------------- **/
  /** -------------------------------COMPANY QUERIES----------------------------------------- **/
  /** --------------------------------------------------------------------------------------- **/

  /// * Create Product Types *
  static Future<int> createCompanyDetails(
      String companyName,
      String companyAddress,
      String companyMobileNumber,
      String companyEmail) async {
    final db = await SQLHelper.db();

    final data = {
      'company_name': companyName,
      'company_address': companyAddress,
      'company_mobile_number': companyMobileNumber,
      'company_email': companyEmail,
    };
    final id = await db.insert('company', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  /// * Update Company Details *
  static Future<int> updateCompanyDetails(
      String? companyName,
      String? companyAddress,
      String? companyMobileNumber,
      String? companyEmail) async {
    final db = await SQLHelper.db();

    final data = {
      'company_name': companyName,
      'company_address': companyAddress,
      'company_mobile_number': companyMobileNumber,
      'company_email': companyEmail
    };

    final result = await db.update('company', data);
    return result;
  }

  static Future<List<Map<String, dynamic>>> getCompanyDetailsData() async {
    final db = await SQLHelper.db();
    return db.query('company');
  }

  /** --------------------------------------------------------------------------------------- **/
  /** -------------------------------USER ACCOUNT QUERIES------------------------------------ **/
  /** --------------------------------------------------------------------------------------- **/

  /// * Create Product Types *
  static Future<int> createUserAccount(
      String firstName,
      String middleName,
      String lastName,
      String suffixName,
      String username,
      String password,
      String userType) async {
    final db = await SQLHelper.db();

    final data = {
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'suffix_name': suffixName,
      'username': username,
      'password': password,
      'user_type': userType,
      'is_logged_in': 0,
    };
    final id = await db.insert('users', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<Map<String, dynamic>?> queryUserAccount(
      String username, String password) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<List<Map<String, dynamic>>> getUsersData() async {
    final db = await SQLHelper.db();
    return db.query('users');
  }

  static Future<List<Map<String, dynamic>>> getLoggedUserData() async {
    final db = await SQLHelper.db();
    return db.query('users', where: "is_logged_in = 1");
  }

  /// * Update Logged In User *
  static Future<int> updateLoggedInUserData(String username) async {
    final db = await SQLHelper.db();

    final data = {
      'is_logged_in': 1
    };

    final result = await db
        .update('users', data, where: "username = ?", whereArgs: [username]);
    return result;
  }

  /// * Update Logged Out User *
  static Future<int> updateLoggedOutUserData() async {
    final db = await SQLHelper.db();

    final data = {
      'is_logged_in': 0
    };

    final result = await db
        .update('users', data);
    return result;
  }

  /// * Get Single User *
  static Future<List<Map<String, dynamic>>> getSingleUser(int id) async {
    final db = await SQLHelper.db();
    return db.query('users',
        where: "id = ?", whereArgs: [id], limit: 1);
  }

  /// * Update User *
  static Future<int> updateUser(
      int id,
      String firstName,
      String middleName,
      String lastName,
      String suffixName,
      String username,
      String password,
      String userType) async {
    final db = await SQLHelper.db();

    final data = {
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'suffix_name': suffixName,
      'username': username,
      'password': password,
      'user_type': userType,
    };

    final result = await db
        .update('users', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  /// * Delete User *
  static Future<void> deleteUser(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("users", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting the User: $err");
    }
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

  Future<List<Map<String, dynamic>>> searchProducts(String searchTerm) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM products WHERE description LIKE '%$searchTerm%' OR search_code LIKE '%$searchTerm%'");
    return result;
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

      final result = await db.update('on_transaction', data,
          where: "product_code = ?", whereArgs: [productCode]);
      return result;
    }

    return 0; // Return 0 if no transaction found
  }

  /// * Update discount *
  static Future<int> updateQuantity(int productCode, int quantity) async {
    final db = await SQLHelper.db();

    List<Map<String, dynamic>> onTransaction = await db.query('on_transaction',
        where: 'product_code = ?', whereArgs: [productCode]);

    if (onTransaction.isNotEmpty) {
      double total = onTransaction.first['total'];

      double updatedTotal = total * quantity;

      final data = {
        'ordering_level': quantity,
        'total': updatedTotal,
        'subtotal': updatedTotal,
      };

      final result = await db.update('on_transaction', data,
          where: "product_code = ?", whereArgs: [productCode]);
      return result;
    }

    return 0; // Return 0 if no transaction found
  }

  /// * Truncate On Transaction *
  static Future<void> truncateOnTransaction() async {
    final db = await SQLHelper.db();
    await db.delete('on_transaction');
  }

  /** --------------------------------------------------------------------------------------- **/
  /** -------------------------------SALES HEADERS QUERIES----------------------------------- **/
  /** --------------------------------------------------------------------------------------- **/

  /// * Create Sales Headers *
  static Future<void> createSalesHeaders(double subtotal, double totalDiscount,
      double total, String stAmountPaid, String staffName, int staffID) async {
    final db = await SQLHelper.db();

    double amountPaid = double.parse(stAmountPaid);

    double change = amountPaid - total;

    // Get the current timestamp as a formatted date string
    String createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // Get the next available transaction_code for sales_details
    List<Map<String, dynamic>> salesHeaders = await getSalesCount();
    int nextTransactionCode = 1000001;

    if (salesHeaders.isNotEmpty) {
      // Find the highest existing transaction_code
      int highestTransactionCode = salesHeaders.first['transaction_code'];
      nextTransactionCode = highestTransactionCode + 1;
    }

    final data = {
      'transaction_code': nextTransactionCode,
      'subtotal': subtotal,
      'total_discount': totalDiscount,
      'total': total,
      'amount_paid': amountPaid,
      'change': change,
      'status': 'done',
      'created_at': createdAt,
    };

    await db.insert('sales_headers', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    final userTransactionData = {
      'staff_name': staffName,
      'staff_id': staffID,
      'transaction_code': nextTransactionCode,
      'status': 'done',
      'created_at': createdAt,
    };

    await db.insert('user_transaction', userTransactionData,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

  }

  /// * Get Sales Headers Count *
  static Future<List<Map<String, dynamic>>> getSalesCount() async {
    final db = await SQLHelper.db();
    return db.query('sales_headers', orderBy: "id DESC");
  }

  /// * Get Sales Headers *
  static Future<List<Map<String, dynamic>>> getSalesHeaders() async {
    final db = await SQLHelper.db();
    return db.query('sales_headers', orderBy: "id");
  }

  /// * Get User Transaction *
  static Future<List<Map<String, dynamic>>> getUserTransaction() async {
    final db = await SQLHelper.db();
    return db.query('user_transaction', orderBy: "id");
  }

  /// * Get Daily Sales Headers *
  static Future<List<Map<String, dynamic>>> getDailySalesHeaders() async {
    final db = await SQLHelper.db();
    return db.query('sales_headers', orderBy: "id");
  }

  /// * Update Sales Void Status *
  static Future<int> salesVoid(int id, int transactionCode) async {
    final db = await SQLHelper.db();

    final data = {
      'status': 'void',
    };

    final result = await db.update('sales_headers', data,
        where: "transaction_code = ?", whereArgs: [transactionCode]);
    return result;
  }

  static Future<List<Map<String, dynamic>>> getWeeklySalesData() async {
    final db = await SQLHelper.db();
    // Query to sum total by date and return the date and total for each day
    return db.rawQuery('''
        SELECT date(created_at) as date, SUM(total) as total
        FROM sales_headers
        GROUP BY date
        ORDER BY date;
    ''');
  }

  static Future<List<Map<String, dynamic>>>
      getDailySalesAndTransactionData() async {
    final db = await SQLHelper.db();
    final todayFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Query to sum total by date and return the date and total for each day
    final results = await db.rawQuery('''
    SELECT COUNT(id) AS transactions_count, SUM(total) AS total_sales
    FROM sales_headers
    WHERE date(created_at) = '$todayFormatted';
  ''');

    print('SQL query result: $results');

    return results;
  }

  static Future<List<Map<String, dynamic>>> getZReadData(String formattedDate) async {
    final db = await SQLHelper.db();
    // Ensure the date is correctly formatted for the SQL query
    final results = await db.rawQuery('''
    SELECT
        created_at,
        COUNT(id) AS transactions_count,
        SUM(subtotal) AS total_gross,
        SUM(total_discount) AS total_discount,
        SUM(total) AS total_sales,
        (SELECT COUNT(id) FROM sales_headers WHERE status = 'void' AND date(created_at) = '$formattedDate') AS count_void,
        (SELECT SUM(total) FROM sales_headers WHERE status = 'void' AND date(created_at) = '$formattedDate') AS total_void,
        (SELECT COUNT(id) FROM sales_headers WHERE total_discount != 0 AND date(created_at) = '$formattedDate') AS count_discount
    FROM sales_headers
    WHERE date(created_at) = '$formattedDate';
  ''');

    print('SQL query result: $results');

    return results;
  }

  /** --------------------------------------------------------------------------------------- **/
  /** -------------------------------SALES DETAILS QUERIES----------------------------------- **/
  /** --------------------------------------------------------------------------------------- **/

  /// * Create Sales Details *
  static Future<void> createSalesDetails() async {
    final db = await SQLHelper.db();

    // Get all data from on_transaction table
    List<Map<String, dynamic>> onTransactionData =
        await db.query('on_transaction');

    // Get the current timestamp as a formatted date string
    String createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // Get the next available transaction_code for sales_details
    List<Map<String, dynamic>> salesDetails = await getSalesDetailsCount();
    int nextTransactionCode = 1000001;

    if (salesDetails.isNotEmpty) {
      // Find the highest existing transaction_code
      int highestTransactionCode = salesDetails.first['transaction_code'];
      nextTransactionCode = highestTransactionCode + 1;
    }

    // Loop through each row in on_transaction table
    for (Map<String, dynamic> transaction in onTransactionData) {
      // Prepare data for insertion into sales_details table
      final data = {
        'transaction_code': nextTransactionCode,
        'product_code': transaction['product_code'],
        'description': transaction['description'],
        'sell_price': transaction['sell_price'],
        'discount': transaction['discount'],
        'ordering_level': transaction['ordering_level'],
        'subtotal': transaction['subtotal'],
        'total': transaction['total'],
        'created_at': createdAt,
      };

      // Insert data into sales_details table
      await db.insert('sales_details', data);

      // Subtract ordering_level from products table
      await db.execute(
          'UPDATE products SET ordering_level = ordering_level - ? WHERE product_code = ?',
          [transaction['ordering_level'], transaction['product_code']]);
    }
  }

  /// * Get Sales Details Count *
  static Future<List<Map<String, dynamic>>> getSalesDetailsCount() async {
    final db = await SQLHelper.db();
    return db.query('sales_details', orderBy: "id DESC");
  }

  /// * Get Sales Details *
  static Future<List<Map<String, dynamic>>> getSalesDetails() async {
    final db = await SQLHelper.db();
    return db.query('sales_details', orderBy: "id");
  }

  /// * Get Sales Details by Transaction Code *
  static Future<List<Map<String, dynamic>>> getSalesDetailsByTransactionCode(
      int transactionCode) async {
    final db = await SQLHelper.db();
    return db.query('sales_details',
        where: "transaction_code = ?", whereArgs: [transactionCode]);
  }

  /// * get Sales Product Count With Description for Pie Chart*
  static Future<List<Map<String, dynamic>>>
      getSalesProductCountWithDescription() async {
    final db = await SQLHelper.db();
    final todayFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());

    //   return db.rawQuery('''
    //   SELECT p.description, s.product_code, COUNT(s.ordering_level) as count
    //   FROM sales_details s
    //   INNER JOIN products p ON s.product_code = p.product_code
    //   WHERE date(s.created_at) = '$todayFormatted'
    //   GROUP BY s.product_code
    // ''');

    return db.rawQuery('''
    SELECT description, SUM(ordering_level) AS count
    FROM sales_details
    WHERE DATE(created_at) = '$todayFormatted'
    GROUP BY description;

  ''');
  }
}
