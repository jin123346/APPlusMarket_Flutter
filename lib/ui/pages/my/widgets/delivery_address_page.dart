import 'package:flutter/material.dart';
import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../../_core/utils/logger.dart';

/*
    2025.1.29  하진희 우편번호 검색 페이지
 */
class DeliveryAddressPage extends StatefulWidget {
  final TextEditingController address1Controller;
  final TextEditingController postCodeController;
  final TextEditingController address2Controller;

  DeliveryAddressPage(this.postCodeController, this.address1Controller,
      this.address2Controller);

  @override
  _DeliveryAddressPageState createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _buildAddressField();
  }

  Widget _buildAddressField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('주소'),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.postCodeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    focusColor: Colors.grey,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade500, width: 0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _searchAddress,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey),
                ),
                child: Text(
                  '우편번호 검색',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: widget.address1Controller,
            readOnly: true,
            decoration: InputDecoration(
              focusColor: Colors.grey,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500, width: 0.5),
              ),
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: widget.address2Controller,
            decoration: InputDecoration(
              focusColor: Colors.grey,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500, width: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchAddress() async {
    try {
      final DataModel? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('주소 검색'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: DaumPostcodeSearch(
                onConsoleMessage: (controller, message) {
                  print(message.message);
                },
                onReceivedError: (controller, request, error) {
                  print('Error: ${error.description}');
                },
              ),
            ),
          ),
        ),
      );

      if (result != null) {
        logger.i('주소 결과  : $result');
        setState(() {
          widget.address1Controller.text = result.address +
              (result.buildingName?.isNotEmpty == true
                  ? ' ${result.buildingName}'
                  : '');
          widget.postCodeController.text = result.zonecode;
        });
      }
    } catch (e) {
      print('Error searching address: $e');
    }
  }
}
