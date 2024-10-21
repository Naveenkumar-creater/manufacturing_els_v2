import 'package:equatable/equatable.dart';

class ProductAvilableQtyEntity extends Equatable {
    ProductAvilableQtyEntity({
        required this.productqty,
    });

    final ProductQtyEntity ? productqty;


    @override
    List<Object?> get props => [
    productqty, ];
}

class ProductQtyEntity extends Equatable {
    ProductQtyEntity({
           required this.imfgpProcessSeq,
        required this.ipcwGoodQtyAvl,

    });

  final int? imfgpProcessSeq;
    final int? ipcwGoodQtyAvl;


    @override
    List<Object?> get props => [
 imfgpProcessSeq,ipcwGoodQtyAvl];
}
