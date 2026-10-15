import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const String routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'الإشعارات',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Almarai',
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: const Color(0xFFEEEEEE), height: 1.0),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Almarai',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Text(
                      'اليوم',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                    const Text(
                      'تحديد الكل كمقروء',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildNotificationCard(
                  unread: true,
                  title: 'تم شحن طلبك بنجاح! 📦',
                  body:
                      'طلبك رقم #COS-89421 في طريقه إليك الآن مع شركة فليكس بوست، يمكنك تتبع الشحنة مباشرة.',
                  time: 'منذ 25 دقيقة',
                  actionText: 'تتبع الشحنة',
                  showArrow: true,
                ),
                const SizedBox(height: 12),
                _buildNotificationCard(
                  unread: true,
                  title: 'خصم 25% على قسم العطور الفاخرة ✨',
                  bodyWidget: const _CouponNotificationBody(),
                  time: 'منذ ساعتين',
                  actionText: 'تسوق الآن',
                  showArrow: true,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'أمس',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ),
                const SizedBox(height: 12),
                _buildNotificationCard(
                  unread: false,
                  title: 'منتج من قائمتك المفضلة توفر مجدداً!',
                  body:
                      'سيروم التجديد الفاخر للبشرة متاح الآن بكميات محدودة في المخزون.',
                  time: 'أمس في 04:30 م',
                  actionText: 'عرض المنتج',
                ),
                const SizedBox(height: 12),
                _buildNotificationCard(
                  unread: false,
                  title: 'تم استلام طلبك بنجاح',
                  body:
                      'تم تسليم الطلب #COS-87610. يسعدنا جداً مشاركتنا تقييمك للمنتجات!',
                  time: 'أمس في 11:15 ص',
                  actionText: 'تقييم الطلب',
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'الأسبوع الماضي',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ),
                const SizedBox(height: 12),
                _buildNotificationCard(
                  unread: false,
                  title: 'أهلاً بك في كوزماتيكا',
                  body:
                      'شكراً لانضمامك إلى عائلة COSMETICA. اكتشف الآن أحدث تشكيلات مستحضرات العناية والجمال.',
                  time: '3 مارس 2026',
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required bool unread,
    required String title,
    String? body,
    Widget? bodyWidget,
    required String time,
    String? actionText,
    bool showArrow = false,
    VoidCallback? onActionTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 0.8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // أيقونة الجرس السوداء
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 8,),

              // النصين (العنوان والوصف) فوق بعضهما على اليسار بجانب الأيقونة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (bodyWidget != null)
                      bodyWidget
                    else if (body != null)
                      Text(
                        body,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),
 // نقطة الحالة (غير مقروء) على أقصى اليمين إن وجدت
              if (unread)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 14, left: 8),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
           
            ],
          ),

          // السطر الفاصل الخفيف والجزء السفلي (الوقت والإجراء)
          if (actionText != null || time.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFF0F0F0), height: 1, thickness: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              
                
                 
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffA3A3A3),
                  ),
                ),
                  if (actionText != null)
                  GestureDetector(
                    onTap: onActionTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       
                        Text(
                          actionText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                         if (showArrow) ...[
                           const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Colors.black,
                          ),
                         
                        ],
                      ],
                    ),
                  )
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CouponNotificationBody extends StatelessWidget {
  const _CouponNotificationBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontFamily: 'Almarai',
          height: 1.4,
        ),
        children: [
          const TextSpan(
            text: 'عرض لفترة محدودة ينتهي اليوم! استخدم كود الخصم ',
          ),
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _CouponChip(),
          ),
          const TextSpan(text: ' عند إتمام الطلب.'),
        ],
      ),
    );
  }
}

class _CouponChip extends StatelessWidget {
  const _CouponChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey.shade100,
      ),
      child: const Text(
        'COS25',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}