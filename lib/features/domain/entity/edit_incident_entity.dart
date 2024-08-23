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
        required this.incmName,
        required this.ipdincId,
        required this.ipdincIpdId,
        required this.ipdincIncmId,
        required this.ipdincNotes,
        required this.ipdincIncrcmId,
    });

    final String? subincidentName;
    final String? incmName;
    final int? ipdincId;
    final int? ipdincIpdId;
    final int? ipdincIncmId;
    final String? ipdincNotes;
    final int? ipdincIncrcmId;

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
  ];
  
}