import 'package:prominous/features/domain/entity/problem_status_entity.dart';

class ProblemStatusModel extends ProblemStatusEntity {
    ProblemStatusModel({
        required this.problemStatus,
    }):super(listofProblemStatusEntity:problemStatus);

    final List<ProblemStatus> problemStatus;

    factory ProblemStatusModel.fromJson(Map<String, dynamic> json){ 
        return ProblemStatusModel(
            problemStatus: json['response_data']["Problem_Status"] == null ? [] : List<ProblemStatus>.from(json['response_data']["Problem_Status"]!.map((x) => ProblemStatus.fromJson(x))),
        );
    }

}


class ProblemStatus extends ListofProblemStatusEntity {
    ProblemStatus({
        required this.statusId,
        required this.statusName,
    }) : super(statusId:statusId ,statusName: statusName);

    final int? statusId;
    final String? statusName;

    factory ProblemStatus.fromJson(Map<String, dynamic> json){ 
        return ProblemStatus(
            statusId: json["status_id"],
            statusName: json["status_name"],
        );
    }

}
