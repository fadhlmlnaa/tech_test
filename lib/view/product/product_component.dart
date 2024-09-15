import 'package:flutter/material.dart';
import 'package:technical_test/helper/component.dart';
import 'package:technical_test/helper/constant.dart';
import 'package:technical_test/helper/formatter.dart';

typedef Converter<T> = T Function(
  List<dynamic> listProduk,
  num? min,
  num? max,
);

class FilterComponent extends StatefulWidget {
  final List<dynamic> produk;
  final num? min;
  final num? max;
  final Converter onSubmit;
  const FilterComponent({
    super.key,
    required this.produk,
    this.min,
    this.max,
    required this.onSubmit,
  });

  @override
  State<FilterComponent> createState() => _FilterComponentState();
}

class _FilterComponentState extends State<FilterComponent> {
  late List<dynamic> listProduk;
  late num? minValue;
  late num? maxValue;

  @override
  void initState() {
    listProduk = List.from(widget.produk);
    minValue = widget.min;
    maxValue = widget.max;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Jenis Produk',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            MultipleFilter(
              dataSelected: listProduk,
              idKey: 'kode',
              displayKey: 'kode',
              dataList: Constants.listFilter,
              onSelect: (value) {
                setState(() {
                  listProduk = value;
                });
              },
              contentColor: Colors.blue,
              titleColor: Colors.blue,
            ),
            const SizedBox(height: 24),
            TextHarga(
              data: minValue,
              onChange: (value) {
                setState(() {
                  minValue = value;
                });
              },
              label: 'Minimal Harga',
            ),
            const SizedBox(height: 24),
            TextHarga(
              data: maxValue,
              onChange: (value) {
                setState(() {
                  maxValue = value;
                });
              },
              label: 'Maksimal Harga',
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                widget.onSubmit(listProduk, minValue, maxValue);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.amber.shade800,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Text(
                  'Filter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardProduk extends StatelessWidget {
  final String image;
  final String namaProduk;
  final int idProduk;
  final num harga;
  const CardProduk({
    super.key,
    required this.image,
    required this.namaProduk,
    required this.idProduk,
    required this.harga,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 242, 234, 140),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              width: MediaQuery.of(context).size.width,
              height: 100,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            namaProduk,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
           Text(
            rupiahFormat(harga),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
