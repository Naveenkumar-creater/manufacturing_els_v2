import 'package:equatable/equatable.dart';

class ListOfWorkstationEntity extends Equatable{
  final List<ListWorkstationEntity>? listOfWorkstation;

const ListOfWorkstationEntity({this.listOfWorkstation});
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  
}




class ListWorkstationEntity extends Equatable{
   final int? noOfStaff;
    final String? mpmName;
    final String? pwsName;
    final int? mpmId;
    final int? pwsId;
    final int? pwseId;

ListWorkstationEntity({
        required this.noOfStaff,
        required this.mpmName,
        required this.pwsName,
        required this.mpmId,
        required this.pwsId,
        required this.pwseId

});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  
}