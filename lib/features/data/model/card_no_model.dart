import 'package:prominous/features/domain/entity/card_no_entity.dart';

class CardNoModel extends CardNoEntity {
  CardNoModel({
    required this.scanCardForItem,
  }) : super(scanCardForItem: scanCardForItem);

  final ScanCardForItem? scanCardForItem;

  factory CardNoModel.fromJson(Map<String, dynamic> json) {
    return CardNoModel(
      scanCardForItem:json['response_data']["Scan_Card_For_Item"] == null
          ? null
          : ScanCardForItem.fromJson(json['response_data']["Scan_Card_For_Item"]),
    );
  }
}


    

class ScanCardForItem extends ScanCardForItemEntity {
  ScanCardForItem({
    required this.pcItemId,
    required this.pcCardNo,
    required this.itemName,
    required this.pcId,
  }) : super(
            pcItemId: pcItemId,
            pcCardNo: pcCardNo,
            itemName: itemName,
            pcId: pcId);

  final int? pcItemId;
  final int? pcCardNo;
  final String? itemName;
  final int? pcId;

  factory ScanCardForItem.fromJson(Map<String, dynamic> json) {
    return ScanCardForItem(
      pcItemId: json["pc_item_id"],
      pcCardNo: json["pc_card_no"],
      itemName: json["item_name"],
      pcId: json["pc_id"],
    );
  }
}
