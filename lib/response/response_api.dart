class ResponseApi {
  final int status;
  final String message;
  final dynamic data;

  ResponseApi({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ResponseApi.fromJson(Map<String, dynamic> json) {
    return ResponseApi(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}
