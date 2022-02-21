import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.provider.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            onTap: toggleExpanded,
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat.yMMMMd().format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: toggleExpanded,
            ),
          ),
          AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            constraints: BoxConstraints(
              minHeight: _expanded
                  ? min(widget.order.products.length * 20 + 25, 100)
                  : 0,
            ),
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: _expanded
                ? min(widget.order.products.length * 20 + 25, 100)
                : 0,
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                final product = widget.order.products[idx];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${product.quantity}x \$${product.price}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    )
                  ],
                );
              },
              itemCount: widget.order.products.length,
            ),
          )
        ],
      ),
    );
  }
}
