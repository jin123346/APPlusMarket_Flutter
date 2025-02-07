import 'dart:io';

import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:dio/dio.dart';

import '../../_core/utils/dio.dart';
import '../../_core/utils/logger.dart';

class ImageRepository {
  const ImageRepository();

  Future<Map<String, dynamic>> profileUpload(File imageFile, int id) async {
    final MultipartFile multipartImage = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last);
    // FormData 생성 (이미지 파트를 반드시 포함)
    final formData = FormData.fromMap({
      'image': multipartImage,
    });
    logger.i('image : $formData');
    Response response = await dio.post(
      '/my/profile/images/$id',
      data: formData,
    );
    return response.data;
  }
}
