import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/constant/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/asset_barcode_datasource.dart';
import 'package:prominous/features/data/repository/asset_barcode_repo.dart';
import 'package:prominous/features/domain/entity/scan_asset_barcode_entity.dart';
import 'package:prominous/features/domain/usecase/asset_barcode_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/asset_barcode_provier.dart';


class AssetBarcodeService {
  Future<void> getAsset(
      {required BuildContext context, required int pwsid,required int assetid}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      String token = pref.getString("client_token") ?? "";
      //  ActualQtyDatasource empData = ActualQtyDatasourceImpl();
      // ActualQtyRepository allocationRepository =
      //     ActualQtyRepositoryImpl(empData);
      // ActualQtyUsecase empUseCase = ActualQtyUsecase(allocationRepository);
         final asset = AssetBarcodeUsecase(
        AssetBarcodeRepositoryImpl(
          AssetBarcodeDatasourceImpl(),
        ),
      );

      ScanAssetBarcodeEntity user = await asset.execute( pwsid, assetid, token) ;

      Provider.of<AssetBarcodeProvider>(context, listen: false).setUser(user);

    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
