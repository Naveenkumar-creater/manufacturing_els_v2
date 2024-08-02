import 'package:prominous/features/domain/entity/card_no_entity.dart';
import 'package:prominous/features/domain/entity/process_entity.dart';

abstract class CardNoRepository {
  Future<CardNoEntity> getCardNo(String token,int cardNo);
}
