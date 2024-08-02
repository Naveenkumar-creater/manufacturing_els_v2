import 'package:equatable/equatable.dart';

class EditEntryEntity extends Equatable {
    EditEntryEntity({
        required this.editEntry,
    });

    final EditEntrySubEntity? editEntry;
    
      @override
     
      List<Object?> get props => [editEntry];


}

class EditEntrySubEntity extends Equatable {
    EditEntrySubEntity({
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


        
    });

    final int? ipdMpmId;
    final String ? ipdToTime;
    final int? ipdReworkFlag;
    final int? ipdAssetId;
    final int? ipdBatchNo;
    final int? ipdCardNo;
    final int? ipdRejQty;
    final int? ipdDeptId;
    final String ? ipdDate;
    final int? ipdGoodQty;
    final int? ipdItemId;
    final int? ipdId;
    final String ? ipdFromTime;
    final int? ipdPcId;
    final int? ipdPaId;
    // final int? personId;
    final int? totalGoodqty;
    final int? totalRejqty;

    
        final int ? ipdPwsEmpCount ;

     final int ? ipdReworkableQty;
      final int? ipdScrapQty;
       final int ?pwsId;

  
    
      @override
      // TODO: implement props
      List<Object?> get props => [
            ipdMpmId,
            ipdToTime,
            ipdReworkFlag,
            ipdAssetId,
            ipdBatchNo,
            ipdCardNo,
            ipdRejQty,
            ipdDeptId,
            ipdDate,
            ipdGoodQty,
            ipdItemId,
            ipdId,
            ipdPcId,
            ipdPaId,
   
    ];

}
