import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:prominous/constant/show_pop_error.dart';
import 'package:prominous/features/presentation_layer/api_services/asset_barcode_di.dart';
import 'package:prominous/features/presentation_layer/provider/asset_barcode_provier.dart';



class ScanBarcode extends StatefulWidget {

  // final int? empId;
  final int? pwsid;
   final Function(String)? onCardDataReceived;
  const ScanBarcode({
    super.key,  this.pwsid,this.onCardDataReceived
  });



  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  late String _barcodeResult = '';
     final AssetBarcodeService assetBarcodeService=AssetBarcodeService();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
      color: Colors.grey.shade200,
        // color: widget.themeState.isDarkTheme
        //     ? const Color(0xFF424242)
        //     : Colors.white,
      ),
      child: InkWell(
        onTap: _scanQrCode,
        child:  Column(
          children: [
        
              Icon(
                Icons.camera_alt,
                color: Colors.blue,
                size: 40,
              )
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
    await assetBarcodeService.getAsset(context: context, pwsid: widget.pwsid??1, assetid: int.parse("${barcodeResult}" ?? "0"));

    setState(() {
      _barcodeResult = barcodeResult;
    });
final assetlist = Provider.of<AssetBarcodeProvider>(context, listen: false)
        .user
        ?.scanAseetBarcode;
  if (widget.onCardDataReceived != null && assetlist != null) {
        
        final assetid = assetlist.pwsaAssetId?.toString() ?? "";

        widget.onCardDataReceived!(assetid);
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
