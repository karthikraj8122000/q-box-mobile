class ScanResult {
  final String code;
  int status; // 9 for accepted, 8 for rejected, 7 for pending

  ScanResult({
    required this.code,
    this.status = 7,
  });
}

