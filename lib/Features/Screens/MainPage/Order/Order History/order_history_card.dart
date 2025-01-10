import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:qr_page/Services/api_service.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';


class OrderHistoryCard extends StatefulWidget {
  const OrderHistoryCard({Key? key}) : super(key: key);

  @override
  State<OrderHistoryCard> createState() => _OrderHistoryCardState();
}

class _OrderHistoryCardState extends State<OrderHistoryCard> {
  ApiService apiService = ApiService();
  List<dynamic> purchaseOrder = [];
  final Set<int> _expandedIndices = {};

  @override
  void initState() {
    getTotalItems();
    super.initState();
  }
  //
  // Future<void> getTotalItems() async {
  //   Map<String, dynamic> params = {};
  //   var result = await apiService.post("8911", "masters", "partner_channel_inward_delivery_history", params);
  //   print('resultsss$result');
  //   if (result != null && result['data'] != null) {
  //     setState(() {
  //       purchaseOrder = result['data'];
  //       print(purchaseOrder);
  //     });
  //     print('purchaseOrder: $purchaseOrder');
  //   } else {
  //     print("Result or data is null.");
  //     setState(() {
  //       purchaseOrder = [];
  //     });
  //   }
  // }

  Future<void> getTotalItems() async {
    try {
      Map<String, dynamic> params = {};
      var result = await apiService.post("8911", "masters", "partner_channel_inward_delivery_history", params);
      print('API Response: $result');

      if (result != null && result['data'] != null) {
        final data = result['data'];
        setState(() {
          // Since the API returns a single object, wrap it in a list
          purchaseOrder = [data];
        });
        print('Processed purchaseOrder: $purchaseOrder');
      } else {
        print("Result or data is null.");
        setState(() {
          purchaseOrder = [];
        });
      }
    } catch (e) {
      print('Error processing data: $e');
      setState(() {
        purchaseOrder = [];
      });
    }
  }

  String _getStatusFromCode(int statusCode) {
    switch (statusCode) {
      case 2:
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (purchaseOrder.isEmpty) {
      return Center(child:Text("No Inward Order History Found"));
      // return Center(child: CircularProgressIndicator(color: AppColors.mintGreen,));
    }


    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 1, // We only have one order in this case
      itemBuilder: (context, index) {
        final order = purchaseOrder[index]['purchaseOrder'];
        final orderDetails = purchaseOrder[index]['purchaseOrderDtls'];
        final isExpanded = _expandedIndices.contains(index);

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
                                order['partnerPurchaseOrderId'],
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
                                _getStatusFromCode(order['orderStatusCd']),
                                style: TextStyle(
                                  color: Colors.green.shade700,
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
                            Icon(Icons.restaurant, color: Colors.red.shade400),
                            const SizedBox(width: 8),
                            Text(
                              '${order['restaurantName']}', // You might want to add this to your API response
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
                                Icon(Icons.access_time, color: Colors.grey.shade600, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.parse(order['deliveredTime'])),
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
                        ...orderDetails.map<Widget>((item) => Padding(
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
                                        'x${item['acceptedQuantity']}',
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      item['partnerFoodCode'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₹ ${200}', // Price is not available in the current data structure
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                        const Divider(color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹ ${orderDetails.fold(0, (sum, item) => sum + (200 * item['acceptedQuantity']))}',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 18,
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
        ).animate().fadeIn(duration: 800.ms, delay: (50 * index).ms).slideY(begin: -0.2, end: 0);
      },
    );
  }
}