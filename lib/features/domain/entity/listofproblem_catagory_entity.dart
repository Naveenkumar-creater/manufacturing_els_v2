import 'package:equatable/equatable.dart';

class ListOfProblemCategoryEntity extends Equatable{
    ListOfProblemCategoryEntity({
      this.listOfIncidentCategory,
    });
    final List<ListOfIncidentCategoryEntity>? listOfIncidentCategory;
    
      @override
      List<Object?> get props => [listOfIncidentCategory];

}


class ListOfIncidentCategoryEntity extends Equatable  {
    ListOfIncidentCategoryEntity({
      this.incmMpmId,
      this.incmName,
      this.incmId,
      this.incmDesc,
      this.incmParentId,
       this.incmassettype,this.incmassetid, this.incmparentid, 
    });

    final int? incmMpmId;
    final String? incmName;
    final int? incmId;
    final String? incmDesc;
    final int? incmParentId;
     final int? incmassettype;
    final int? incmassetid;
    final int?incmparentid;
    
      @override
      List<Object?> get props => [
       incmMpmId,
       incmName,
       incmId,
      incmDesc,
      incmParentId,
      ];
}