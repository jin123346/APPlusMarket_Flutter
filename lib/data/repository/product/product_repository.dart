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
    //바디 추출
    Map<String, dynamic> responseBody =
        response.data; // header, body 중에 body 만 추출
    logger.i(responseBody);
    return responseBody;
  }
}
