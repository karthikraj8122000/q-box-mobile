class OrderDetail {
  final int skuInventorySno;
  final int purchaseOrderDtlSno;
  final String uniqueCode;
  final int? salesOrderDtlSno;
  int wfStageCd;

  OrderDetail({
    required this.skuInventorySno,
    required this.purchaseOrderDtlSno,
    required this.uniqueCode,
    this.salesOrderDtlSno,
    required this.wfStageCd,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      skuInventorySno: json['skuInventorySno'],
      purchaseOrderDtlSno: json['purchaseOrderDtlSno'],
      uniqueCode: json['uniqueCode'],
      salesOrderDtlSno: json['salesOrderDtlSno'],
      wfStageCd: json['wfStageCd'],
    );
  }
}

