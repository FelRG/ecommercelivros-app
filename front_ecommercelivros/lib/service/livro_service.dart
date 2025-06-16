import '../models/livro.dart';
import '../persistence/livro_dao.dart';

class LivroService {
  final LivroDao _livroDao = LivroDao();

  Future<int> adicionarLivro(Livro livro) async {
    return await _livroDao.insertLivro(livro);
  }

  Future<List<Livro>> buscarLivrosDoUsuario(int usuarioId) async {
    return await _livroDao.getLivrosDoUsuario(usuarioId);
  }

  Future<List<Livro>> buscarLivrosAVenda() async {
    return await _livroDao.getTodosLivrosAVenda();
  }

  Future<void> atualizarLivro(Livro livro) async {
    await _livroDao.updateLivro(livro);
  }

  Future<void> removerLivro(int id) async {
    await _livroDao.deleteLivro(id);
  }
}
