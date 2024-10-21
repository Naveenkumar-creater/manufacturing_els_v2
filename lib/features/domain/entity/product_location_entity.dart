import 'package:equatable/equatable.dart';

class ProductLocationEntity extends Equatable {
    ProductLocationEntity({
        required this.itemProductionArea,
    });

    final List<ItemProductionAreaEntity> itemProductionArea;


    @override
    List<Object?> get props => [
    itemProductionArea, ];
}

class ItemProductionAreaEntity extends Equatable {
    ItemProductionAreaEntity({
        required this.ipaId,
        required this.ipaName,
    });

    final int? ipaId;
    final String? ipaName;

   
    @override
    List<Object?> get props => [
    ipaId, ipaName, ];
}