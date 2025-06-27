import 'package:sqflite/sqflite.dart';
import '../core/database.dart';
import '../models/carrinho.dart';
import '../models/livro.dart';

class CarrinhoDao {
  static const String table = 'carrinho';

  Future<int> adicionarAoCarrinho(Carrinho item) async {
    final db = await AppDatabase().database;
    return db.insert(table, item.toMap());
  }

  // Future<List<Map<String, dynamic>>> getCarrinhoCompleto(int usuarioId) async {
  //   final db = await AppDatabase().database;
  //   return await db.rawQuery('''
  //     SELECT c.id, l.titulo, l.preco, l.urlImagem, c.quantidade
  //     FROM carrinho c
  //     JOIN livros l ON l.id = c.livro_id
  //     WHERE c.usuario_id = ?
  //   ''', [usuarioId]);
  // }

  Future<List<Map<String, dynamic>>> getCarrinhoCompleto(int usuarioId) async {
    final db = await AppDatabase().database;
    return await db.rawQuery('''
    SELECT c.id as carrinho_id, c.livro_id, l.titulo, l.preco, l.urlImagem, c.quantidade
    FROM carrinho c
    JOIN livros l ON l.id = c.livro_id
    WHERE c.usuario_id = ?
  ''', [usuarioId]);
  }


  Future<void> removerDoCarrinho(int produtoId) async {
    final db = await AppDatabase().database;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [produtoId],
    );
  }

  Future<void> atualizarQuantidade(int produtoId, int novaQuantidade) async {
    final db = await AppDatabase().database;
    await db.update(
      table,
      {'quantidade': novaQuantidade},
      where: 'id = ?',
      whereArgs: [produtoId],
    );
  }

}
