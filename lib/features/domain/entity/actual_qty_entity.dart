// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:prominous/features/data/model/emp_production_model.dart';

class ActualQtyEntity extends Equatable {
  final ActualQtyCountEntity? actualQtyCountEntity;

  const ActualQtyEntity({required this.actualQtyCountEntity});

  @override
  List<Object?> get props => [actualQtyCountEntity];
}

class   ActualQtyCountEntity extends Equatable {
  final int? actualQty;

  const ActualQtyCountEntity(
      {required this.actualQty,
});

  @override
  List<Object?> get props => [
        actualQty,
      ];

}
