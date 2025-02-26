import 'dart:io';
import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../_core/utils/dio.dart';

class ProductDetailWebView extends StatefulWidget {
  final String productUrl; // HTML 콘텐츠를 직접 받도록 수정

  const ProductDetailWebView({required this.productUrl, Key? key})
      : super(key: key);

  @override
  _ProductDetailWebViewState createState() => _ProductDetailWebViewState();
}

class _ProductDetailWebViewState extends State<ProductDetailWebView> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    try {
      // HTTP 요청으로 HTML 내용 가져오기
      final response = await dio.get(widget.productUrl);

      if (response.statusCode == 200) {
        String htmlContent = response.data;

        _controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                setState(() {
                  isLoading = progress < 100;
                });
              },
              onPageStarted: (String url) {
                setState(() {
                  isLoading = true;
                });
              },
              onPageFinished: (String url) {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            ),
          )
          ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            * {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

body {
  background-color: #f8f9fa;
  color: #2d3436;
  line-height: 1.6;
  padding: 16px;
  max-width: 768px;
  margin: 0 auto;
}

/* Main Title Styling */
.spec-itm-title {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
  color: #2d3436;
  padding-bottom: 0.75rem;
  border-bottom: 2px solid #e2e8f0;
  position: relative;
}

.spec-itm-title::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 60px;
  height: 2px;
  background-color: #3498db;
}

/* Spec Table Styling */
.spec-table {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  overflow: hidden;
  margin-bottom: 1rem;
}

.spec-table dl {
  padding: 1.25rem;
  border-bottom: 1px solid #e2e8f0;
  transition: all 0.3s ease;
}

.spec-table dl:last-child {
  border-bottom: none;
}

.spec-table dl:hover {
  background-color: #f8fafc;
  transform: translateY(-1px);
}

/* Category Title */
.spec-table dt {
  font-size: 1.125rem;
  font-weight: 600;
  color: #2d3436;
  margin-bottom: 1rem;
  display: flex;
  align-items: center;
  position: relative;
  padding-left: 1rem;
}

.spec-table dt::before {
  content: '';
  position: absolute;
  left: 0;
  width: 4px;
  height: 16px;
  background: #3498db;
  border-radius: 2px;
}

/* Item List */
.spec-table dd ol {
  list-style: none;
}

.spec-table dd li {
  margin-bottom: 1rem;
  padding-left: 1rem;
  position: relative;
}

.spec-table dd li:last-child {
  margin-bottom: 0;
}

/* Spec Item Title */
.spec-title {
  font-size: 0.875rem;
  color: #64748b;
  display: block;
  margin-bottom: 0.25rem;
  font-weight: 500;
}

/* Spec Description */
.spec-desc {
  font-size: 1rem;
  color: #334155;
  line-height: 1.5;
  word-break: break-word;
}

/* Yes/No Values */
.spec-desc:only-child {
  color: #2563eb;
  font-weight: 500;
}

/* Button Styling */
button.spec-title {
  background: none;
  border: none;
  text-align: left;
  padding: 0;
  color: #3498db;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  width: 100%;
}

button.spec-title:hover {
  color: #2980b9;
}

button.spec-title::after {
  content: '›';
  margin-left: auto;
  font-size: 1.25rem;
  transform: rotate(90deg);
  transition: transform 0.2s ease;
}

/* Popup Styling */
.layer-pop {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) scale(0.95);
  background: white;
  padding: 1.5rem;
  border-radius: 16px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  max-width: 90%;
  width: 400px;
  z-index: 1000;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.layer-pop.active {
  opacity: 1;
  visibility: visible;
  transform: translate(-50%, -50%) scale(1);
}

.layer-header h2 {
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: #2d3436;
  padding-right: 2rem;
}

.layer-content p {
  font-size: 0.9375rem;
  color: #4a5568;
  line-height: 1.6;
}

.pop-close {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: none;
  border: none;
  width: 2rem;
  height: 2rem;
  cursor: pointer;
  border-radius: 50%;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.pop-close:hover {
  background-color: #f1f5f9;
}

.pop-close::before,
.pop-close::after {
  content: '';
  position: absolute;
  width: 2px;
  height: 1rem;
  background: #64748b;
  transition: background 0.2s ease;
}

.pop-close::before {
  transform: rotate(45deg);
}

.pop-close::after {
  transform: rotate(-45deg);
}

.pop-close:hover::before,
.pop-close:hover::after {
  background: #334155;
}

/* Backdrop */
.layer-pop::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s ease;
  z-index: -1;
}

.layer-pop.active::before {
  opacity: 1;
  visibility: visible;
}

/* Loading States */
.loading-skeleton {
  background: linear-gradient(90deg, #f1f5f9 25%, #e2e8f0 50%, #f1f5f9 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
}

@keyframes loading {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}

/* Responsive Adjustments */
@media (max-width: 480px) {
  body {
    padding: 12px;
  }
  
  .spec-itm-title {
    font-size: 1.25rem;
    margin-bottom: 1rem;
  }
  
  .spec-table dt {
    font-size: 1rem;
  }
  
  .spec-table dl {
    padding: 1rem;
  }
  
  .layer-pop {
    width: 95%;
    padding: 1.25rem;
  }
}
          </style>
        </head>
        <body>
          $htmlContent
          <script>
            // 팝업 관련 JavaScript 
            document.querySelectorAll('button.spec-title').forEach(button => {
              button.addEventListener('click', function(e) {
                e.preventDefault();
                const targetId = this.getAttribute('data-popup-target');
                const popup = document.querySelector('.layer-pop');
                const title = this.innerText;
                const content = this.value;
                
                popup.querySelector('.layer-header h2').innerText = title;
                popup.querySelector('.layer-content p').innerText = content;
                popup.classList.add('active');
              });
            });
            
            document.querySelectorAll('.pop-close').forEach(button => {
              button.addEventListener('click', function() {
                this.closest('.layer-pop').classList.remove('active');
              });
            });
          </script>
        </body>
        </html>
      ''');
      } else {
        CustomSnackbar.showSnackBar('데이터 불러오는데 실패했습니다.');
        return;
      }
    } catch (e, stackTrace) {
      ExceptionHandler.handleException(e, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Dialog(
            insetPadding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "상세 정보",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                if (isLoading) LinearProgressIndicator(),
                Expanded(
                  child: WebViewWidget(controller: _controller),
                ),
              ],
            ),
          );
  }
}
