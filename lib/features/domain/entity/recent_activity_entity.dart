import 'package:equatable/equatable.dart';



class RecentActivitiesEntity extends Equatable {
  final List<RecentActivitiesEntityList> ?recentActivitesEntityList;

  RecentActivitiesEntity({  this.recentActivitesEntityList,});
  
  @override
 
  List<Object?> get props => [];
}

class RecentActivitiesEntityList extends Equatable {
  final int? ipdcardno;
  final int? ipdrejqty;
  final int ?ipdgoodqty;
  final int ?ipdempid;
  final int ?ipditemid;
  final int ?ipdreworkflag;
  final int ?ipdassetid;
  final int? ipdid;
  final DateTime ?ipdfromtime;
  final DateTime ?ipdtotime;
  final int? ipdpsid;
  final int?processid;
  final int?deptid;
  RecentActivitiesEntityList({
      required this.ipdcardno,
      required this.ipdrejqty,
      required this.ipdgoodqty,
      required this.ipdempid,
      required this.ipditemid,
      required this.ipdreworkflag,
      required this.ipdassetid,
      required this.ipdfromtime,
      required this.ipdtotime,
      required this.ipdid,
      required this.processid, 
      required this.ipdpsid,
      required this.deptid
      });

  @override
  List<Object?> get props => [
        ipdcardno,
        ipdid,
        ipdrejqty,
        ipdgoodqty,
        ipdempid,
        ipditemid,
        ipdreworkflag,
        ipdassetid,
        ipdfromtime,
        ipdtotime,
        ipdpsid,
        processid,
        deptid
      ];
}
