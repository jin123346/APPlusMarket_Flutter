import 'dart:io';

import 'package:applus_market/ui/pages/product/widgets/product_register_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
      final current = ref.read(imagePathsProvider.notifier).state;
      if (current.length >= 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('최대 10개의 이미지만 추가할 수 있습니다.')),
        );
        return;
      }
      final newImage = ImageItem(
        path: pickedFile.path,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      ref.read(imagePathsProvider.notifier).state = [...current, newImage];
    }
  }

  // 이미지 제거 함수
  void removeImage(int index) {
    final current = ref.read(imagePathsProvider.notifier).state;
    final updated = List<ImageItem>.from(current)..removeAt(index);
    ref.read(imagePathsProvider.notifier).state = updated;
  }

  @override
  Widget build(BuildContext context) {
    final imagePaths = ref.watch(imagePathsProvider);

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
            child: imagePaths.isNotEmpty
                ? ReorderableListView(
                    scrollDirection: Axis.horizontal,
                    onReorder: (oldIndex, newIndex) {
                      final List<ImageItem> items = List.from(imagePaths);
                      if (newIndex > oldIndex) newIndex -= 1;
                      final item = items.removeAt(oldIndex);
                      items.insert(newIndex, item);
                      ref.read(imagePathsProvider.notifier).state = items;
                    },
                    children: [
                      for (int index = 0; index < imagePaths.length; index++)
                        Container(
                          key: ValueKey(imagePaths[index].id),
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image:
                                        FileImage(File(imagePaths[index].path)),
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
                                  onTap: () => removeImage(index),
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
}
