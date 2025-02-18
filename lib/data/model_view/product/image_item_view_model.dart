import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 이미지 항목 클래스
class ImageItem {
  final String path;
  final String? id; // 기존 이미지라면 ID가 있고, 새 이미지라면 없음3
  final int sequence; // 순서 추가
  ImageItem({required this.path, this.id, required this.sequence});

  ImageItem copyWith({String? path, String? id, int? sequence}) {
    return ImageItem(
      path: path ?? this.path,
      id: id ?? this.id,
      sequence: sequence ?? this.sequence,
    );
  }
}

// StateNotifier 선언 (기존 이미지, 새 이미지, 삭제된 이미지 관리)
class ImageStateNotifier extends StateNotifier<List<ImageItem>> {
  ImageStateNotifier() : super([]);

  // 기존 이미지 불러오기
  void setExistingImages(List<ImageItem> images) {
    state = images; // 서버에서 받아온 기존 이미지 리스트로 설정
  }

  // 새 이미지 추가하기 (드래그/순서 반영)
  void addNewImage(File file) {
    final newImage = ImageItem(path: file.path, sequence: state.length);

    // 상태 업데이트 (리스트 새로 생성)
    state = [...state, newImage];

    // newFiles 리스트에도 추가
    newFiles.add(file);

    print("새 이미지 추가됨: ${file.path}");
    print("현재 이미지 목록: ${state.map((img) => img.path).toList()}");
  }

  // 이미지 삭제 (기존 이미지라면 삭제 리스트에 추가)
  void removeImage(ImageItem image) {
    if (image.id != null) {
      removedImages.add(image.id!); // 삭제할 기존 이미지 ID 추가
    }
// 삭제 후 순서 재정렬
    state = state
        .where((img) => img != image)
        .toList()
        .asMap()
        .entries
        .map((entry) => entry.value.copyWith(sequence: entry.key))
        .toList();
  }

  // 이미지 순서 변경
  void reorderImages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final ImageItem movedImage = state.removeAt(oldIndex);
    state.insert(newIndex, movedImage);

    state = state
        .asMap()
        .entries
        .map((entry) => entry.value.copyWith(sequence: entry.key))
        .toList();
  }

  // 최종적으로 전송할 이미지 데이터 생성
  Future<Map<String, dynamic>> getImagesForUpdate() async {
    List<MultipartFile> newImageFiles = [];

    for (var img in newFiles) {
      File file = File(img.path);
      if (await file.exists()) {
        newImageFiles.add(
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last, // 파일명 설정
          ),
        );
      }
    }

    return {
      "existingImages": state
          .where((img) => img.id != null)
          .map((img) => {"id": img.id, "sequence": img.sequence})
          .toList(),
      "removedImages": removedImages,
      "newImages": newImageFiles, //  파일 데이터 추가
    };
  }

  // 삭제된 이미지 리스트
  List<String> removedImages = [];
  List<File> newFiles = [];

  void reset() {
    newFiles = [];
    removedImages = [];
    state = [];
  }
}

// Provider 생성
final imageStateProvider =
    StateNotifierProvider<ImageStateNotifier, List<ImageItem>>((ref) {
  return ImageStateNotifier();
});
