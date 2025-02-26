import 'dart:io';

import 'package:dio/dio.dart';

import '../../../_core/utils/dio.dart';
import '../../../_core/utils/logger.dart';

class ProductRepository {
  const ProductRepository();
  //상품 등록 요청
  Future<Map<String, dynamic>> insertProduct(
    Map<String, dynamic> reqData, {
    List<File>? imageFiles,
  }) async {
    logger.i('imageFiles : ${imageFiles}');
    imageFiles ??= [];
    // 이미지 파일들을 MultipartFile로 변환
    final List<MultipartFile> multipartImages = await Future.wait(
      imageFiles.map((file) async => await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          )),
    );
    // FormData 생성 (이미지 파트를 반드시 포함)
    final formData = FormData.fromMap({
      ...reqData,
      'images': multipartImages,
    });
    Response response = await dio.post('/product/insert', data: formData);
    logger.i('response : $response');
    //바디 추출
    Map<String, dynamic> responseBody =
        response.data; // header, body 중에 body 만 추출
    logger.i('responseBody : $responseBody');
    return responseBody;
  }

  Future<Map<String, dynamic>> getProductsPage({required int page}) async {
    try {
      Response response = await dio.get(
        '/product/listpage',
        queryParameters: {'page': page},
      );
      return response.data;
    } catch (e) {
      logger.e('상품 목록 불러오기 실패: $e');
      return {'status': 'fail', 'message': '상품 목록을 불러올 수 없습니다.'};
    }
  }

  Future<Map<String, dynamic>> selectProduct(
      {required int id, int? userId}) async {
    Response response = await dio.get(
      '/product/$id',
      queryParameters: {
        'userId': userId,
      },
    );
    logger.e("Updated State: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> updateWishList(int productId, int userId) async {
    Response response = await dio.put(
      '/product/wish/${productId}/${userId}',
    );
    logger.i("Updated State: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> searchProductForSamsung(String keyword) async {
    Response response = await dio
        .get('/api/samsung/search', queryParameters: {"keyword": keyword});

    return response.data;
  }

  Future<Map<String, dynamic>> selectForMyList(
      Map<String, dynamic> body) async {
    Response response = await dio.get('/product/on-sale', data: body);

    return response.data;
  }

  Future<Map<String, dynamic>> selectForMyCompletedList(
      Map<String, dynamic> body) async {
    Response response = await dio.get('/product/completed', data: body);

    return response.data;
  }

  Future<Map<String, dynamic>> reloadProduct(int productId) async {
    Response response = await dio.put('/product/reload/${productId}');

    return response.data;
  }

  Future<Map<String, dynamic>> updateStatus(
      int productId, String status) async {
    Response response = await dio.put('/product/${productId}/${status}');

    return response.data;
  }

  Future<Map<String, dynamic>> getProductForModify(
      int productId, int userId) async {
    Response response = await dio.get('/product/modify/${productId}/${userId}');

    return response.data;
  }

  Future<Map<String, dynamic>> modifyProduct(
      int productId, int userId, FormData formdata) async {
    Response response = await dio.put('/product/modify/${productId}/${userId}',
        data: formdata,
        options: Options(
          contentType: "multipart/form-data",
          headers: {
            "Accept": "application/json",
          },
        ));

    return response.data;
  }

  Future<Map<String, dynamic>> getMyWishList() async {
    Response response = await dio.get('/product/wish/list');
    logger.i(response);
    return response.data;
  }

  Future<Map<String, dynamic>> pushRecentProducts(
      Map<String, dynamic> data) async {
    Response response = await dio.post('/api/recent/product', data: data);
    logger.i(response);
    return response.data;
  }
}
