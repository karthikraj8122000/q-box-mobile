import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Provider/order_history_provider.dart';
import 'package:qr_page/Services/token_service.dart';
import 'package:qr_page/Widgets/Common/rich_text.dart';
import '../../../../../Widgets/Common/app_colors.dart';
import '../../../../../Widgets/Common/no-data-found.dart';

class OrderHistoryCard extends StatefulWidget {
  const OrderHistoryCard({Key? key}) : super(key: key);

  @override
  State<OrderHistoryCard> createState() => _OrderHistoryCardState();
}

class _OrderHistoryCardState extends State<OrderHistoryCard> {

  TokenService tokenService = TokenService();

  @override
  void initState() {
    super.initState();
    _fetchInwardOrderData();
  }

  void _fetchInwardOrderData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInwardData();
    });
  }

  Future<void> _loadInwardData() async {
    if (!mounted) return;
    var user = await tokenService.getUser();
    final provider = Provider.of<OrderHistoryProvider>(context, listen: false);
    Map<String, dynamic> userData;
    if (user is String) {
      userData = jsonDecode(user);
    } else if (user is Map<String, dynamic>) {
      userData = user;
    } else {
      print('Unexpected type for user: ${user.runtimeType}');
      return;
    }
    final qboxEntitySno = userData['qboxEntitySno'];
    if (qboxEntitySno != null) {
      print("Hi there!");
      await provider.fetchInwardOrders(qboxEntitySno);
    } else {
      print('No qboxEntitySno found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Consumer<OrderHistoryProvider>(
      builder: (context, provider, child) {

        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.mintGreen,));
        }
        if (provider.purchaseOrder.isEmpty) {
          return NoDataFound(title: "inward order histories");
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: provider.purchaseOrder.length,
            itemBuilder: (context, orderIndex) {
              var order = provider.purchaseOrder[orderIndex];
              var purchaseOrder = order['purchaseOrder'];
              var purchaseOrderDetails = order['purchaseOrderDtls'];

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  textColor: Colors.red,
                  leading: Icon(Icons.history,size: 30,),
                  iconColor: Colors.red,
                  title: Text(
                    'Order ID: ${purchaseOrder['partnerPurchaseOrderId']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Delivered: ${purchaseOrder['deliveredTime']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: purchaseOrderDetails.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, detailIndex) {
                        var orderDetail = purchaseOrderDetails[detailIndex];
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Title Container with flexible size
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Optional padding
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${orderDetail['partnerFoodCode']}',
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
                                  ),
                                ),
                              ),

                              // Trailing section
                              Wrap(
                                spacing: 12, // Adds spacing between trailing items
                                children: [
                                  AppTwoText(
                                    firstText: "Qty: ",
                                    secondText: '${orderDetail['orderQuantity']}',
                                    fontSize: 14,
                                    firstColor: AppColors.lightBlack,
                                    secondColor: AppColors.black,
                                  ),
                                  AppTwoText(
                                    firstText: "Accepted: ",
                                    secondText: '${orderDetail['acceptedQuantity']}',
                                    fontSize: 14,
                                    firstColor: AppColors.lightBlack,
                                    secondColor: AppColors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );

                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
