
class NonProductionEntryModel {
  NonProductionEntryModel( {
    
    this.npamName,this.npamId, this.npamFromTime, this.npamToTime, this.notes, required this. orgid }
      );
  final int?npamId;
  final String? npamFromTime;
   final String? npamToTime;
  final String ? notes;
  final String ?npamName;
  final int? orgid;

Map<String, dynamic> toJson() => {

"npam_id": npamId,
"npam_name":npamName,
"from_time":npamFromTime,
"to_time": npamToTime,
"notes":notes ,
"org_id":orgid

 };
}


