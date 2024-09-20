import 'package:prominous/features/domain/entity/rootcause_solution_entity.dart';

class RootcauseSolutionModel extends RootcauseSolutionEntity  {
    RootcauseSolutionModel({
        required this.solutionForRootCause,
    }):super(solutionEntity:solutionForRootCause );

    final List<RootCauseSolution> solutionForRootCause;

    factory RootcauseSolutionModel.fromJson(Map<String, dynamic> json){ 
        return RootcauseSolutionModel(
            solutionForRootCause: json["response_data"]["Solution_For_RootCause"] == null ? [] : List<RootCauseSolution>.from(json["response_data"]["Solution_For_RootCause"]!.map((x) => RootCauseSolution.fromJson(x))),
        );
    }

}

class RootCauseSolution extends SolutionEntity  {
    RootCauseSolution({
        required this.solIncrcmId,
        required this.solId,
        required this.solStatus,
        required this.solAddDate,
        required this.solDesc,
    }):super(solAddDate: solAddDate,solDesc:solDesc ,solId:solId ,solIncrcmId:solIncrcmId ,solStatus: solStatus,);

    final int? solIncrcmId;
    final int? solId;
    final int? solStatus;
    final String? solAddDate;
    final String? solDesc;

    factory RootCauseSolution.fromJson(Map<String, dynamic> json){ 
        return RootCauseSolution(
            solIncrcmId: json["sol_incrcm_id"],
            solId: json["sol_id"],
            solStatus: json["sol_status"],
            solAddDate: json["sol_add_date"],
            solDesc: json["sol_desc"],
        );
    }

}
