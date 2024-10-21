import 'package:prominous/features/domain/entity/product_avilable_qty_entity.dart';

class ProductAvilableQtyModel extends ProductAvilableQtyEntity {
    ProductAvilableQtyModel({
        required this.productqty,
    }) : super(productqty: productqty);

    final ProductQtyModel ?productqty;

    factory ProductAvilableQtyModel.fromJson(Map<String, dynamic> json){ 
        return ProductAvilableQtyModel(
            productqty: json['response_data']["Item Process Card Wip"] == null ?null :ProductQtyModel.fromJson(json['response_data']["Item Process Card Wip"])
        );
    }



}

class ProductQtyModel extends ProductQtyEntity{
    ProductQtyModel({
           required this.imfgpProcessSeq,
        required this.ipcwGoodQtyAvl,
      
    }) : super( imfgpProcessSeq: imfgpProcessSeq,ipcwGoodQtyAvl: ipcwGoodQtyAvl);

  final int? imfgpProcessSeq;
    final int? ipcwGoodQtyAvl;


    factory ProductQtyModel.fromJson(Map<String, dynamic> json){ 
        return ProductQtyModel(
       imfgpProcessSeq: json["imfgp_process_seq"],
            ipcwGoodQtyAvl: json["ipcw_good_qty_avl"],
        );
    }

}
