

import 'package:prominous/features/domain/entity/edit_entry_entity.dart';

class EditEntryModel extends EditEntryEntity{
    EditEntryModel({
        required this.editEntry,
    }):super(editEntry: editEntry);

    final EditEntry? editEntry;

    factory EditEntryModel.fromJson(Map<String, dynamic> json){ 
        return EditEntryModel(
            editEntry: json["response_data"]["Edit_Entry"] == null ? null : EditEntry.fromJson(json["response_data"]["Edit_Entry"]),
        );
    }

}

class EditEntry extends EditEntrySubEntity {
    EditEntry( {
        required this.ipdMpmId,
        required this.ipdToTime,
        required this.ipdReworkFlag,
        required this.ipdAssetId,
        required this.ipdBatchNo,
        required this.ipdCardNo,
        required this.ipdRejQty,
        required this.ipdDeptId,
        required this.ipdDate,
        required this.ipdGoodQty,
        required this.ipdItemId,
        required this.ipdId,
        required this.ipdFromTime,
        required this.ipdPcId,
        required this.ipdPaId,
        // required this.personId,
        required this.totalGoodqty,
         required this.totalRejqty,
         required this.ipdPwsEmpCount ,

     required this. ipdReworkableQty,
      required this.ipdScrapQty,
       required this.pwsId




    }):super(ipdAssetId:ipdAssetId,ipdBatchNo:ipdBatchNo,ipdCardNo:ipdCardNo,ipdDate: ipdDate,ipdDeptId:ipdDeptId,ipdFromTime: ipdFromTime,
    
    ipdGoodQty: ipdGoodQty,ipdId: ipdId,ipdItemId:ipdItemId,ipdMpmId: ipdMpmId,ipdPaId: ipdPaId,ipdPcId: ipdPcId,ipdRejQty:ipdRejQty ,
    
    ipdReworkFlag: ipdReworkFlag,ipdToTime: ipdToTime,
    // personId: personId, 
    totalGoodqty:totalGoodqty,
    // totalRejqty:totalRejqty,

    ipdPwsEmpCount: ipdPwsEmpCount, ipdReworkableQty: ipdReworkableQty ,ipdScrapQty: ipdScrapQty, pwsId: pwsId, totalRejqty: totalRejqty
     );

    final int? ipdMpmId;
    final String? ipdToTime;
    final int? ipdReworkFlag;
    final int? ipdAssetId;
    final int? ipdBatchNo;
    final int? ipdCardNo;
    final int? ipdRejQty;
    final int? ipdDeptId;
    final String? ipdDate;
    final int? ipdGoodQty;
    final int? ipdItemId;
    final int? ipdId;
    final String? ipdFromTime;
    final int? ipdPcId;
    final int? ipdPaId;
    // final int? personId;
    final int?  totalGoodqty;
    final int?  totalRejqty;

        final int ? ipdPwsEmpCount ;

     final int ? ipdReworkableQty;
      final int? ipdScrapQty;
       final int ?pwsId;

    factory EditEntry.fromJson(Map<String, dynamic> json){ 
        return EditEntry(
            ipdMpmId: json["ipd_mpm_id"],
            ipdToTime: json["ipd_to_time"],
            ipdReworkFlag: json["ipd_rework_flag"],
            ipdAssetId: json["ipd_asset_id"],
            ipdBatchNo: json["ipd_batch_no"],
            ipdCardNo: json["ipd_card_no"],
            ipdRejQty: json["ipd_rej_qty"],
            ipdDeptId: json["ipd_dept_id"],
            ipdDate: json["ipd_date"],
            ipdGoodQty: json["ipd_good_qty"],
            ipdItemId: json["ipd_item_id"],
            ipdId: json["ipd_id"],
            ipdFromTime: json["ipd_from_time"],
            ipdPcId: json["ipd_pc_id"],
            ipdPaId: json["ipd_pa_id"],
            // personId: json["person_id"],
              totalGoodqty:json["totalgoodqty"],
      totalRejqty:json["totalrejqty"],
          
     ipdPwsEmpCount: json["ipd_pws_emp_count"],

      ipdReworkableQty: json["ipd_reworkable_qty"],
      ipdScrapQty: json["ipd_scrap_qty"],
       pwsId: json["pws_id"],








  
      







  


 

        );
    }

}
