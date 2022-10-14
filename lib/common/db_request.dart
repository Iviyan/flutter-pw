

abstract class DbRequest {
  static const String tableRoles = 'roles';
  static const String tableUsers = 'users';
  static const String tableClothingManufacturer = 'clothing_manufacturers';
  static const String tableClothingModel = 'clothing_models';
  static const String tableClothes = 'clothes';
  static const String tableCart = 'cart';
  static const String tableFavourites = 'favourites';
  static const String tableReceipts = 'receipts';
  static const String tableReceiptGoods = 'receipt_goods';

  static const List<String> createDbSqlList = [
    createTableRole,
    createTableUsers,
    createTableClothingManufacturer,
    createTableClothingModel,
    createTableClothes,
    createTableCart,
    createTableFavourites,
    createTableReceipts
  ];

  static const String createTableRole =
'''CREATE TABLE "$tableRoles" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
)''';

  static const String createTableUsers =
'''CREATE TABLE $tableUsers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  login	TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  role_id INTEGER NOT NULL REFERENCES roles(id)
)''';

 static const String createTableClothingManufacturer =
'''CREATE TABLE $tableClothingManufacturer (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
)''';

 static const String createTableClothingModel =
'''CREATE TABLE $tableClothingModel (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  clothing_manufacturer_id INTEGER NOT NULL REFERENCES $tableClothingManufacturer(id),
  name TEXT NOT NULL,
  price	REAL NOT NULL
)''';

 static const String createTableClothes =
'''CREATE TABLE $tableClothes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  clothing_model_id INTEGER NOT NULL REFERENCES $tableClothingModel(id),
  size INTEGER NOT NULL,
  sold INTEGER NOT NULL DEFAULT FALSE
)''';

 static const String createTableCart =
'''CREATE TABLE $tableCart (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  role_id INTEGER NOT NULL REFERENCES $tableRoles(id),
  clothes_id INTEGER NOT NULL REFERENCES $tableClothes(id)
)''';

 static const String createTableFavourites =
'''CREATE TABLE $tableFavourites (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  role_id INTEGER NOT NULL REFERENCES $tableRoles(id),
  clothes_id INTEGER NOT NULL REFERENCES $tableClothes(id)
)''';

 static const String createTableReceipts =
'''CREATE TABLE $tableReceipts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  role_id INTEGER NOT NULL REFERENCES $tableRoles(id),
  datetime INTEGER NOT NULL,
  amount REAL NOT NULL
)''';

 static const String createTableReceiptGoods =
'''CREATE TABLE $tableReceiptGoods (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  receipt_id INTEGER NOT NULL REFERENCES $tableReceipts(id),
  clothes_id INTEGER NOT NULL REFERENCES $tableClothes(id)
)''';

  static String deleteTable(String tableName) =>'drop table $tableName';
}