import '../../domain/entity/emp_details_entity.dart';
import '../../domain/entity/process_entity.dart';

class EmpDetailsModel extends EmpDetailsEntity {
  const EmpDetailsModel({
    required this.listOfEmpDetails,
  }) : super(listofEmpDetailsEntity: listOfEmpDetails);

  final List<ListOfEmpDetails> listOfEmpDetails;

  factory EmpDetailsModel.fromJson(Map<String, dynamic> json) {
    final empListJson =
        json['response_data']['Emp_Details']; // Updated key name
    // ignore: avoid_print
    // print('Process List: $empListJson'); // Print the empListJson

    if (empListJson == null) {
      throw Exception(
          'emplist  is null.'); // Throw an exception if asset list is null
    }

    final empData = (empListJson as List)
        .map((item) => ListOfEmpDetails.fromJson(item))
        .toList();

    return EmpDetailsModel(listOfEmpDetails: empData);
  }

  Map<String, dynamic> toJson() => {
        "Emp_Details": listOfEmpDetails.map((x) => x?.toJson()).toList(),
      };
}

class ListOfEmpDetails extends ListofEmpDetailsEntity {
  const ListOfEmpDetails({
    required this.empdept,
    required this.empname,
    required this.empmgr,
    required this.empid,
    required this.empdesig,
  })  : assert(empdept != null), // Ensure processId is not null
        super(
            empdept: empdept,
            empname: empname,
            empmgr: empmgr,
            empid: empid,
            empdesig: empdesig);
  final int? empdept;
  final String? empname;
  final int? empmgr;
  final int? empid;
  final String? empdesig;

  factory ListOfEmpDetails.fromJson(Map<String, dynamic> json) {
    return ListOfEmpDetails(
        empname: json["emp_name"],
        empdept: json["emp_dept"],
        empmgr: json["emp_mgr"],
        empdesig: json["emp_desig"],
        empid: json["emp_id"]);
  }

  Map<String, dynamic> toJson() => {
        "emp_name": empname,
        "emp_dept": empdept,
        "emp_mgr": empmgr,
        "emp_desig": empdesig,
        "emp_id": empid,
      };
}
