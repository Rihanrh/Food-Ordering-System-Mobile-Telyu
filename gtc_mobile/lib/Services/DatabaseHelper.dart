import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gtc_mobile/Models/CartItemModel.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE cart_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      idTenant INTEGER NOT NULL,
      idMenu INTEGER NOT NULL,
      quantity INTEGER NOT NULL,
      harga INTEGER NOT NULL
    )
    ''');
  }

  // Insert a new cart item
  Future<int> insertCartItem(CartItemModel cartItem) async {
    final db = await instance.database;
    return await db.insert('cart_items', cartItem.toJson());
  }

// Update an existing cart item
  Future<int> updateCartItem(CartItemModel cartItem) async {
    final db = await instance.database;
    final updatedCartItem = cartItem.toJson()..remove('id'); // Exclude id field
    return await db.update(
      'cart_items',
      updatedCartItem,
      where: 'idTenant = ? AND idMenu = ?',
      whereArgs: [cartItem.idTenant, cartItem.idMenu],
    );
  }

// Delete a cart item
  Future<int> deleteCartItem(int idTenant, int idMenu) async {
    final db = await instance.database;
    return await db.delete(
      'cart_items',
      where: 'idTenant = ? AND idMenu = ?',
      whereArgs: [idTenant, idMenu],
    );
  }

  Future<List<Map<String, dynamic>>> queryCartItems() async {
    final db = await instance.database;
    return await db.query('cart_items');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
