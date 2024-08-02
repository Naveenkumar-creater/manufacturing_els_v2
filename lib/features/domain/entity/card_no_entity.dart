  

import 'package:equatable/equatable.dart';
import 'package:prominous/features/data/model/card_no_model.dart';

class CardNoEntity extends Equatable {
  final ScanCardForItem? scanCardForItem;

  const CardNoEntity({this.scanCardForItem});
  @override
  // TODO: implement props
  List<Object?> get props => [scanCardForItem];
}

class ScanCardForItemEntity extends Equatable {
  ScanCardForItemEntity({
    this.pcItemId,
    this.pcCardNo,
    this.itemName,
    this.pcId,
  });

 final int? pcItemId;
 final int? pcCardNo;
 final String? itemName;
final  int? pcId;

  @override
  // TODO: implement props
  List<Object?> get props => [ pcItemId,pcCardNo,itemName, pcId];
}
