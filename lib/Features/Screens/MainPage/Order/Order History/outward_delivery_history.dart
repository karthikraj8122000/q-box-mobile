import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:qr_page/Services/api_service.dart';

class OutwardOrderHistoryCard extends StatefulWidget {
  const OutwardOrderHistoryCard({Key? key}) : super(key: key);

  @override
  State<OutwardOrderHistoryCard> createState() => _OutwardOrderHistoryCardState();
}

class _OutwardOrderHistoryCardState extends State<OutwardOrderHistoryCard> {
  ApiService apiService = ApiService();
  List<dynamic> purchaseOrder = [];
  final Set<int> _expandedIndices = {};

  @override
  void initState() {
    getTotalItems();
    super.initState();
  }

  Future<void> getTotalItems() async {
    Map<String, dynamic> params = {};
    var result = await apiService.post("8911", "masters", "partner_channel_outward_delivery_history", params);
    print('result: $result');

    if (result != null) {
      setState(() {
        if (result is List) {
          purchaseOrder = result;
        } else if (result is Map<String, dynamic>) {
          var data = result['data'];
          if (data is List) {
            purchaseOrder = data;
          } else if (data is Map<String, dynamic>) {
            purchaseOrder = [data];
          } else {
            purchaseOrder = [];
          }
        } else {
          purchaseOrder = [];
        }
      });
      print('purchaseOrder: $purchaseOrder');
    } else {
      print("Null response received");
      setState(() {
        purchaseOrder = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (purchaseOrder.isEmpty) {
      return Center(child:Text("No Outward Order History Found"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: purchaseOrder.length,
      itemBuilder: (context, index) {
        final order = purchaseOrder[index] is Map ?
        purchaseOrder[index] as Map<String, dynamic> :
        <String, dynamic>{};

        final salesOrder = order['salesOrder'] is Map ?
        order['salesOrder'] as Map<String, dynamic> :
        <String, dynamic>{};

        final salesOrderDtls = order['salesOrderDtls'] is List ?
        order['salesOrderDtls'] as List<dynamic> :
        <dynamic>[];
        final isExpanded = _expandedIndices.contains(index);
        final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

        return Card(
          elevation: isExpanded ? 8 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.red.shade100, width: 1),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedIndices.remove(index);
                    } else {
                      _expandedIndices.add(index);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              salesOrder['partnerSalesOrderId']?.toString() ?? 'N/A',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time, color: Colors.grey.shade600, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                salesOrder['deliveredTime'] != null
                                    ? DateFormat('MMM dd, yyyy').format(
                                    DateTime.parse(salesOrder['deliveredTime'].toString())
                                )
                                    : 'N/A',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.red.shade700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded) ...[
                const Divider(height: 1),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    children: [
                      ...salesOrderDtls.map<Widget>((item) {
                        if (item is! Map) return const SizedBox.shrink();

                        final skuInventory = (item['skuInventory'] as List<dynamic>?) ?? [];
                        final firstSku = skuInventory.isNotEmpty && skuInventory[0] is Map ?
                        skuInventory[0] as Map<String, dynamic> :
                        <String, dynamic>{};

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'x${item['orderQuantity']?.toString() ?? 'N/A'}',
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        firstSku['skuDescription']?.toString() ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const Divider(color: Colors.red),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                            'Entity Name',
                            style: TextStyle(
                              fontSize: isTablet?16:14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            salesOrder['qboxEntityName']?.toString() ?? 'N/A',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: isTablet?18:14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Implement delete functionality
                            },
                            icon: const Icon(Icons.delete),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.shade50,
                              foregroundColor: Colors.red.shade700,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () {
                              // Implement share functionality
                            },
                            icon: const Icon(Icons.share),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.shade50,
                              foregroundColor: Colors.red.shade700,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ).animate().fadeIn(duration: 800.ms, delay: (50 * index).ms).slideY(begin: -0.2, end: 0);
      },
    );
  }
}