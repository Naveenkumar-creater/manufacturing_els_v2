import '../../domain/entity/process_entity.dart';

class ProcessModel extends ProcessEntity {
  const ProcessModel({
    required this.listOfProcess,
  }) : super(listofProcessEntity: listOfProcess);

  final List<ListOfProcess> listOfProcess;

  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    final processListJson =
        json['response_data']['List_Of_Process']; // Updated key name
    // ignore: avoid_print
    // print('Process List: $processListJson'); // Print the processListJson

    if (processListJson == null) {
      throw Exception(
          'Asset list is null.'); // Throw an exception if asset list is null
    }

    final processData = (processListJson as List)
        .map((item) => ListOfProcess.fromJson(item))
        .toList();

    return ProcessModel(listOfProcess: processData);
  }

}

class ListOfProcess extends ListofProcessEntity {
  const ListOfProcess(
      {required this.processName,
      required this.processId,
      required this.deptId,
      required this.shiftgroupId,
      required this.mpmBatchProcess,
      required this.mpmCapability

      // required  this.shiftStatus
      })
      : assert(processId != null), // Ensure processId is not null
        super(
            processName: processName,
            processId: processId,
            deptId: deptId,
            shiftgroupId: shiftgroupId,
            mpmCapability: mpmCapability,
            mpmBatchProcess: mpmBatchProcess);

  // final int? shiftStatus;

  final int? mpmCapability;
  final int? processId;
  final String? processName;
  final int? shiftgroupId;
  final int? deptId;
  final int? mpmBatchProcess;

  factory ListOfProcess.fromJson(Map<String, dynamic> json) {
    return ListOfProcess(
      mpmCapability: json["mpm_capability"],
      processId: json["process_Id"] ?? 0,
      processName: json["process_name"],
      shiftgroupId: json["ps_sg_id"],
      deptId: json["dept_id"],
      mpmBatchProcess: json["mpm_batch_process"],
    );
  }
}
