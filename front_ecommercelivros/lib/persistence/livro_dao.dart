import '../models/livro.dart';
import '../core/database.dart';

class LivroDao {
  static const String table = 'livros';

  Future<int> insertLivro(Livro livro) async {
    final db = await AppDatabase().database;
    return db.insert(table, livro.toMap());
  }

  Future<List<Livro>> getLivros() async {
    final db = await AppDatabase().database;
    final result = await db.query(table);
    return result.map((map) => Livro.fromMap(map)).toList();
  }

  Future<List<Livro>> getLivrosAVendaDeOutrosUsuarios(int usuarioId) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'estaAVenda = ? AND usuario_id != ?',
      whereArgs: [1, usuarioId],
    );
    return result.map((map) => Livro.fromMap(map)).toList();
  }

  Future<List<Livro>> getLivrosDoUsuario(int usuarioId) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
    return result.map((map) => Livro.fromMap(map)).toList();
  }

  Future<int> updateLivro(Livro livro) async {
    final db = await AppDatabase().database;
    return db.update(
      table,
      livro.toMap(),
      where: 'id = ?',
      whereArgs: [livro.id],
    );
  }

  Future<int> deleteLivro(int id) async {
    final db = await AppDatabase().database;
    return db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
