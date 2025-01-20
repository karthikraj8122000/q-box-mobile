import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Provider/order_history_provider.dart';
import '../../../../../Widgets/Common/app_colors.dart';


class OrderHistoryCard extends StatefulWidget {
  const OrderHistoryCard({Key? key}) : super(key: key);

  @override
  State<OrderHistoryCard> createState() => _OrderHistoryCardState();
}

class _OrderHistoryCardState extends State<OrderHistoryCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderHistoryProvider>().fetchInwardOrders();
    });
  }

  String _getStatusFromCode(int statusCode) {
    switch (statusCode) {
      case 1:
        return 'Pending';
      case 2:
        return 'Completed';
      case 3:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderHistoryProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.mintGreen,));
        }
        if (orderProvider.purchaseOrder.isEmpty) {
          return const Center(child: Text("No Inward Order History Found"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: orderProvider.purchaseOrder.length,
          itemBuilder: (context, index) {
            final order = orderProvider.purchaseOrder[index] is Map
                ? orderProvider.purchaseOrder[index] as Map<String, dynamic>
                : <String, dynamic>{};

            final purchaseOrder = order['purchaseOrder'] is Map
                ? order['purchaseOrder'] as Map<String, dynamic>
                : <String, dynamic>{};

            final purchaseOrderDtls = order['purchaseOrderDtls'] is List
                ? order['purchaseOrderDtls'] as List<dynamic>
                : <dynamic>[];

            final isExpanded = orderProvider.expandedIndices.contains(index);
            final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Card(
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
                            orderProvider.expandedIndices.remove(index);
                          } else {
                            orderProvider.expandedIndices.add(index);
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
                                    purchaseOrder['partnerPurchaseOrderId']
                                        ?.toString() ??
                                        '#123',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    _getStatusFromCode(
                                        purchaseOrder['orderStatusCd'] ?? 0),
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.restaurant,
                                    color: Colors.red.shade400),
                                const SizedBox(width: 8),
                                Text(
                                  purchaseOrder['restaurantName']?.toString() ??
                                      'A2B',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
                                    Icon(Icons.access_time,
                                        color: Colors.grey.shade600, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      purchaseOrder['deliveredTime'] != null
                                          ? DateFormat('MMM dd, yyyy • hh:mm a')
                                          .format(DateTime.parse(
                                          purchaseOrder['deliveredTime']
                                              .toString()))
                                          : 'N/A',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
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
                            ...purchaseOrderDtls.map<Widget>((item) {
                              final skuInventoryList = item['skuInventory'];
                              print("skuInventoryList$skuInventoryList");
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'x${item['acceptedQuantity']?.toString() ?? 'N/A'}',
                                                  style: TextStyle(
                                                    color: Colors.red.shade700,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                item['partnerFoodCode']
                                                    ?.toString() ??
                                                    'N/A',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "SKU's:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...skuInventoryList.map((sku) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.red.shade100,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.qr_code,
                                            size: 18,
                                            color: Colors.red.shade400,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              sku['uniqueCode'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              );
                            }).toList(),
                            const Divider(color: Colors.white),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Handle delete action
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
                                    // Handle share action
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
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: (50 * index).ms)
                .slideY(begin: -0.2, end: 0);
          },
        );
      },
    );
  }
}
