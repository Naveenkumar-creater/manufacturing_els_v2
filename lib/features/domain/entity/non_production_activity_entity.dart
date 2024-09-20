import 'package:equatable/equatable.dart';

class NonProductionActivityEntity extends Equatable {
    NonProductionActivityEntity({
        required this.nonProductionActivity,
    });

    final List<NonProductionEntity>? nonProductionActivity;
    
      @override
      // TODO: implement props
      List<Object?> get props => [nonProductionActivity] ;


}

class NonProductionEntity extends Equatable {
    NonProductionEntity({
        required this.npamId,
        required this.npamName,
    });

    final int? npamId;
    final String? npamName;


    
      @override
      // TODO: implement props
      List<Object?> get props =>[npamId,npamName];

}