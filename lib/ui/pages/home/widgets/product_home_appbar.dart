import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // 시간 포맷팅을 위해 추가

import '../../../../_core/components/theme.dart';
import '../../../../data/gvm/geo/location_gvm.dart';
import '../../../../data/gvm/notification_state.dart';
import '../../../../data/model/auth/my_position.dart';
import '../../../../data/model/notification_item.dart';

class ProductHomeAppbar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  ProductHomeAppbar({super.key});

  @override
  ConsumerState<ProductHomeAppbar> createState() => _ProductHomeAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProductHomeAppbarState extends ConsumerState<ProductHomeAppbar> {
  OverlayEntry? overlayEntry;

  OverlayEntry showNotificationsOverlay(Offset offset, BuildContext context) {
    List<NotificationItem> notifications = ref.watch(notificationProvider);
    final overlay = Overlay.of(context);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 반투명 배경 - 터치 감지용
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                removeOverlay(); // 다른 곳 클릭하면 overlay 사라짐
              },
              behavior: HitTestBehavior.opaque, // 투명한 영역도 클릭 감지
              child: Container(
                color: Colors.black.withOpacity(0.1), // 살짝 어두운 효과
              ),
            ),
          ),
          // 알림 팝업
          Positioned(
            top: kToolbarHeight + 10,
            right: 10,
            width: 300, // 너비 증가
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  alignment: Alignment.topRight,
                  child: child,
                );
              },
              child: Material(
                color: Colors.white,
                elevation: 8, // 그림자 강화
                borderRadius: BorderRadius.circular(15), // 테두리 라운드 증가
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 헤더 부분
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '알림',
                            style: GoogleFonts.notoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          if (notifications.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(notificationProvider.notifier)
                                    .markAllAsRead();
                              },
                              child: Text(
                                '모두 읽음',
                                style: GoogleFonts.notoSans(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // 알림 목록 또는 빈 상태
                    Container(
                      constraints: const BoxConstraints(
                        maxHeight: 350, // 최대 높이 설정
                      ),
                      child: notifications.isEmpty
                          ? _buildEmptyNotifications()
                          : _buildNotificationsList(notifications),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 알림이 없을 때 표시할 위젯
  Widget _buildEmptyNotifications() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '새로운 알림이 없습니다',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 소식이 있으면 여기에 표시됩니다',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  // 알림 목록 위젯
  Widget _buildNotificationsList(List<NotificationItem> notifications) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: notifications.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey[200],
      ),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Material(
          color: notification.isRead! ? Colors.white : Colors.blue[50],
          child: InkWell(
            onTap: () {
              ref.read(notificationProvider.notifier).markAsRead(notification);
              removeOverlay();
              // 여기에 알림 클릭 시 이동할 화면 로직 추가 가능
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 알림 아이콘
                  Container(
                    margin: const EdgeInsets.only(right: 12, top: 2),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: APlusTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getNotificationIcon(notification.type),
                      size: 16,
                      color: APlusTheme.primaryColor,
                    ),
                  ),
                  // 알림 내용
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.message ?? '알림',
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: notification.isRead!
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 추가 액션 (옵션)
                  if (!notification.isRead!)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: APlusTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 타임스탬프 포맷팅 함수
  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      // 오늘
      return '오늘 ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays == 1) {
      // 어제
      return '어제 ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays < 7) {
      // 일주일 이내
      return '${difference.inDays}일 전';
    } else {
      // 일주일 이상
      return DateFormat('MM월 dd일').format(timestamp);
    }
  }

  // 알림 타입에 따른 아이콘 반환
  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'PRICE_UPDATED':
        return Icons.update;
      case 'delivery':
        return Icons.local_shipping_outlined;
      case 'coupon':
        return Icons.card_giftcard;
      case 'message':
        return Icons.chat_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  void _showOverlay() {
    removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    overlayEntry = showNotificationsOverlay(offset, context);
    Overlay.of(context).insert(overlayEntry!);
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final MyPosition? myPosition = ref.watch(locationProvider);
    final List<NotificationItem> notifications =
        ref.watch(notificationProvider);
    final int unreadCount =
        notifications.where((n) => !n.isRead!).length; // 읽지 않은 알림 개수

    return AppBar(
      titleSpacing: 0,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              'APPLUS',
              textAlign: TextAlign.left,
              style: GoogleFonts.bangers(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: APlusTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
      actions: [
        // 위치 정보
        Visibility(
            visible: myPosition != null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 16, color: APlusTheme.primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      '${myPosition?.district ?? "위치 정보 없음"}',
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            )),

        // 🔔 알림 아이콘 (Overlay 표시)
        Stack(
          children: [
            IconButton(
              icon:
                  const Icon(Icons.notifications_outlined, color: Colors.black),
              splashRadius: 24, // 터치 영역 축소
              onPressed: () {
                if (overlayEntry == null) {
                  _showOverlay();
                } else {
                  removeOverlay();
                }
              },
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount', // 9개 초과시 9+로 표시
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
          ],
        ),

        // 🛒 장바구니 아이콘 (개선된 스타일)
        Stack(
          children: [
            IconButton(
              icon:
                  const Icon(Icons.shopping_cart_outlined, color: Colors.black),
              splashRadius: 24, // 터치 영역 축소
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: const Center(
                  child: Text(
                    '2', // 장바구니 아이템 개수 (임시)
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
          ],
        ),

        // 우측 여백
        const SizedBox(width: 8),
      ],
    );
  }
}
