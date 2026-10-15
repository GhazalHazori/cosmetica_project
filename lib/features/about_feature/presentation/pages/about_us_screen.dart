import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const String routeName = '/about-us';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
            bottom: PreferredSize(preferredSize: Size(1, 1), child:     const Divider(height: 1, color: Color(0xFFF1F5F9)),
),
      
          actions:[ IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),],
        
          leading: SizedBox.shrink(),
          title: const Text(
            'من نحن',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/cosmatica_logo.png",width: 100,height: 100,
                )
              ),
              const SizedBox(height: 20),
              const Text(
                'كوزميتيكا',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(width: 40, height: 1.5, color: Colors.black),
              const SizedBox(height: 24),
              const Text(
                'تأسست كوزميتيكا لتكون الوجهة الأولى لكل من يبحث عن التميز والرقي في عالم الجمال. نحن لا نبيع مجرد مستحضرات، بل نقدم تجربة حسية فريدة تجمع بين أحدث الابتكارات العلمية وأرقى معايير الفخامة العالمية.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'نؤمن بأن الجمال هو انعكاس للثقة بالنفس، ولذلك نسعى جاهدين لتمكين عملائنا من خلال منتجات مختارة بعناية فائقة لتناسب تطلعاتهم الرفيعة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 32),
              const _NumberedSection(
                number: '01',
                title: 'رؤيتنا',
                content:
                    'أن نصبح العلامة التجارية الرائدة عالمياً في تعريف مفهوم "الجمال الواعي والمترف"، حيث تلتقي الاستدامة مع أقصى درجات الفخامة.',
              ),
              const _SectionDivider(),
              const _NumberedSection(
                number: '02',
                title: 'مهمتنا',
                content:
                    'توفير حلول تجميلية استثنائية تعزز الجمال الطبيعي، مع الحفاظ على أعلى معايير الجودة والنزاهة في كل منتج نحمله اسم كوزميتيكا.',
              ),
              const _SectionDivider(),
              const _NumberedSection(
                number: '03',
                title: 'قيمنا',
                bulletPoints: [
                  'الابتكار المستمر',
                  'الجودة المطلقة',
                  'الشفافية والصدق',
                  'التميز في الخدمة',
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberedSection extends StatelessWidget {
  const _NumberedSection({
    required this.number,
    required this.title,
    this.content,
    this.bulletPoints,
  });

  final String number;
  final String title;
  final String? content;
  final List<String>? bulletPoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              number,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (content != null)
          Text(
            content!,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.6,
            ),
          ),
        if (bulletPoints != null)
          Column(
            children: bulletPoints!
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Divider(height: 1, color: Color(0xFFF1F5F9)),
    );
  }
}
