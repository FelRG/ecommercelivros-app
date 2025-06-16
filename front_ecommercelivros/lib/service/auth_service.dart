import '../persistence/user_dao.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final UserDao _userDao = UserDao();

  Future<bool> register(User user) async {
    try {
      await _userDao.insertUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> login(String email, String password) async {
    final user = await _userDao.getUser(email, password);
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('usuario_id', user.id!);
    }
    return user;
  }

  // Future<User?> login(String email, String password) async {
  //   return await _userDao.getUser(email, password);
  // }

  Future<int?> getUsuarioIdLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuario_id');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_id');
  }

}
