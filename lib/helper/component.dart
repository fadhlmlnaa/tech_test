import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:technical_test/helper/formatter.dart';



typedef FunctionValue<P0, R> = R Function(P0);

class MultipleFilter extends StatefulWidget {
  final List<dynamic>? dataSelected;
  final List<dynamic> dataList;
  final String displayKey;
  final String idKey;
  final FunctionValue<List<dynamic>, void> onSelect;
  final Color contentColor;
  final Color titleColor;
  const MultipleFilter({
    super.key,
    required this.dataSelected,
    required this.idKey,
    required this.displayKey,
    required this.dataList,
    required this.onSelect,
    required this.contentColor,
    required this.titleColor,
  });

  @override
  State<MultipleFilter> createState() => _MultipleFilterState();
}

class _MultipleFilterState extends State<MultipleFilter> {
  late List<dynamic> value;

  @override
  void initState() {
    super.initState();
    value = List<dynamic>.from(widget.dataSelected ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.dataList.map((e) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              if (value.contains(e[widget.idKey])) {
                value.remove(e[widget.idKey]);
              } else {
                value.add(e[widget.idKey]);
              }
            });
            widget.onSelect(value);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffDDDDDD),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e[widget.displayKey].toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                checkWidget(value.contains(e[widget.idKey])),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget checkWidget(bool isCheck) {
    if (isCheck) {
      return Icon(
        Icons.check_box,
        color: widget.titleColor,
        size: 20,
      );
    }
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: const Color(0xffDDDDDD),
        ),
      ),
    );
  }
}

class TextHarga extends StatefulWidget {
  final num? data;
  final FunctionValue<num?, void> onChange;
  final String label;
  const TextHarga({
    super.key,
    this.data,
    required this.onChange,
    required this.label,
  });

  @override
  State<TextHarga> createState() => _TextHargaState();
}

class _TextHargaState extends State<TextHarga> {
  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      controller.text = rupiahFormat(widget.data!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            RupiahFormatter(),
          ],
          onChanged: (value) {
            if (value.length > 3) {
              try {
                final v = value.replaceAll('Rp ', '').replaceAll('.', '');
                final realValue = num.tryParse(v);
                widget.onChange(realValue);
              } catch (e) {
                widget.onChange(null);
              }
            } else {
              widget.onChange(null);
            }
          },
        ),
      ],
    );
  }
}
