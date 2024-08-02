// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:prominous/features/data/model/allocation_model.dart';

class ActivityEntity extends Equatable {
  final List<ProcessActivityEntity>? activityEntity;
  const ActivityEntity({this.activityEntity});

  @override
  List<Object?> get props => [activityEntity];
}

class ProcessActivityEntity extends Equatable {
  const ProcessActivityEntity({
        required this.paActivityName,
        required this.mpmName,
        required this.pwsName,
        required this.paId,
        required this.paMpmId,
    });

    final String? paActivityName;
    final String? mpmName;
    final String? pwsName;
    final int? paId;
    final int? paMpmId;
  @override
  List<Object?> get props => [ paActivityName,paId,paMpmId,mpmName,pwsName];
}
