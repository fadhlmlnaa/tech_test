part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

final class GetProductEvent extends ProductEvent {
  final Map<String, dynamic> param;
  GetProductEvent(this.param);
}
