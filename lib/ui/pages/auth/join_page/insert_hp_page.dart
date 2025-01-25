import 'package:applus_market/ui/pages/auth/login_page/widgets/login_form_field.dart';
import 'package:flutter/material.dart';

import '../../../../_core/logger.dart';

class InsertHpPage extends StatefulWidget {
  InsertHpPage({super.key});

  @override
  State<InsertHpPage> createState() => _InsertPasswordPageState();
}

class _InsertPasswordPageState extends State<InsertHpPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final List<String> carriers = [
    "SKT",
    "KT",
    "LG U+",
    "SKT 알뜰폰",
    "KT 알뜰폰",
    "LG U+ 알뜰폰",
  ];
  String? selectedCarrier;
  bool selectOn = false;

  void showCarrierSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "통신사를 선택해 주세요",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              ...carriers.map((carrier) => ListTile(
                    title: Text(carrier, style: TextStyle(fontSize: 16)),
                    onTap: () {
                      setState(() {
                        selectedCarrier = carrier;
                        selectOn = true; // 선택 시 전화번호 입력창 표시
                      });
                      Navigator.pop(context); // 모달 닫기
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text('회원정보 입력'),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 화면 터치 시 키보드 닫기
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      (selectedCarrier == null)
                          ? "통신사를 선택해 주세요"
                          : "휴대폰 번호를 입력해 주세요",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => showCarrierSelectionBottomSheet(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCarrier ?? "통신사 선택",
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedCarrier == null
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (selectOn)
                      TextFormField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "010-1234-5678",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    const Spacer(), // 남은 공간을 채우기 위해 Spacer 추가
                  ],
                ),
              ),
              Positioned(
                bottom: 16, // 키보드 위로 버튼 위치
                left: 16,
                right: 16,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/join/insertEmail');
                    },
                    child: Text('다음'),
                  ),
                ),
              ),
            ],
          ),
        ),
        // bottomSheet: Visibility(
        //   visible: selectOn,
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         "통신사를 선택해 주세요",
        //         style: TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.black,
        //         ),
        //       ),
        //       const SizedBox(height: 10),
        //       ...carriers.map((carrier) => ListTile(
        //             title: Text(carrier, style: TextStyle(fontSize: 16)),
        //             onTap: () {
        //               setState(() {
        //                 selectOn = true;
        //                 selectedCarrier = carrier;
        //               });
        //               Navigator.pop(context);
        //             },
        //           )),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
