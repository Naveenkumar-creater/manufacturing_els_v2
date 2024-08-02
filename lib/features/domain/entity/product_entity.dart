import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final List<ListofProductEntity>? listofProductEntity;

  const ProductEntity({
    this.listofProductEntity,
  });

  @override
  List<Object?> get props => [listofProductEntity];
}

class ListofProductEntity extends Equatable {
  const ListofProductEntity(
      {required this.productName,
      //required this.plannedQty,
      required this.productid});

  final String? productName;
  // final int? plannedQty;
  final int? productid;

  @override
  List<Object?> get props => [
        productName, 
        productid
        //,plannedQty
      ];
}
