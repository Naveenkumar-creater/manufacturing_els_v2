import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:prominous/constant/show_pop_error.dart';
import 'package:prominous/features/presentation_layer/api_services/card_no_di.dart';
import 'package:prominous/features/presentation_layer/provider/card_no_provider.dart';

class CardNoScanner extends StatefulWidget {


  final Function(String, String)? onCardDataReceived;

  const CardNoScanner({
    Key? key,

    this.onCardDataReceived,
  }) : super(key: key);

  @override
  State<CardNoScanner> createState() => _CardNoScannerState();
}

class _CardNoScannerState extends State<CardNoScanner> {
  final CardNoApiService cardNoApiService = CardNoApiService();
  late String _barcodeResult = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: InkWell(
        onTap: _scanQrCode,
        child: Column(
          children: [
            Icon(
              Icons.camera_alt,
              color: Colors.blue,
              size: 40,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _scanQrCode() async {
    String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
      '#00FF00',
      'Cancel',
      true,
      ScanMode.QR,
    );

    if (barcodeResult.isEmpty || barcodeResult == '-1') {
      ShowError.showAlert(context, 'Invalid barcode or scan canceled');
      return;
    }

    try {
      await cardNoApiService.getCardNo(
          context: context, cardNo: int.tryParse(barcodeResult) ?? 0);

      setState(() {
        _barcodeResult = barcodeResult;
      });

      final cardNumber = Provider.of<CardNoProvider>(context, listen: false)
          .user
          ?.scanCardForItem;

      if (widget.onCardDataReceived != null && cardNumber != null) {
        final cardNo = cardNumber.pcCardNo?.toString() ?? "";
        final productName = cardNumber.itemName?.toString() ?? "";

        widget.onCardDataReceived!(cardNo, productName);
      }
    } catch (e) {
      ShowError.showAlert(context, 'Error: Failed to fetch card number');
    }
  }
}
