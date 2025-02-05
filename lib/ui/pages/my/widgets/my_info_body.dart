import 'package:applus_market/data/model_view/user/my_info_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/utils/logger.dart';
import '../../../../data/model/auth/user.dart';

class MyInfoBody extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  MyInfoBody({required this.formKey, super.key});

  @override
  ConsumerState<MyInfoBody> createState() => _MyInfoBodyState();
}

class _MyInfoBodyState extends ConsumerState<MyInfoBody> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMyInfo();
  }

  String _formattedDate(DateTime picked) {
    String formattedDate =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

    return formattedDate;
  }

  void _getMyInfo() async {
    MyInfoVM myInfoVM = ref.read(myInfoProvider.notifier);
    await myInfoVM.getMyInfo();
    User user = ref.read(myInfoProvider);
    logger.i(user.toString());
    setState(() {
      _nameController.text = user.name ?? '';
      _birthDateController.text = user.birthday != null
          ? _formattedDate(user.birthday!) // 🎯 null 체크 후 변환
          : '';
      _emailController.text = user.email ?? '';
      _nicknameController.text = user.nickName ?? '';
      _phoneNumberController.text = user.hp ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildProfileImage(),
          SizedBox(height: 24),
          _buildTextField(
              label: '이름',
              controller: _nameController,
              onChanged: (value) {}
              //ref.read(userProfileProvider.notifier).updateName(value),
              ,
              readOnly: true),
          SizedBox(height: 16),
          _buildTextField(
              label: '닉네임',
              controller: _nicknameController,
              onChanged: (value) {}
              //ref.read(userProfileProvider.notifier).updateNickname(value),
              ),
          SizedBox(height: 16),
          _buildTextField(
            label: '생년월일',
            controller: _birthDateController,
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: '휴대폰 번호',
            controller: _phoneNumberController,
            onChanged: (value) {},
            //  ref.read(userProfileProvider.notifier).updatePhoneNumber(value),
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: '이메일', controller: _emailController, onChanged: (value) {},
            //      ref.read(userProfileProvider.notifier).updateEmail(value),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.person, size: 50, color: Colors.grey[400]),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 18,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.camera_alt, color: Colors.white),
                onPressed: () {
                  // TODO: 이미지 선택 구현
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    void Function(String)? onChanged,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label을(를) 입력해주세요';
        }
        return null;
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      String formattedDate = _formattedDate(picked);
      _birthDateController.text = formattedDate;
      //  ref.read(userProfileProvider.notifier).updateBirthDate(formattedDate);
    }
  }
}
