import 'package:dio/dio.dart';

import '../../../_core/utils/dio.dart';

class AddressRepository {
  const AddressRepository();

  // 주소 조회
  Future<Map<String, dynamic>> findMyAddress(int userId) async {
    Response response = await dio.get('/my/address/$userId');
    return response.data;
  }

  Future<Map<String, dynamic>> saveAddress(Map<String, dynamic> body) async {
    Response response = await dio.post('/my/address/register', data: body);
    return response.data;
  }

  Future<Map<String, dynamic>> modifyAddress(Map<String, dynamic> body) async {
    Response response = await dio.put('/my/address/modify', data: body);
    return response.data;
  }

  Future<Map<String, dynamic>> deleteAddress(int userId, int addressId) async {
    Response response =
        await dio.delete('/my/address/${userId}/deleted/$addressId');
    return response.data;
  }
}
