// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:prominous/features/data/model/emp_production_model.dart';

class EmpProductionEntity extends Equatable {
  final ListOfEmpProductionEntity? empProductionEntity;

  const EmpProductionEntity({this.empProductionEntity});

  @override
  List<Object?> get props => [empProductionEntity];
}

class ListOfEmpProductionEntity extends Equatable {
  final int? ipdcardno;
  final int? ipdmpmid;
  final int? rejqty;
  final int? goodqty;
  final int? ipdid;
  final int? ipdpcid;
  final int? ipdassetid;
  final int? ipdflagid;
  final String? ipddate;
  final String? ipdfromtime;
  final String? ipdtotime;
  final int? itemid;
  final int? ipddeptid;
  final int? ipdpaid;
  final int? ipdbatchno;
  // final int?personid;
  final int? totalRejqty;
  final int? totalGoodqty;
  final int? ipdpwsempcount;
  final int? ipdscrapqty;
  final int? pwsid;
  final int? ipdreworkableqty;
    final int?pwseempid;

  const ListOfEmpProductionEntity( 
      {required this.ipdcardno,
      required this.ipdmpmid,
      required this.rejqty,
      required this.goodqty,
      required this.ipdid,
      required this.ipdpcid,
      required this.ipdassetid,
      required this.ipdflagid,
      required this.ipddate,
      required this.ipdfromtime,
      required this.ipdtotime,
      required this.itemid,
      required this.ipddeptid,
      required this.ipdbatchno,
      //  required this. personid,
      required this.ipdpaid,
      required this.totalGoodqty,
      required this.ipdpwsempcount,
      required this.ipdreworkableqty,
      required this.ipdscrapqty,
      required this.pwsid,
      required this.totalRejqty,
      required this.pwseempid
      });

  @override
  List<Object?> get props => [
        ipdcardno,
        ipdmpmid,
        rejqty,
        goodqty,
        ipdid,
        ipdpcid,
        ipdassetid,
        ipdflagid,
        ipddate,
        ipdfromtime,
        ipdtotime,
        itemid,
        ipddeptid,
        ipdpaid,
        ipdbatchno,
      ];
}
