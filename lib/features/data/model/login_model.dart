import '../../domain/entity/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({
    required this.userLogin,
  }) : super(userLoginEntity: userLogin);

  final UserLogin? userLogin;

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      userLogin: json['response_data']["user_login"] == null
          ? null
          : UserLogin.fromJson(json['response_data']["user_login"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "user_login": userLogin?.toJson(),
      };
}

class UserLogin extends UserLoginEntity {
  UserLogin({
    required this.clientAutToken,
    required this.loginId,
    required this.loginPassword,
    required this.personFname,
    required this.orgId,
    required this.deptName,
    required this.deptId,
    required this.orgName,
  }) : super(
            clientAutToken: clientAutToken,
            deptId: deptId,
            deptName: deptName,
            loginId: loginId,
            loginPassword: loginPassword,
            orgId: orgId,
            orgName: orgName,
            personFname: personFname);

  final String? clientAutToken;
  final String? loginId;
  final String? loginPassword;
  final String? personFname;
  final int? orgId;
  final String? deptName;
  final int? deptId;
  final String? orgName;

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      clientAutToken: json["client_aut_token"],
      loginId: json["login_id"],
      loginPassword: json["login_password"],
      personFname: json["person_fname"],
      orgId: json["org_id"],
      deptName: json["dept_name"],
      deptId: json["dept_id"],
      orgName: json["org_name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "client_aut_token": clientAutToken,
        "login_id": loginId,
        "login_password": loginPassword,
        "person_fname": personFname,
        "org_id": orgId,
        "dept_name": deptName,
        "dept_id": deptId,
        "org_name": orgName,
      };
}







// class LoginModel extends LoginEntity {
//  final String? clientAuthToken;
//     final String? loginId;
//     final String? password;
//     final String? personFname;
//     final int? orgId;
//     final String? deptName;
//     final int? deptId;
//     final String? orgName;


//   const LoginModel({
//      required this.clientAuthToken,
//         required this.loginId,
//         required this.password,
//         required this.personFname,
//         required this.orgId,
//         required this.deptName,
//         required this.deptId,
//         required this.orgName,


//   }) : super(
//           loginId: loginId,
//           password: password,
//           personFname: personFname,
//           deptName: deptName,
//            deptId:deptId,
//             orgId:orgId,

//           orgName: orgName,
//           clientAuthToken: clientAuthToken,
//         );

//   factory LoginModel.fromJson(Map<String, dynamic> json) {

//     // userLogin: json["response_data"]["user_login"] == null ? null : UserLogin.fromJson(json["user_login"]),
//     final userLogin = json['response_data']['user_login'];
//       if (userLogin == null) {
//       throw Exception(
//           'Invalid username or password'); // Throw an exception if asset list is null
//     }

//     return LoginModel(
//  clientAuthToken: json["client_aut_token"],
// loginId: json["login_id"],
//             password: json["login_password"],
//             personFname: json["person_fname"],
//             orgId: json["org_id"],
//             deptName: json["dept_name"],
//             deptId: json["dept_id"],
//             orgName: json["org_name"],



    
//     );
//   }
//     Map<String, dynamic> toJson() {
//     return {
//           "client_aut_token": clientAuthToken,
//         "login_id": loginId,
//         "login_password": password,
//         "person_fname": personFname,
//         "org_id": orgId,
//         "dept_name": deptName,
//         "dept_id": deptId,
//         "org_name": orgName,
//     };
//   }
// }
