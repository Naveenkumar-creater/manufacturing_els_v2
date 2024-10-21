
import 'package:prominous/features/domain/entity/product_location_entity.dart';

class ProductLocationModel extends ProductLocationEntity{
    ProductLocationModel({
        required this.itemProductionArea,
    }):super(itemProductionArea:itemProductionArea);

    final List<ItemProductionArea> itemProductionArea;

    factory ProductLocationModel.fromJson(Map<String, dynamic> json){ 
        return ProductLocationModel(
            itemProductionArea: json["response_data"]["Item Production Area"] == null ? [] : List<ItemProductionArea>.from(json["response_data"]["Item Production Area"]!.map((x) => ItemProductionArea.fromJson(x))),
        );
    }

}

class ItemProductionArea extends ItemProductionAreaEntity{
    ItemProductionArea({
        required this.ipaId,
        required this.ipaName,
    }):super(ipaId:ipaId ,ipaName:ipaName );

    final int? ipaId;
    final String? ipaName;

    factory ItemProductionArea.fromJson(Map<String, dynamic> json){ 
        return ItemProductionArea(
            ipaId: json["ipa_id"],
            ipaName: json["ipa_name"],
        );
    }

}
