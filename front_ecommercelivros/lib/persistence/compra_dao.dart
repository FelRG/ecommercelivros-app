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

    // 1. Verifica se todos os produtos têm quantidade suficiente
    for (final item in produtos) {

      print('Checando livro com id: $item');

      final livroId = item['livro_id'];
      final quantidadeDesejada = (item['quantidade'] as num).toInt();

      final resultado = await db.rawQuery(
        'SELECT quantidade FROM livros WHERE id = ?',
        [livroId],
      );

      if (resultado.isEmpty) {
        throw Exception('Livro não encontrado (ID: $livroId $resultado).');
      }

      final quantidadeAtual = resultado.first['quantidade'] as int;

      if (quantidadeAtual < quantidadeDesejada) {
        throw Exception(
          'Estoque insuficiente para o livro ID $livroId. '
              'Disponível: $quantidadeAtual, Solicitado: $quantidadeDesejada.',
        );
      }
    }

    final dataCompra = DateTime.now().toIso8601String();
    final total = produtos.fold(
      0.0,
          (soma, p) => soma + ((p['preco'] as num) * (p['quantidade'] as num)),
    );

    // 2. Executa a transação
    await db.transaction((txn) async {
      final compraId = await txn.insert('compras', {
        'usuario_id': usuarioId,
        'data_compra': dataCompra,
        'total': total,
      });

      for (final item in produtos) {
        final livroId = item['livro_id'];
        final quantidade = (item['quantidade'] as num).toInt();
        final preco = (item['preco'] as num).toDouble();

        // 2.1 Inserir item comprado
        await txn.insert('itens_compra', {
          'compra_id': compraId,
          'livro_id': livroId,
          'quantidade': quantidade,
          'preco_unitario': preco,
        });

        // 2.2 Atualiza a quantidade no estoque
        final rows = await txn.rawUpdate(
          '''
          UPDATE livros
          SET quantidade = quantidade - ?
          WHERE id = ? AND quantidade >= ?
          ''',
          [quantidade, livroId, quantidade],
        );

        if (rows == 0) {
          throw Exception('Falha ao atualizar estoque do livro ID $livroId.');
        }

        // 2.3 Verifica se o estoque chegou a zero e marca como indisponível
        final resultadoAtualizado = await txn.rawQuery(
          'SELECT quantidade FROM livros WHERE id = ?',
          [livroId],
        );

        if (resultadoAtualizado.isNotEmpty && (resultadoAtualizado.first['quantidade'] as int) == 0) {
          await txn.update(
            'livros',
            {'estaAVenda': 0},
            where: 'id = ?',
            whereArgs: [livroId],
          );
        }
      }

      // 3. Limpa o carrinho após a compra
      await txn.delete('carrinho', where: 'usuario_id = ?', whereArgs: [usuarioId]);
    });
  }

  Future<List<Map<String, dynamic>>> getComprasUsuario(int usuarioId) async {
    final db = await AppDatabase().database;

    final resultado = await db.rawQuery('''
      SELECT c.id as compra_id, c.data_compra, c.total,
             SUM(ic.quantidade) as quantidade_total,
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
