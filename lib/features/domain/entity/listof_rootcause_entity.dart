import 'package:equatable/equatable.dart';

class ListOfRootCauseEntity extends Equatable {
  final List<ListrootcauseEntity>? listrootcauseEntity;

  const ListOfRootCauseEntity ({this.listrootcauseEntity});

  @override
  List<Object?> get props => [listrootcauseEntity];
}

class ListrootcauseEntity extends Equatable  {
    ListrootcauseEntity({
       this.incrcmid,
  this.incrcmincmid,
     this.incrcmmpmid,
    this.incrcmrootcausebrief,
   this.increcmrootcausedetails 
    });

final String ? increcmrootcausedetails;
final String? incrcmrootcausebrief;
final int?incrcmid;
final int?incrcmincmid;
final int?incrcmmpmid;
    
      @override
      List<Object?> get props => [
            incrcmid,
  incrcmincmid,
     incrcmmpmid,
    incrcmrootcausebrief,
   increcmrootcausedetails 
      ];
}