import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_test/helper/constant.dart';
import 'package:technical_test/view/product/bloc/product_bloc.dart';
import 'package:technical_test/view/product/product_component.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> filterProduk = [];
  int page = 1;
  int total = 0;
  List<dynamic>? data;
  bool isLoading = false;
  num? min;
  num? max;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final pos = scrollController.position;
      if (pos.pixels == pos.maxScrollExtent) {
        final bloc = context.read<ProductBloc>();
        final pageValue = page + 1;
        setState(() {
          page = pageValue;
        });
        final Map<String, dynamic> param = {
          'page': pageValue,
          'pageSize': 10,
        };
        if (filterProduk.isNotEmpty) {
          param['jenisProduk'] = filterProduk.join(',');
        }
        if (min != null) {
          param['min'] = min;
        }
        if (min != null) {
          param['max'] = max;
        }
        bloc.add(GetProductEvent(param));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProductBloc>();
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductLoading) {
          if (data != null) {
            setState(() {
              isLoading = true;
            });
          }
        }
        if (state is ProductSuccess) {
          final List<dynamic> list = data ?? [];
          final listProduct = state.dataProduk['responseData'] ?? [];
          final t = state.dataProduk['total'] ?? 0;
          list.addAll(listProduct);
          setState(() {
            data = list;
            total = t;
          });
        }

        if (state is ProductError) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (dialogContext) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.errorMessage,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MARKET.INC',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.amber.shade400,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)
            )
          ),
          centerTitle: true,
          toolbarHeight: 70,
          
          actions: [
            buttonFilter(bloc),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: dataBuilder(data),
        ),
      ),
    );
  }

  Widget dataBuilder(List<dynamic>? listData) {
    if (listData == null) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          CircularProgressIndicator(),
        ],
      );
    }

    if (listData.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Text(
            'Maaf saat ini produk tidak tersedia',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Menampilkan ${listData.length} dari $total data',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 2,
                runSpacing: 16,
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: listData.map((e) {
                  return CardProduk(
                    image: Constants.imageConstans,
                    namaProduk: e['nama_produk'] ?? '',
                    idProduk: e['id'] ?? 0,
                    harga: e['harga'] ?? 0,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buttonFilter(ProductBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  final keyboardHeight =
                      MediaQuery.of(context).viewInsets.bottom;
                  return Padding(
                    padding: EdgeInsets.only(bottom: keyboardHeight),
                    child: FilterComponent(
                      produk: filterProduk,
                      min: min,
                      max: max,
                      onSubmit: (prd, mn, mx) {
                        setState(() {
                          filterProduk = prd;
                          min = mn;
                          max = mx;
                          page = 1;
                          data = null;
                        });
                        final Map<String, dynamic> param = {
                          'page': 1,
                          'pageSize': 10,
                        };
                        if (filterProduk.isNotEmpty) {
                          param['jenisProduk'] = filterProduk.join(',');
                        }
                        if (min != null) {
                          param['min'] = min;
                        }
                        if (min != null) {
                          param['max'] = max;
                        }
                        bloc.add(
                          GetProductEvent(param),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.filter_alt),
          ),
        ],
      ),
    );
  }
}
