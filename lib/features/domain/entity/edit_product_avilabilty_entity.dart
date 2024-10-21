import 'package:equatable/equatable.dart';

class EditProductAvilabiltyEntity extends Equatable {
    EditProductAvilabiltyEntity({
        required this.editproductqty,
    });

    final EditProductQtyEntity ? editproductqty;


    @override
    List<Object?> get props => [
    editproductqty, ];
}

class EditProductQtyEntity extends Equatable {
    EditProductQtyEntity({
           required this.imfgpProcessSeq,
        required this.ipcwGoodQtyAvl,

    });

  final int? imfgpProcessSeq;
    final int? ipcwGoodQtyAvl;


    @override
    List<Object?> get props => [
 imfgpProcessSeq,ipcwGoodQtyAvl];
}
