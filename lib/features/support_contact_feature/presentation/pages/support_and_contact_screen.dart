import 'package:flutter/material.dart';

import 'live_chat_screen.dart';
import '../../../../core/theme/app_spacing.dart';

class SupportAndContactScreen extends StatefulWidget {
  const SupportAndContactScreen({super.key});

  static const String routeName = '/support-contact';

  @override
  State<SupportAndContactScreen> createState() =>
      _SupportAndContactScreenState();
}

class _SupportAndContactScreenState extends State<SupportAndContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
                bottom: PreferredSize(preferredSize: Size(1, 1), child:     const Divider(height: 1, color: Color(0xFFF1F5F9)),
),
          elevation: 0,
          actions:[ IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),],
        
          leading: SizedBox.shrink(),
          
          title: const Text(
            'COSMETICA',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'الدعم والتواصل',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ContactOptionCard(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'المحادثة المباشرة',
                subtitle: 'تحدث مع فريقنا الآن',
                onTap: () {
                  Navigator.pushNamed(context, LiveChatScreen.routeName);
                },
              ),
              const SizedBox(height: 12),
              ContactOptionCard(
                icon: Icons.mail_outline_rounded,
                title: 'البريد الإلكتروني',
                subtitle: 'سنرد عليك خلال ٢٤ ساعة',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              ContactOptionCard(
                icon: Icons.phone_outlined,
                title: 'اتصل بنا',
                subtitle: '٩٢٠٠١٢٣٤',
                onTap: () {},
              ),
              const SizedBox(height: 32),
              const Text(
                'الأسئلة الشائعة',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const FaqTile(
                question: 'ما هي سياسة الاستبدال والاسترجاع؟',
                answer:
                    'يمكنكم استبدال أو استرجاع المنتجات خلال ١٤ يوماً من تاريخ الاستلام بشرط أن تكون في حالتها الأصلية.',
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const FaqTile(
                question: 'كم يستغرق الشحن؟',
                answer: 'يستغرق الشحن داخل المملكة من ٢ إلى ٥ أيام عمل.',
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const FaqTile(
                question: 'هل المنتجات أصلية؟',
                answer:
                    'جميع منتجات كوزميتيكا أصلية ١٠٠٪ ومضمونة من الوكلاء المعتمدين.',
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialIconButton(icon: Icons.chat_rounded, onTap: () {}),
                  const SizedBox(width: 20),
                  SocialIconButton(
                    icon: Icons.camera_alt_outlined,
                    onTap: () {},
                  ),
                  const SizedBox(width: 20),
                  SocialIconButton(icon: Icons.close_rounded, onTap: () {}),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactOptionCard extends StatelessWidget {
  const ContactOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: const Color(0xFFEEF2F6)),
        ),
        child: Row(
          children: [
              Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black, size: 22),
            ),
          
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                     fontFamily: 'Almarai',
                      fontSize: 13,
                      color: Color(0xFF64748B),

                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqTile extends StatelessWidget {
  const FaqTile({
    super.key,
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 12),
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        title: Text(
          question,
          style: const TextStyle(
           fontFamily: 'Almarai',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        children: [
          Text(
            answer,
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 26, color: Colors.black),
      ),
    );
  }
}
