// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../domain/entity/emp_production_entity.dart';

class EmpProductionModel extends EmpProductionEntity {
  final ListProductionEntry? productionEntry;

  EmpProductionModel({required this.productionEntry})
      : super(empProductionEntity: productionEntry);

  // factory EmpProductionModel.fromJson(Map<String, dynamic> json) {
  //   final responseData = json['response_data'];
  //   final empProductionData = responseData?['Emp_Production'] ?? [];
  //   return EmpProductionModel(
  //     productionEntry: empProductionData.isNotEmpty
  //         ? List<ListProductionEntry>.from(
  //             empProductionData.map((x) => ListProductionEntry.fromJson(x)))
  //         : [],
  //   );
  // }

  factory EmpProductionModel.fromJson(Map<String, dynamic> json) {
    return EmpProductionModel(
      productionEntry: json["response_data"]["Emp_Production"] == null
          ? null
          //     ListProductionEntry(
          //   mpmbatchprocess: 0,
          //   personid: 0,
          //   ipdcardno: 0,
          //   ipdmpmid: 0,
          //   rejqty: 0,
          //   goodqty: 0,
          //   ipdid: 0,
          //   ipdpcid: 0,
          //   ipdassetid: 0,
          //   ipdflagid: 0,
          //   ipddate: '',
          //   ipdfromtime:"" ,
          //   ipdtotime: "",
          //   ipddeptid: 0,
          //   itemid: 0,
          // )

          : ListProductionEntry.fromJson(
              json["response_data"]["Emp_Production"]),
    );
  }
}

class ListProductionEntry extends ListOfEmpProductionEntity {
  final int? ipdcardno;
  final int? ipdmpmid;
  final int? rejqty;
  final int ? goodqty;
  final int? ipdid;
  final int? ipdpcid;
  final int? ipdassetid;
  final int? ipdflagid;
  final String? ipddate;
  final String? ipdfromtime;
  final String? ipdtotime;
  final int? itemid;
  final int? ipddeptid;
  final int? ipdbatchno;
  // final int?personid;
  final int? ipdpaid;
  final int?totalRejqty;
  final int? totalGoodqty;
  final int? ipdpwsempcount;
  final int? ipdscrapqty;
  final int? pwsid;
  final int ? ipdreworkableqty;
  final int?pwseempid;

  const ListProductionEntry(
      {required this.ipdcardno,
      // required this.personid,
      required this.ipdbatchno,
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
      required this.ipddeptid,
      required this.itemid,
      required this.ipdpaid,
      required this.totalGoodqty,
      required this.ipdpwsempcount,
      required this.ipdreworkableqty,
      required this.ipdscrapqty,
      required this.pwsid,
   required this.pwseempid,
      required this.totalRejqty
      })
      : super(
            ipdcardno: ipdcardno,
            ipdmpmid: ipdmpmid,
            rejqty: rejqty,
            goodqty: goodqty,
            ipdid: ipdid,
            ipdpcid: ipdpcid,
            ipdassetid: ipdassetid,
            ipdflagid: ipdflagid,
            ipddate: ipddate,
            ipdfromtime: ipdfromtime,
            ipdtotime: ipdtotime,
            ipddeptid: ipddeptid,
            itemid: itemid,
            ipdbatchno: ipdbatchno,
            // personid:personid,
            ipdpaid: ipdpaid,
            totalGoodqty: totalGoodqty,
            ipdpwsempcount: ipdpwsempcount,
            ipdreworkableqty: ipdreworkableqty,
            ipdscrapqty: ipdscrapqty,
            pwsid: pwsid,
            pwseempid:pwseempid,
            totalRejqty:totalRejqty,
            );

  factory ListProductionEntry.fromJson(Map<String, dynamic> json) {
    return ListProductionEntry(
      ipdcardno: json['ipd_card_no'],
      ipdmpmid: json['ipd_mpm_id'],
      rejqty: json['ipd_rej_qty'],
      goodqty: json['ipd_good_qty'],
      ipdid: json['ipd_id'],
      ipdpcid: json['ipd_pc_id'],
      ipdassetid: json['ipd_asset_id'],
      ipdflagid: json['ipd_rework_flag'],
      ipddate: json['ipd_date'],
      ipdfromtime: json['ipd_from_time'],
      ipdpaid: json['ipd_pa_id'],
      ipdtotime: json['ipd_to_time'],
      itemid: json['ipd_item_id'],
      ipddeptid: json["ipd_dept_id"],

      ipdbatchno: json["ipd_batch_no"],
      totalGoodqty: json["totalgoodqty"],
      ipdpwsempcount: json["ipd_pws_emp_count"],

      ipdreworkableqty: json["ipd_reworkable_qty"],
      ipdscrapqty: json["ipd_scrap_qty"],
       pwsid: json["pws_id"],

        pwseempid  :json["pwse_emp_id"],

      totalRejqty:json["totalrejqty"],

      //  personid:json["person_id"],
    );
  }

   




  // static DateTime? _parseDateString(String? dateString) {
  //   if (dateString == null || dateString.isEmpty) {
  //     return null;
  //   }
  //   try {
  //     // Parse the date string using the specific format
  //     return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateString);
  //   } catch (e) {
  //     // Handle parsing errors
  //     print('Error parsing date: $e');
  //     return null;
  //   }
  // }

  Map<String, dynamic> toJson() => {
        "ipd_card_no": ipdcardno,
        "ipd_mpm_id": ipdmpmid,
        "ipd_rej_qty": rejqty,
        "ipd_date": ipddate,
        "ipd_good_qty": goodqty,
        "ipd_to_time": ipdtotime,
        "ipd_item_id": itemid,
        "ipd_rework_flag": ipdflagid,
        "ipd_id": ipdid,
        "ipd_from_time": ipdfromtime,
        "ipd_pc_id": ipdpcid,
        "ipd_asset_id": ipdassetid,
        "ipd_dept_id": ipddeptid,
        "ipd_batch_no": ipdbatchno
      };
}



