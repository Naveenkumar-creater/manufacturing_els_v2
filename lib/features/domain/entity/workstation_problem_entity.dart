import 'package:equatable/equatable.dart';

class WorkstationProblemsEntity extends Equatable {
    WorkstationProblemsEntity({
      this.resolvedProblemInWs,
    });

    final List<ResolveProblemsEntity>? resolvedProblemInWs;

    @override
    List<Object?> get props => [
    resolvedProblemInWs, ];
}

class ResolveProblemsEntity extends Equatable {
    ResolveProblemsEntity({
     required this.subincidentName,
        required this.problemStatusId,
        required this.solId,
        required this.ipdPwsId,
        required this.endTime,
        required this.productionStopageId,
        required this.fromTime,
        required this.solDesc,
        required this.incidentId,
        required this.incmAssetType,
        required this.incrcmRootcauseBrief,
        required this.incmAssetId,
        required this.ipdincNotes,
        required this.subincidentId,
        required this.ipdincIncrcmId,
        required this.incidentName,
        required this.problemStatus,
        required this.ipdincid,
         required this.ipdincipdid
    });

    final String? subincidentName;
    final int? problemStatusId;
    final int? solId;
    final int? ipdPwsId;
    final String? endTime;
    final int? productionStopageId;
    final String? fromTime;
    final String? solDesc;
    final int? incidentId;
    final int? incmAssetType;
    final String? incrcmRootcauseBrief;
    final int? incmAssetId;
    final String? ipdincNotes;
    final int? subincidentId;
    final int? ipdincIncrcmId;
    final String? incidentName;
    final String? problemStatus;
    final int?    ipdincid;
      final int? ipdincipdid;

    @override
    List<Object?> get props => [
   subincidentName, problemStatusId, solId, ipdPwsId, endTime, productionStopageId, fromTime, solDesc, incidentId, incmAssetType, incrcmRootcauseBrief, incmAssetId, ipdincNotes, subincidentId, ipdincIncrcmId, incidentName, problemStatus ];
}