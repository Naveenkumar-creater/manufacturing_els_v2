

import '../entity/login_entity.dart';

abstract class LoginRepository {
  Future<LoginEntity> loginInUser(String loginId, String password);
}
