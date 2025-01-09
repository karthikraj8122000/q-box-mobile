import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:qr_page/Services/api_service.dart';
import 'package:qr_page/Services/toast_service.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';

class FoodViewScreen extends StatefulWidget {
  final int purchaseOrderSno;

  const FoodViewScreen({
    Key? key,
    required this.purchaseOrderSno,
  }) : super(key: key);

  @override
  _FoodViewScreenState createState() => _FoodViewScreenState();
}

class _FoodViewScreenState extends State<FoodViewScreen> {
  bool isLoading = true;
  Map<String, dynamic>? orderDetails;
  List<Map<String, dynamic>>? inventoryItems;
  bool isExpanded = false;
  final ApiService apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];
  TextEditingController rejectionReasonController = TextEditingController();
  final CommonService commonService = CommonService();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final orderResponse = await apiService.post(
          '8912',
          'masters',
          'search_purchase_order_dtl',
          {"purchaseOrderSno": widget.purchaseOrderSno});
      if (orderResponse['data'] != null) {
        if (orderResponse['data'].isNotEmpty) {
          orderDetails = orderResponse['data'][0];
          final inventoryResponse = await apiService.post(
              '8912',
              'masters',
              'search_sku_inventory',
              {"purchaseOrderDtlSno": orderDetails!['purchaseOrderDtlSno']});
          print("@@@@@@@@@@@@@@@$inventoryResponse");
          if (inventoryResponse['data'] != null) {
            inventoryItems =
                List<Map<String, dynamic>>.from(inventoryResponse['data']);
          }
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> acceptFood(skuInventorySno) async {
    print(skuInventorySno);
    try {
      final result = await apiService.post('8912', 'masters', 'accept_sku',
          {"skuInventorySno": skuInventorySno});
      print(result);
      if (result['data'] != null) {
        inventoryItems = List<Map<String, dynamic>>.from(result['data']);
        setState(() {});
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showRejectionDialog(int skuInventorySno) async {
    selectedImages.clear();
    rejectionReasonController.clear();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            'Reject Food Item',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: rejectionReasonController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Enter rejection reason',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Add Photos (Optional)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 100,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ...selectedImages
                                      .map(
                                        (image) => Padding(
                                      padding:
                                      const EdgeInsets.only(right: 8),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: FileImage(image),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: Icon(Icons.close,
                                                    color: Colors.red,
                                                    size: 20),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedImages
                                                        .remove(image);
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                      .toList(),
                                  if (selectedImages.length < 3)
                                    InkWell(
                                      onTap: () async {
                                        final XFile? image =
                                        await _picker.pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 70,
                                        );
                                        if (image != null) {
                                          setState(() {
                                            selectedImages
                                                .add(File(image.path));
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: AppColors.black),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Reject'),
                            onPressed: () {
                              if (rejectionReasonController.text
                                  .trim()
                                  .isEmpty) {
                                commonService.presentToast(
                                    'Please enter rejection reason');
                                return;
                              }
                              Navigator.pop(context, true);
                              _submitRejection(skuInventorySno);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitRejection(int skuInventorySno) async {
    try {
      List<String> base64Images = [];
      for (File image in selectedImages) {
        List<int> imageBytes = await image.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        base64Images.add(base64Image);
      }

      final rejectionData = {
        "skuInventorySno": skuInventorySno,
        "rejectionReason": rejectionReasonController.text,
        "images": base64Images,
      };

      final result = await apiService.post(
        '8912',
        'masters',
        'reject_sku',
        rejectionData,
      );

      if (result['data'] != null) {
        inventoryItems = List<Map<String, dynamic>>.from(result['data']);
        setState(() {});
        commonService.presentToast("Item rejected successfully");
      }
    } catch (e) {
      print('Error rejecting item: $e');
      commonService.presentToast('Failed to reject item. Please try again.');
    }
  }

  Future<void> rejectFood(int skuInventorySno) async {
    await _showRejectionDialog(skuInventorySno);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Food Details',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: _buildLoadingIndicator())
          : orderDetails == null
              ? Center(child: Text('No data available'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildFoodDetailsCard(),
                      SizedBox(height: 16),
                      _buildInventoryList(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.mintGreen),
          ),
          SizedBox(height: 16),
          Text(
            'Loading food details...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodDetailsCard() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.mintGreen,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderDetails!['partnerFoodCode'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   'Code: ${orderDetails!['partnerFoodCode']}',
                      //   style: TextStyle(
                      //     color: Colors.white.withOpacity(0.9),
                      //     fontSize: 14,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInfoRow(
                  'Order Quantity',
                  '${orderDetails!['orderQuantity']} items',
                  Icons.shopping_cart,
                ),
                SizedBox(height: 16),
                _buildInfoRow(
                  'Price per SKU',
                  '₹${orderDetails!['skuPrice']}',
                  Icons.payments,
                ),
                SizedBox(height: 16),
                _buildInfoRow(
                  'Accepted Quantity',
                  '${orderDetails!['acceptedQuantity']} items',
                  Icons.check_circle,
                ),
                SizedBox(height: 16),
                _buildInfoRow(
                  'Total Amount',
                  '₹${orderDetails!['skuPrice'] * orderDetails!['orderQuantity']}',
                  Icons.account_balance_wallet,
                  isHighlighted: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    return Column(
      children: [

        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2,
                        color: AppColors.mintGreen,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Inventory Items (${inventoryItems?.length ?? 0})',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded) ...[
                Divider(height: 1),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: inventoryItems?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = inventoryItems![index];
                    return _buildInventoryItem(item, index);
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryItem(Map<String, dynamic> item, int index) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return isTablet
        ? Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.mintGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: AppColors.mintGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['uniqueCode'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Stage: ${_getStageText(item['wfStageCd'])}',
                        style: TextStyle(
                          color: item['wfStageCd'] == 10
                              ? Colors.green[600]
                              : item['wfStageCd'] == 8
                                  ? Colors.red[600]
                                  : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                item['wfStageCd'] == 7
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                elevation: 0,
                                shadowColor: Colors.greenAccent,
                              ),
                              icon: Icon(Icons.check,
                                  size: 20, color: Colors.white),
                              label: Text(
                                "Accept",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                acceptFood(item['skuInventorySno']);
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                elevation: 0,
                                shadowColor: Colors.redAccent,
                              ),
                              icon: Icon(Icons.close,
                                  size: 20, color: Colors.white),
                              label: Text(
                                "Reject",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                rejectFood(item['skuInventorySno']);
                              },
                            ),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.mintGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: AppColors.mintGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['uniqueCode'],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Stage: ${_getStageText(item['wfStageCd'])}',
                          style: TextStyle(
                            color: item['wfStageCd'] == 10
                                ? Colors.green[600]
                                : item['wfStageCd'] == 8
                                    ? Colors.red[600]
                                    : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                item['wfStageCd'] == 7
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                elevation: 0,
                                shadowColor: Colors.greenAccent,
                              ),
                              icon: Icon(Icons.check,
                                  size: 20, color: Colors.white),
                              label: Text(
                                "Accept",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                acceptFood(item['skuInventorySno']);
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                elevation: 0,
                                shadowColor: Colors.redAccent,
                              ),
                              icon: Icon(Icons.close,
                                  size: 20, color: Colors.white),
                              label: Text(
                                "Reject",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                rejectFood(item['skuInventorySno']);
                              },
                            ),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,
      {bool isHighlighted = false}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.mintGreen.withOpacity(0.1)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? AppColors.mintGreen.withOpacity(0.3)
              : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHighlighted ? AppColors.mintGreen : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isHighlighted ? Colors.white : Colors.grey[600],
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: isHighlighted ? AppColors.mintGreen : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStageText(int stageCd) {
    // Replace with your actual stage mappings
    switch (stageCd) {
      case 6:
        return "Pending";
      case 7:
        return 'In Progress';
      case 8:
        return 'Rejected';
      case 10:
        return 'Accepted';
      case 12:
        return 'Sku returned to Hot box';
      case 11:
        return 'Sku loaded in Q-box';
      case 13:
        return 'Outward Delivery Picked up';
      default:
        return 'Unknown Stage';
    }
  }
}
