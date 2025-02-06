// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:prominous/features/data/datasource/remote/card_no_datasource.dart';
import 'package:prominous/features/data/model/card_no_model.dart';
import 'package:prominous/features/domain/repository/card_no_repo.dart';

class CardNoRepositoryImpl implements CardNoRepository {
  final CardNoDatasource cardNoDatasource;
  CardNoRepositoryImpl(
    this.cardNoDatasource,
  );
  @override
  Future<CardNoModel> getCardNo(
    String token,int cardNo, int orgid
  ) async {
    final result = await cardNoDatasource.getCardNo(token,cardNo,orgid);
    return result;
  }
}
