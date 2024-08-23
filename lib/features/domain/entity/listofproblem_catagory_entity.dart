import 'package:equatable/equatable.dart';

class ListOfProblemCatagoryEntity extends Equatable{
    ListOfProblemCatagoryEntity({
      this.listOfIncidentcatagory,
    });
    final List<ListOfIncidentCatagoryEntity>? listOfIncidentcatagory;
    
      @override
      List<Object?> get props => [listOfIncidentcatagory];

}


class ListOfIncidentCatagoryEntity extends Equatable  {
    ListOfIncidentCatagoryEntity({
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