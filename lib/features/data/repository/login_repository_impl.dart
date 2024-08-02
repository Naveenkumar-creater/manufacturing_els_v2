import '../../domain/repository/login_repository.dart';
import '../datasource/remote/login_datasource.dart';
import '../model/login_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSourceImpl loginDataSourceImpl;

  LoginRepositoryImpl(this.loginDataSourceImpl);

  @override
  Future<LoginModel> loginInUser(String loginId, String password) async {
    final loginModel = await loginDataSourceImpl.loginInUser(loginId, password);
    return loginModel;
  }
}
