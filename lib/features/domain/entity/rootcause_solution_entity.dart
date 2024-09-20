import 'package:equatable/equatable.dart';

class RootcauseSolutionEntity extends Equatable {
  final List<SolutionEntity>? solutionEntity;

  const RootcauseSolutionEntity ({this.solutionEntity});

  @override
  List<Object?> get props => [solutionEntity];
}

class SolutionEntity extends Equatable  {
    SolutionEntity({
        this.solIncrcmId,
         this.solId,
         this.solStatus,
         this.solAddDate,
         this.solDesc,
    });
    final int? solIncrcmId;
    final int? solId;
    final int? solStatus;
    final String? solAddDate;
    final String? solDesc;
    
      @override
      List<Object?> get props => [
 solIncrcmId,
   solId,
  solStatus,
     solAddDate,
    solDesc,
      ];
}