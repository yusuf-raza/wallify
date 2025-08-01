import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class GridItem extends StatelessWidget {
  const GridItem({super.key, required this.index, required this.onTap});

  final int index;
  final Callback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        //color: Colors.blueAccent,
        child: Center(
          child: Text(
            'Item $index',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
