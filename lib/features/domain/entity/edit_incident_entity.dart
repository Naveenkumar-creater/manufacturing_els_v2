import 'package:equatable/equatable.dart';

class EditIncidentListEntity extends Equatable{
      EditIncidentListEntity({
        required this.editIncidentList,
    });

    final List<EditIncidentEntity> editIncidentList;
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
  
}


class EditIncidentEntity extends Equatable {

EditIncidentEntity({
        required this.subincidentName,
        required this.problemStatusId,
        required this.incmName,
        required this.ipdincProblemEndTime,
        required this.ipdincId,
        required this.solId,
        required this.ipdincProductionStoppage,
        required this.ipdincIpdId,
        required this.ipdincIncmId,
        required this.ipdincNotes,
        required this.ipdincIncrcmId,
        required this.fromTime,
        required this.rootcauseDetails,
        required this.rootcauseName,
         required this.incidentId,
        required this.ipdincipdId,
        required this.subincidentId
    });

  
    final String? subincidentName;
    final int? problemStatusId;
    final String? incmName;
    final String? ipdincProblemEndTime;
    final int? ipdincId;
    final int? solId;
    final int? ipdincProductionStoppage;
    final int? ipdincIpdId;
    final int? ipdincIncmId;
    final String? ipdincNotes;
    final int? ipdincIncrcmId;
    final String? fromTime;
    final String ? rootcauseDetails;
    final String ?rootcauseName;
     final int? ipdincipdId;
    final int?incidentId;
    final int?subincidentId;
    

  @override
  // TODO: implement props
  List<Object?> get props => [
          subincidentName,
    incmName,
      ipdincId,
      ipdincIpdId,
    ipdincIncmId,
      ipdincNotes,
  ipdincIncrcmId,
  rootcauseName,
  fromTime,
  rootcauseDetails,
  ipdincipdId,
  incidentId,
    subincidentId

  ];
  
}