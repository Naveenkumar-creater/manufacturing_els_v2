import '../entity/login_entity.dart';
import '../repository/login_repository.dart';

class LoginUseCase {
  final LoginRepository loginRepository;

  LoginUseCase(this.loginRepository);

  Future<LoginEntity> execute(String loginId, String password) async {
    return  loginRepository.loginInUser(loginId, password);
  }
}