import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:technical_test/helper/constant.dart';
import 'package:technical_test/response/response_api.dart';

class DioClient {
  final dio = Dio();

  Future<Either<String, ResponseApi>> getRequest({
    required String url,
    required Map<String, dynamic> queryParam,
  }) async {
    try {
      print('param bang $queryParam');
      final response = await dio.get(
        '${Constants.baseUrl}$url',
        queryParameters: queryParam,
      );
      print('Respon bang: ${response.data}');
      if (response.statusCode == 200) {
        return Right(ResponseApi.fromJson(response.data));
      }
      return Left(response.data['message'] ?? 'Error Pak');
    } catch (e) {
      print('error bang ${e.toString()}');
      return Left(e.toString());
    }
  }
}
