import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:technical_test/api/client.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<GetProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        print('Build In');
        final response = await DioClient().getRequest(
          url: 'list_produk',
          queryParam: event.param,
        );
        response.fold(
          (left) {
            emit(ProductError(left));
          },
          (right) {
            emit(ProductSuccess(right.data));
          },
        );
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
