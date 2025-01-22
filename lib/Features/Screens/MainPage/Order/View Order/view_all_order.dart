import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Widgets/Common/no-data-found.dart';
import '../../../../../Provider/inward_order_provider.dart';
import '../../../../../Widgets/Common/app_colors.dart';
import '../Common/order_card.dart';

class ViewAllOrder extends StatefulWidget {
  static const String routeName = '/view-order';
  const ViewAllOrder({super.key});
  @override
  State<ViewAllOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewAllOrder> {
  @override
  void initState() {
    super.initState();
    print("partnerPurchaseOrderId");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InwardOrderDtlProvider>().getAllOrderedItems();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    final provider =
    Provider.of<InwardOrderDtlProvider>(context, listen: false);
    await provider.getAllOrderedItems();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: AppColors.black),
          backgroundColor: Colors.transparent,
          title: Text('Inward Orders', style: TextStyle(color: Colors.black)),
        ),
        body: Consumer<InwardOrderDtlProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mintGreen,
                    ));
              }
              if (provider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(provider.error!),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mintGreen),
                        onPressed: _loadData,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                  child: provider.purchaseOrders.isEmpty
                      ? Center(child: NoDataFound(title: "orders"))
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          itemCount: provider.purchaseOrders.length,
                          itemBuilder: (context, index) {
                            return OrderCard(
                                order: provider.purchaseOrders[index]);
                          },
                        ),
                      ),
                    ],
                  ));
            }),
      ),
    );
  }
}
