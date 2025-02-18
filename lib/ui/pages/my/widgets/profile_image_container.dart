import 'package:applus_market/_core/utils/apiUrl.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/ui/widgets/image_network_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/utils/logger.dart';
import '../../../../data/gvm/image_picker_provider.dart';
import '../../../../data/model/auth/login_state.dart';
import '../../../widgets/image_container.dart';

class ProfileImageContainer extends ConsumerWidget {
  double width;
  double height;
  ProfileImageContainer({this.width = 90, this.height = 90, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionGVM gvm = ref.read(LoginProvider.notifier);
    SessionUser user = ref.watch(LoginProvider);
    ImagePickerNotifier imagePickerNotifier =
        ref.read(imagePickerProvider.notifier);

    return Stack(
      children: [
        Container(
          width: width,
          height: height,
        ),
        Positioned(
          left: 0,
          top: 0,
          child: (user.profileImg == null)
              ? ImageContainer(
                  width: width,
                  height: height,
                  borderRadius: 40,
                  imgUri: defaultProfile,
                )
              : ImageNetworkContainer(
                  width: width,
                  height: height,
                  borderRadius: 40,
                  imgUri: '$apiUrl/uploads/profile/${user.profileImg!}'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () async {
              await imagePickerNotifier.pickerProfileImg(user.id!);
              logger.i('${imagePickerNotifier.updateImage}');
            },
            child: Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(17.5),
                    border: Border.all(color: Colors.white, width: 0.5)),
                child: Icon(
                  CupertinoIcons.camera_fill,
                  size: 16,
                  color: Colors.black38,
                )),
          ),
        )
      ],
    );
  }
}
