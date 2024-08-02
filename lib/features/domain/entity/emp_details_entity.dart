import 'package:equatable/equatable.dart';

class EmpDetailsEntity extends Equatable {
  final List<ListofEmpDetailsEntity>? listofEmpDetailsEntity;

  const EmpDetailsEntity({
    this.listofEmpDetailsEntity,
  });

  @override
  List<Object?> get props => [listofEmpDetailsEntity];
}

class ListofEmpDetailsEntity extends Equatable {
  const ListofEmpDetailsEntity(
      {required this.empdept,
      required this.empname,
      required this.empmgr,
      required this.empdesig,
      required this.empid});

  final int? empdept;
  final String? empname;
  final int? empmgr;
  final int? empid;
  final String? empdesig;

  @override
  List<Object?> get props => [empdept, empname, empmgr, empid, empdesig];
}
