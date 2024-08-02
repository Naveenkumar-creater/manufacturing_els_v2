import 'package:prominous/features/domain/entity/card_no_entity.dart';
import 'package:prominous/features/domain/repository/card_no_repo.dart';

class CardNoUsecase {
  final CardNoRepository cardNoRepository;
  CardNoUsecase(this.cardNoRepository);

  Future<CardNoEntity> execute(
    String token,
    int cardNo
  ) async {
    return cardNoRepository.getCardNo(token,cardNo);
  }
}
