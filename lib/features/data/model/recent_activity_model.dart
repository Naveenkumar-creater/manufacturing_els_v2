import '../../domain/entity/recent_activity_entity.dart';








class RecentActivitiesModel extends RecentActivitiesEntity{
   RecentActivitiesModel({required this.recentActivitiesList}) : super(recentActivitesEntityList:recentActivitiesList);

    final List<RecentActivitiesList> recentActivitiesList;

    factory RecentActivitiesModel.fromJson(Map<String, dynamic> json){ 
        return RecentActivitiesModel(
            recentActivitiesList: json['response_data']["List_Of_Recent_Activities"] == null ? [] : List<RecentActivitiesList>.from(json['response_data']["List_Of_Recent_Activities"]!.map((x) => RecentActivitiesList.fromJson(x))),
        );
    }

   


}


class RecentActivitiesList extends RecentActivitiesEntityList{

    final String? ipdCardNo;
    final int? ipdRejQty;
    final int? ipdGoodQty;
    final int? ipdEmpId;
    final DateTime? ipdToTime;
    final int? ipdItemId;
    final int? ipdReworkFlag;
    final DateTime? ipdFromTime;
    final int? ipdAssetId;
    final int? ipdid;
    final int?ipdpsid;
    final int? processid;
    final int? deptid;
    final int?ipdpaid;
    final int?ipdpcid;

    RecentActivitiesList( {
        required this.ipdCardNo,
        required this.ipdRejQty,
        required this.ipdGoodQty,
        required this.ipdEmpId,
        required this.ipdToTime,
        required this.ipdItemId,
        required this.ipdReworkFlag,
        required this.ipdFromTime,
        required this.ipdAssetId,
        required this.ipdid,
        required this.ipdpsid,
        required this.processid,
        required this.deptid,
        required this.ipdpaid,
        required this.ipdpcid

    }):super(ipdid:ipdid,processid:processid,deptid:deptid,   ipdpsid:ipdpsid, ipdassetid: ipdAssetId,ipdcardno: ipdCardNo,ipdempid: ipdEmpId,ipdfromtime: ipdFromTime,ipdgoodqty: ipdGoodQty,ipditemid: ipdItemId,ipdrejqty: ipdRejQty,ipdreworkflag: ipdReworkFlag,ipdtotime: ipdToTime,
    
    ipdpaid:ipdpaid ,ipdpcid: ipdpcid);

  

    factory RecentActivitiesList.fromJson(Map<String, dynamic> json){ 
        return RecentActivitiesList(

            ipdCardNo: json["ipd_card_no"],
            processid:json["ipd_mpm_id"],
            ipdRejQty: json["ipd_rej_qty"],
            ipdGoodQty: json["ipd_good_qty"],
            ipdEmpId: json["ipd_emp_id"],
            ipdToTime: DateTime.tryParse(json["ipd_to_time"] ?? ""),
            ipdItemId: json["ipd_item_id"],
            ipdReworkFlag: json["ipd_rework_flag"],
            ipdFromTime: DateTime.tryParse(json["ipd_from_time"] ?? ""),
            ipdAssetId: json["ipd_asset_id"],
            ipdid: json["ipd_id"],
            ipdpsid:json["ipd_ps_id"],
            deptid: json["ipd_dept_id"],
            ipdpaid: json["ipd_pa_id"],
            ipdpcid: json["ipd_pc_id"]
        );
    }

 

}