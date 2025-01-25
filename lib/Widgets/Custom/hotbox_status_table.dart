import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/dashboard_provider.dart';
import '../Common/app_colors.dart';

class HotboxStatusTable extends StatelessWidget {
  final List<dynamic> hotelDetails;

  const HotboxStatusTable({Key? key, required this.hotelDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> flattenedData = [];

    for (var hotel in hotelDetails) {
      for (var sku in hotel['skuList']) {
        flattenedData.add({
          'restaurantName': hotel['restaurantName'],
          'skuCode': sku['skuCode'],
          'description': sku['description'],
          'hotBoxCount': sku['hotBoxCount']
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Hotel Details', style: TextStyle(color: Colors.white)),
      ),
      body: Consumer<DashboardProvider>(builder: (context, provider, child){
        if (provider.isLoading) {
          return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mintGreen,
              ));
        }
       return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    columnSpacing: 20,
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.red.shade100),
                    border: TableBorder.all(color: Colors.red.shade200, width: 1),
                    columns: [
                      DataColumn(
                        label: Text('Restaurant',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                      ),
                      DataColumn(
                        label: Text('SKU',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                      ),
                      DataColumn(
                        label: Text('Description',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                      ),
                      DataColumn(
                        label: Text('In Hot Box Count',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                      ),
                    ],
                    rows: flattenedData.map((item) => DataRow(
                        cells: [
                          DataCell(
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(
                                item['restaurantName'],
                                style: TextStyle(color: Colors.black87),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 70),
                              child: Text(
                                item['skuCode'],
                                style: TextStyle(color: Colors.black87),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(
                                item['description'],
                                style: TextStyle(color: Colors.black87),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.green.shade300, width: 1)
                              ),
                              child: Text(
                                  item['hotBoxCount'].toString(),
                                  style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ),
                          ),
                        ]
                    )).toList(),
                  ),
                ),
              ),
            );
          },
        );
      })
      );

  }
}