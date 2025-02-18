import 'dart:io';

import 'package:applus_market/ui/pages/product/widgets/product_register_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/model_view/product/image_item_view_model.dart';

class ImageSelectContainer extends ConsumerStatefulWidget {
  const ImageSelectContainer({super.key});

  @override
  ConsumerState<ImageSelectContainer> createState() =>
      _ImageSelectContainerState();
}

class _ImageSelectContainerState extends ConsumerState<ImageSelectContainer> {
  // 이미지 추가 함수 (이미지 피커 사용)
  Future<void> addImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (ref.read(imageStateProvider).length >= 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('최대 10개의 이미지만 추가할 수 있습니다.')),
        );
        return;
      }
      ref.read(imageStateProvider.notifier).addNewImage(File(pickedFile.path));
    }
  }

  // 이미지 제거 함수
  void removeImage(ImageItem image) {
    ref.read(imageStateProvider.notifier).removeImage(image);
  }

  @override
  Widget build(BuildContext context) {
    final imageState = ref.watch(imageStateProvider); // 이미지 상태 가져오기
    final imageNotifier = ref.read(imageStateProvider.notifier);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: addImage,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add_a_photo, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 90,
            child: imageState.isNotEmpty
                ? ReorderableListView(
                    scrollDirection: Axis.horizontal,
                    onReorder: (oldIndex, newIndex) {
                      imageNotifier.reorderImages(oldIndex, newIndex);
                    },
                    children: [
                      for (int index = 0; index < imageState.length; index++)
                        Container(
                          key: ValueKey(
                              imageState[index].id ?? imageState[index].path),
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: _getImageProvider(imageState[index]),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              //위치가 첫번째 이면 대표 사진으로 지정
                              if (index == 0)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black54,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: const Text(
                                      '대표 사진',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => removeImage(imageState[index]),
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close,
                                        color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
                : Container(),
          ),
        ),
      ],
    );
  }

  // 기존 이미지와 새로 추가된 이미지를 구분하여 표시
  ImageProvider _getImageProvider(ImageItem image) {
    if (image.path.startsWith('http')) {
      return NetworkImage(image.path); // 서버 이미지 (URL)
    } else {
      return FileImage(File(image.path)); // 로컬 파일 이미지
    }
  }
}
