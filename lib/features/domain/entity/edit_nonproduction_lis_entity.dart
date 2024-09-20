import 'package:equatable/equatable.dart';

class EditNonProductionListEntity extends Equatable{
    EditNonProductionListEntity({
        required this.listOfNonProductionEntity,
    });

    final List<ListOfNonProductionEntity>? listOfNonProductionEntity;

    
    
      @override
      // TODO: implement props
      List<Object?> get props => [listOfNonProductionEntity];

}

class ListOfNonProductionEntity extends Equatable {
    ListOfNonProductionEntity({
        required this.inpaNpamId,
        required this.inpaToTime,
        required this.inpaNotes,
        required this.npamName,
        required this.inpaFromTime,
        required this.inpaId,
        required this.inpsIpdId,
    });

    final int? inpaNpamId;
    final String? inpaToTime;
    final String ? inpaNotes;
    final String? npamName;
    final String? inpaFromTime;
    final int? inpaId;
    final int? inpsIpdId;


      @override
      // TODO: implement props
      List<Object?> get props => [
  inpaNpamId,
      inpaToTime,
        inpaNotes,
        npamName,
      inpaFromTime,
      inpaId,
        inpsIpdId,
      ];

}

