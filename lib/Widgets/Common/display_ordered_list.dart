import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderList extends StatefulWidget {
  final String status;

  const OrderList({Key? key, required this.status}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {

  final List<Map<String,dynamic>> orderedItems = [
      {
        "foodSku1name": "Chicken Briyani",
        "purchaseOrder1description": null,
        "purchaseOrderDtlSno": 98,
        "purchaseOrderSno": 82,
        "foodSkuSno": 3,
        "orderQuantity": 1,
        "skuPrice": 1200,
        "partnerFoodCode": "CHBR",
        "acceptedQuantity": null,
        "description": null,
        "status": "accept"
      },
    {
      "foodSku1name": "Chicken Briyani",
      "purchaseOrder1description": null,
      "purchaseOrderDtlSno": 98,
      "purchaseOrderSno": 82,
      "foodSkuSno": 3,
      "orderQuantity": 1,
      "skuPrice": 1200,
      "partnerFoodCode": "CHBR",
      "acceptedQuantity": null,
      "description": null,
      "status": "accept"
    },
    {
      "foodSku1name": "Chicken Briyani",
      "purchaseOrder1description": null,
      "purchaseOrderDtlSno": 98,
      "purchaseOrderSno": 86,
      "foodSkuSno": 3,
      "orderQuantity": 1,
      "skuPrice": 1200,
      "partnerFoodCode": "CHBR",
      "acceptedQuantity": null,
      "description": null,
      "status": "reject"
    },
    {
      "foodSku1name": "Chicken Briyani",
      "purchaseOrder1description": null,
      "purchaseOrderDtlSno": 98,
      "purchaseOrderSno": 86,
      "foodSkuSno": 3,
      "orderQuantity": 1,
      "skuPrice": 1200,
      "partnerFoodCode": "CHBR",
      "acceptedQuantity": null,
      "description": null,
      "status": "reject"
    }
  ];

  List<Map<String, dynamic>> get filteredOrders {
    return orderedItems.where((order) => order['status'] == widget.status).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (filteredOrders.isEmpty) {
      return Center(
        child: Text('No ${widget.status}ed orders found'),
      );
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(16),
            title: Text(
              'Order ID: ${order['purchaseOrderSno']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Status: ${order['status'] == 'accept'?'In Hotbox':'rejected'}',
                  style: TextStyle(
                    color: order['status'] == 'accept' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Food Item: ${order['foodSku1name']}',
                ),
                Text(
                  'Quantity: ${order['orderQuantity']}',
                ),
                Text(
                  'Price: \$${order['skuPrice']}',
                ),
              ],
            ),
            children: [
              ListTile(
                title: Text('Partner Food Code: ${order['partnerFoodCode']}'),
                subtitle: Text('Accepted Quantity: ${order['acceptedQuantity'] ?? 'N/A'}'),
              ),
              if (order['description'] != null)
                ListTile(
                  title: Text('Description:'),
                  subtitle: Text(order['description']),
                ),
            ],
          ),
        );
      },
    );
  }
}

