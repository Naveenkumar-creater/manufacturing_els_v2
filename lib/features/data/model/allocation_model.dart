// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import '../../domain/entity/AllocationEntity.dart';

class AllocationModel extends AllocationEntity {
  final List<Allocation> allocation;
  const AllocationModel({
    required this.allocation,
  }) : super(allocationEntity: allocation);

  factory AllocationModel.fromJson(Map<String, dynamic> json) {
    return AllocationModel(
        allocation: json['response_data']['Allocation_Of_Product'] == null
            ? []
            : List<Allocation>.from(json['response_data']
                    ['Allocation_Of_Product']!
                .map((x) => Allocation.fromJson(x))));
  }

  Map<String, dynamic> toJson() => {
        'Allocation_Of_Product': allocation.map((x) => x?.toJson()).toList(),
      };
}

class Allocation extends AllocationList {
  const Allocation({
    required this.processid,
    // required this.productid,
    required this.processname,
    // required this.productname,
  }) : super(
            processid: processid,
            // productid: productid,
            processname: processname,
            // productname: productname
            );
  final int? processid;
  // final int? productid;
  final String? processname;
  // final String? productname;

  factory Allocation.fromJson(Map<String, dynamic> json) {
    return Allocation(
      processid: json['process_id'],
      // productid: json['product_id'],
      processname: json['process_name'],
      // productname: json['product_name'],
    );
  }
  Map<String, dynamic> toJson() => {
        "process_id": processid,
        // "product_id": productid,
        "process_name": processname,
        // "product_name": productname,
      };
}
