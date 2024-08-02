// import 'package:flutter/material.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:provider/provider.dart';
// import 'package:prominous/features/presentation_layer/provider/product_provider.dart';

// import '../../api_services/product_di.dart';

// class ProductListQty extends StatefulWidget {
//   const ProductListQty({super.key});

//   @override
//   State<ProductListQty> createState() => _ProctListQtyState();
// }

// class _ProctListQtyState extends State<ProductListQty> {
//   ProductApiService productApiService = ProductApiService();

//   @override
//   void initState() {
//     super.initState();

//     productApiService.productList(context: context, id: 1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productResponse = Provider.of<ProductProvider>(context, listen: true)
//         .user
//         ?.listofProductEntity;

//     return Column(
//       children: [
//         AspectRatio(
//           aspectRatio: 4 / 2.66,
//           child: Container(
//               height: 400,
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(8)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Product',
//                             style: TextStyle(color: Colors.black, fontSize: 20),
//                           ),
//                           const Text(
//                             'Daily',
//                             style: TextStyle(color: Colors.grey, fontSize: 18),
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                   color: Colors.deepPurple,
//                                   height: 10,
//                                   width: 10),
//                               SizedBox(
//                                 width: 4,
//                               ),
//                               const Text(
//                                 'Actual',
//                                 style:
//                                     TextStyle(color: Colors.grey, fontSize: 14),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                   color: Color(0xFFB39DDB),
//                                   height: 10,
//                                   width: 10),
//                               SizedBox(
//                                 width: 4,
//                               ),
//                               const Text(
//                                 'Planned',
//                                 style:
//                                     TextStyle(color: Colors.grey, fontSize: 14),
//                               ),
//                             ],
//                           ),
//                         ]),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: productResponse?.length,
//                         itemBuilder: (context, index) {
//                           final product = productResponse?[index];
//                           // final double? plannedQty =
//                           //     product?.productName;
//                           final int? actualQty = product?.productid;

//                           double? percentage;

//                           // if (plannedQty != null &&
//                           //     actualQty != null &&
//                           //     actualQty != 0) {
//                           //   percentage = (actualQty/plannedQty); // Swap actualQty and plannedQty
//                           // }

//                           print(
//                               percentage); // Print the calculated percentage for debugging

//                           return Padding(
//                             padding: EdgeInsets.only(top: 8, bottom: 8),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Text(
//                                   product?.productName ?? "",
//                                   style: TextStyle(
//                                       color: Colors.grey, fontSize: 12),
//                                 ),
//                                 Expanded(
//                                   child: SizedBox(
//                                     width: 100,
//                                     child: LinearPercentIndicator(
//                                       barRadius: Radius.circular(50),
//                                       animation: true,
//                                       animationDuration: 3000,
//                                       lineHeight: 5,
//                                       percent: percentage ?? 0,
//                                       progressColor: Colors.deepPurple,
//                                       backgroundColor: Color(0xFFB39DDB),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 85,
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         "${product?.productid ?? 0}",
//                                         style: TextStyle(
//                                             color: Colors.deepPurple,
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 16),
//                                       ),
//                                       Text(
//                                         "/",
//                                         style: TextStyle(
//                                             color: Color.fromARGB(
//                                                 255, 179, 157, 219),
//                                             fontSize: 14),
//                                       ),
//                                       // Text(
//                                       //   "${product?.plannedQty ?? 0}",
//                                       //   style: TextStyle(
//                                       //       color: Color.fromARGB(
//                                       //           255, 179, 157, 219),
//                                       //       fontSize: 14),
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//         ),
//       ],
//     );
//   }
// }
