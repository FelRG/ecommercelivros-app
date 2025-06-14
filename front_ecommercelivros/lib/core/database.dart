import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'ecommercelivros_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            password TEXT
          )
        ''');

        // Tabela de livros
        await db.execute('''
          CREATE TABLE livros (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            autor TEXT NOT NULL,
            preco REAL NOT NULL,
            urlImagem TEXT,
            quantidade INTEGER NOT NULL,
            descricao TEXT,
            estaAVenda INTEGER NOT NULL, -- 1 para Sim, 0 para Não
            usuario_id INTEGER NOT NULL,
            FOREIGN KEY (usuario_id) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');

        // Tabela de carrinho
        await db.execute('''
          CREATE TABLE carrinho (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL,
            livro_id INTEGER NOT NULL,
            quantidade INTEGER NOT NULL,
            FOREIGN KEY (usuario_id) REFERENCES users(id) ON DELETE CASCADE,
            FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE
          )
        ''');

        // Tabela de compras
        await db.execute('''
          CREATE TABLE compras (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL,
            data_compra TEXT NOT NULL,
            total REAL NOT NULL,
            FOREIGN KEY (usuario_id) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');

        // Itens de uma compra
        await db.execute('''
          CREATE TABLE itens_compra (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            compra_id INTEGER NOT NULL,
            livro_id INTEGER NOT NULL,
            quantidade INTEGER NOT NULL,
            preco_unitario REAL NOT NULL,
            FOREIGN KEY (compra_id) REFERENCES compras(id) ON DELETE CASCADE,
            FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}
