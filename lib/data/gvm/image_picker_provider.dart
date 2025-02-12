import 'dart:io';

import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/repository/image_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../_core/utils/logger.dart';
import '../../main.dart';

class ImagePickerNotifier extends Notifier<File?> {
  final ImageRepository imageRepository = const ImageRepository();
  final ImagePicker _picker = ImagePicker();
  final mContext = navigatorkey.currentContext!;

  String updateImage = "";

  @override
  File? build() {
    return null;
  }

  Future<bool> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      state = File(image.path); // Update the selected image state
      logger.i('이미지 저장됨 $state');
      return true;
    }
    logger.w('이미지가 선택되지 않음');
    return false;
  }

  Future<void> pickerProfileImg(int userId) async {
    bool isSelected = await pickImageFromGallery();
    if (!isSelected) {
      logger.w('이미지가 선택되지 않음');
      return;
    }
    if (state != null) {
      logger.i('이미지 저장 확인');
      DialogHelper.showAlertDialog(
        context: mContext,
        title: '저장하시겠습니까?',
        onConfirm: () {
          logger.i('확인 버튼 눌림 - 업로드 시작');
          uploadsProfileImg(userId);
        },
        isCanceled: true,
      );
    } else {
      logger.w('이미지가 선택되지 않음');
      CustomSnackbar.showSnackBar('이미지를 선택해 주세요');
      Navigator.pop(mContext);
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      state = File(image.path); // Update the selected image state
    }
  }

  Future<void> uploadsProfileImg(int id) async {
    logger.i('이미지 picker 업데이트 프로세스 시작 ');

    try {
      logger.i('여기로 들어옴222');

      Map<String, dynamic> resBody =
          await imageRepository.profileUpload(state!, id);

      logger.i(resBody);
      if (resBody['status'] == 'failed') {
        return;
      }

      String uploadedImageUrl = resBody['data'];
      updateImage = uploadedImageUrl;
      ref.read(LoginProvider.notifier).updateProfileImage(uploadedImageUrl);
      Navigator.pop(mContext);

      return;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('이미지 업로드 실패', stackTrace);
      Navigator.pop(mContext);

      return;
    }
  }

  void removeImage(int index) {
    state = null;
  }
}

class MultiImagePickerNotifier extends Notifier<List<File>> {
  final ImagePicker _picker = ImagePicker();

  @override
  List<File> build() => []; // Initial state (empty list)

  /// **Pick Multiple Images from Gallery**
  Future<void> pickMultipleImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      state = images.map((image) => File(image.path)).toList();
    }
  }

  /// **Remove Selected Image at Index**
  void removeImage(int index) {
    final updatedList = [...state];
    updatedList.removeAt(index);
    state = updatedList;
  }
}

final multiImagePickerProvider =
    NotifierProvider<MultiImagePickerNotifier, List<File>>(
        () => MultiImagePickerNotifier());

final imagePickerProvider =
    NotifierProvider<ImagePickerNotifier, File?>(() => ImagePickerNotifier());
