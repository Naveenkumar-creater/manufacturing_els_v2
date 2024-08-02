import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:prominous/features/presentation_layer/api_services/scanforworkstation_di.dart';
import 'package:prominous/features/presentation_layer/provider/scanforworkstation_provider.dart';
import 'package:provider/provider.dart';
import 'package:prominous/constant/show_pop_error.dart';
import 'package:prominous/features/presentation_layer/api_services/asset_barcode_di.dart';
import 'package:prominous/features/presentation_layer/provider/asset_barcode_provier.dart';



class ScanWorkstationBarcode extends StatefulWidget {

  final int? deptid;
  final int? pwsid;
   final Function(String)? onCardDataReceived;
  const ScanWorkstationBarcode({
    super.key, this.onCardDataReceived, this.deptid, this.pwsid
  });



  @override
  State<ScanWorkstationBarcode> createState() => _ScanWorkstationBarcodeState();
}

class _ScanWorkstationBarcodeState extends State<ScanWorkstationBarcode> {
  late String _barcodeResult = '';
  final ScanforWorkstationBarcodeService scanforWorkstationBarcodeService=ScanforWorkstationBarcodeService();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: InkWell(
        onTap: _scanQrCode,
        child:  Column(
          children: [
        
                          Icon(Icons.qr_code,color: Colors.white,size: 35,)
            // Headings(
            //   text: "Scan Barcode",
            // )
          ],
        ),
      ),
    );
  }




Future<void> _scanQrCode() async {
  String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
    '#00FF00', // Overlay color (green)
    'Cancel',  // Cancel button text
    true,      // Show flash icon
    ScanMode.QR, // Scan mode (QR code in this case)
  );

  // Check if the result is empty or if the scan was canceled
  if (barcodeResult.isEmpty || barcodeResult == '-1') {
    // Show an alert or toast indicating invalid barcode

    ShowError.showAlert(context,'Invalid barcode or scan canceled' );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Invalid barcode or scan canceled'),
    //     duration: Duration(seconds: 2),
    //   ),
    
    return;
  }

  try {
    // Call cardNoApiService.getCardNo
    await scanforWorkstationBarcodeService.getWorkstationBarcode(context: context,deptid:widget.deptid ?? 1057 , pwsId: widget.pwsid ?? 0  ,pwsbarcode:barcodeResult ?? "0" );
    // getAsset(context: context, processid: widget.processId??1, assetid: int.parse("${barcodeResult}" ?? "0"));

    setState(() {
      _barcodeResult = barcodeResult;
    });
final wokstationBarcod = Provider.of<ScanforworkstationProvider>(context, listen: false)
        .user
        ?.workStationScanEntity;
  if (widget.onCardDataReceived != null && wokstationBarcod != null) {
        
        final pwsbarcode = wokstationBarcod.pwsBarcode ?? "";

        widget.onCardDataReceived!(pwsbarcode);
      }
     
          // Pass the scanned barcode to the EmpProductionEntryPage widget

  } catch (e) {
    // Show an alert or toast indicating error

        ShowError.showAlert(context,'Error: Failed to fetch card number' );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Error: Failed to fetch card number'),
    //     duration: Duration(seconds: 2),
    //   ),
    // );
  }
}
}
