import 'package:sqflite/sqflite.dart';
import '../core/database.dart';
import '../models/livro.dart';

class LivroDao {
  static const String table = 'livros';

  Future<int> insertLivro(Livro livro) async {
    final db = await AppDatabase().database;
    return await db.insert(table, livro.toMap());
  }

  Future<List<Livro>> getLivrosDoUsuario(int usuarioId) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      table,
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
    return maps.map((map) => Livro.fromMap(map)).toList();
  }

  Future<List<Livro>> getTodosLivrosAVenda() async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      table,
      where: 'estaAVenda = ?',
      whereArgs: [1],
    );
    return maps.map((map) => Livro.fromMap(map)).toList();
  }

  Future<void> deleteLivro(int id) async {
    final db = await AppDatabase().database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateLivro(Livro livro) async {
    final db = await AppDatabase().database;
    await db.update(
      table,
      livro.toMap(),
      where: 'id = ?',
      whereArgs: [livro.id],
    );
  }

  Future<List<Livro>> buscarLivrosPorTermo(String termo) async {
    final db = await AppDatabase().database;

    final termoFormatado = '%$termo%';

    final maps = await db.query(
      table,
      where: '(titulo LIKE ? OR autor LIKE ?) AND estaAVenda = ? AND quantidade > 0',
      whereArgs: [termoFormatado, termoFormatado, 1],
    );

    return maps.map((map) => Livro.fromMap(map)).toList();
  }

}
