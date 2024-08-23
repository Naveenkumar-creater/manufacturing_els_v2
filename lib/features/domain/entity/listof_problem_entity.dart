import 'package:equatable/equatable.dart';

class ListOfProblemEntity extends Equatable{
    ListOfProblemEntity({
      this.listOfIncident,
    });
    final List<ListOfIncidentEntity>? listOfIncident;
    
      @override
      List<Object?> get props => [listOfIncident];

}


class ListOfIncidentEntity extends Equatable  {
    ListOfIncidentEntity({
      this.incmMpmId,
      this.incmName,
      this.incmId,
      this.incmDesc,
      this.incmParentId,
    });

    final int? incmMpmId;
    final String? incmName;
    final int? incmId;
    final String? incmDesc;
    final int? incmParentId;
    
      @override
      List<Object?> get props => [
       incmMpmId,
       incmName,
       incmId,
      incmDesc,
      incmParentId,
      ];
}