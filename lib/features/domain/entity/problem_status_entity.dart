import 'package:equatable/equatable.dart';

class ProblemStatusEntity extends Equatable {
  final List<ListofProblemStatusEntity>? listofProblemStatusEntity;

  const ProblemStatusEntity({
    this.listofProblemStatusEntity,
  });

  @override
  List<Object?> get props => [listofProblemStatusEntity];
}

class ListofProblemStatusEntity extends Equatable {
  const ListofProblemStatusEntity(
         {     required this.statusId,
        required this.statusName,});

    final int? statusId;
    final String? statusName;
  @override
  List<Object?> get props => [ statusId, statusName];

}
