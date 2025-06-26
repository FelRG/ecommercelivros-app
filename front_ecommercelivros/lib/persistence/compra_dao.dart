import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/database.dart';

class CompraDao {
  Future<void> realizarCompra(List<Map<String, dynamic>> produtos) async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioId = prefs.getInt('usuario_id');

    if (usuarioId == null || produtos.isEmpty) {
      throw Exception('Usuário não logado ou carrinho vazio.');
    }

    final db = await AppDatabase().database;
    final dataCompra = DateTime.now().toIso8601String();
    final total = produtos.fold(0.0, (soma, p) => soma + (p['preco'] * p['quantidade']));

    await db.transaction((txn) async {
      // 1. Inserir na tabela compras
      final compraId = await txn.insert('compras', {
        'usuario_id': usuarioId,
        'data_compra': dataCompra,
        'total': total,
      });

      // 2. Inserir itens da compra
      for (final item in produtos) {
        print(item);
        await txn.insert('itens_compra', {
          'compra_id': compraId,
          'livro_id': item['id'],
          'quantidade': item['quantidade'],
          'preco_unitario': item['preco'],
        });
      }

      // 3. Esvaziar carrinho
      await txn.delete('carrinho', where: 'usuario_id = ?', whereArgs: [usuarioId]);
    });
  }


  Future<List<Map<String, dynamic>>> getComprasUsuario(int usuarioId) async {
    final db = await AppDatabase().database;

    // Consulta básica que pega compras do usuário com soma da quantidade e total
    final resultado = await db.rawQuery('''
  SELECT c.id as compra_id, c.data_compra, c.total,
         SUM(ic.quantidade) as quantidade_total,
         -- Pega imagem e título do primeiro item da compra
         (SELECT l.urlImagem FROM livros l 
          JOIN itens_compra ic2 ON l.id = ic2.livro_id
          WHERE ic2.compra_id = c.id LIMIT 1) as imagemUrl,
         (SELECT l.titulo FROM livros l 
          JOIN itens_compra ic2 ON l.id = ic2.livro_id
          WHERE ic2.compra_id = c.id LIMIT 1) as titulo
  FROM compras c
  LEFT JOIN itens_compra ic ON c.id = ic.compra_id
  WHERE c.usuario_id = ?
  GROUP BY c.id
  ORDER BY c.data_compra DESC
''', [usuarioId]);

    return resultado;
  }

}
