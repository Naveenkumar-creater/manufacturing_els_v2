import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
    LoginEntity({
        required this.userLoginEntity,
    });

    final UserLoginEntity? userLoginEntity;
    
      @override
     
      List<Object?> get props => [userLoginEntity];


}

class UserLoginEntity extends Equatable {
    UserLoginEntity({

        required this.clientAutToken,
        required this.loginId,
        required this.loginPassword,
        required this.personFname,
        required this.orgId,
        required this.deptName,
        required this.deptId,
        required this.orgName,
    });

    final String? clientAutToken;
    final String? loginId;
    final String? loginPassword;
    final String? personFname;
    final int? orgId;
    final String? deptName;
    final int? deptId;
    final String? orgName;

  
    
      @override
      // TODO: implement props
      List<Object?> get props => [
           clientAutToken,
           loginId,
           loginPassword,
           personFname,
           orgId,
           deptName,
           deptId,
           orgName

    ];

}
