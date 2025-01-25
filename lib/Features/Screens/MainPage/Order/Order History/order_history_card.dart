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

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                        return ListTile(
                          title: Text(
                            '${orderDetail['partnerFoodCode']}',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Wrap(
                            children: [
                              AppTwoText(firstText: "Qty: ", secondText: '${orderDetail['orderQuantity']}', fontSize: 14, firstColor: AppColors.lightBlack, secondColor: AppColors.black),
                              SizedBox(width: 12,),
                              AppTwoText(firstText: "Accepted: ", secondText: '${orderDetail['acceptedQuantity']}', fontSize: 14, firstColor: AppColors.lightBlack, secondColor: AppColors.black),
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
