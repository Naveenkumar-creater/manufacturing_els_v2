import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/edit_nonproduction_lis_entity.dart';

class EditNonproductionProvider extends ChangeNotifier{

  EditNonProductionListEntity ?_listOfNonproduction;

  
  EditNonProductionListEntity? get listOfNonproduction => _listOfNonproduction;

  void setNonProduction(EditNonProductionListEntity nonProductionList){
    _listOfNonproduction=nonProductionList;
    ChangeNotifier();

  }

}