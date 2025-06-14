import '../models/livro.dart';
import '../persistence/livro_dao.dart';

class LivroService {
  final LivroDao _livroDao = LivroDao();

  Future<int> adicionarLivro(Livro livro) async {
    return await _livroDao.insertLivro(livro);
  }

  Future<List<Livro>> buscarTodosOsLivros() async {
    return await _livroDao.getLivros();
  }

  Future<List<Livro>> buscarLivrosAVendaDeOutrosUsuarios(int usuarioId) async {
    return await _livroDao.getLivrosAVendaDeOutrosUsuarios(usuarioId);
  }

  Future<List<Livro>> buscarLivrosDoUsuario(int usuarioId) async {
    return await _livroDao.getLivrosDoUsuario(usuarioId);
  }

  Future<int> atualizarLivro(Livro livro) async {
    return await _livroDao.updateLivro(livro);
  }

  Future<int> removerLivro(int id) async {
    return await _livroDao.deleteLivro(id);
  }
}
