import 'package:prominous/features/domain/entity/edit_product_avilabilty_entity.dart';

class EditProductAvilableQtyModel extends EditProductAvilabiltyEntity {
    EditProductAvilableQtyModel({
        required this.editproductqty,
    }) : super(editproductqty: editproductqty);

    final EditProductQtyModel ?editproductqty;

    factory EditProductAvilableQtyModel.fromJson(Map<String, dynamic> json){ 
        return EditProductAvilableQtyModel(
            editproductqty: json['response_data']["Item Process Card Wip"] == null ?null :EditProductQtyModel.fromJson(json['response_data']["Item Process Card Wip"])
        );
    }



}

class EditProductQtyModel extends EditProductQtyEntity{
    EditProductQtyModel({
           required this.imfgpProcessSeq,
        required this.ipcwGoodQtyAvl,
      
    }) : super( imfgpProcessSeq: imfgpProcessSeq,ipcwGoodQtyAvl: ipcwGoodQtyAvl);

  final int? imfgpProcessSeq;
    final int? ipcwGoodQtyAvl;


    factory EditProductQtyModel.fromJson(Map<String, dynamic> json){ 
        return EditProductQtyModel(
       imfgpProcessSeq: json["imfgp_process_seq"],
            ipcwGoodQtyAvl: json["ipcw_good_qty_avl"],
        );
    }

}
