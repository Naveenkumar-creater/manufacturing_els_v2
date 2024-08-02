
import 'package:prominous/features/data/model/login_model.dart';

import '../../core/login_api_client.dart';

abstract class LoginDataSource {
  Future<LoginModel> loginInUser(String loginId, String password);
}

class LoginDataSourceImpl extends LoginDataSource {
  final LoginApiClient loginClient;

  LoginDataSourceImpl(this.loginClient);

  @override
  Future<LoginModel> loginInUser(String loginId, String password) async {
    final response = await loginClient.post(loginId, password);

    final result = LoginModel.fromJson(response);
  
    print(result);

    return result;
  }
}
