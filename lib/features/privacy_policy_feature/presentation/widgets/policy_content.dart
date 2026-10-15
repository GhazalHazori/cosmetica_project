import 'package:flutter/material.dart';

class PolicySectionData {
  final String title;
  final String content;
  final List<String> points;

  const PolicySectionData({
    required this.title,
    required this.content,
    this.points = const <String>[],
  });
}

class PolicyContent extends StatelessWidget {
  const PolicyContent({
    super.key,
    required this.sections,
    this.lastUpdated = 'آخر تحديث: يونيو ٢٠٢٤',
    this.introText =
        'إذا كان لديك أي استفسارات حول سياساتنا، يرجى التواصل مع\nفريق النخبة عبر:',
    this.contactEmail = 'privacy@cosmetica.luxury',
  });

  final List<PolicySectionData> sections;
  final String lastUpdated;
  final String introText;
  final String contactEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: const Text(
                  'COSMETICA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                lastUpdated,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        for (final PolicySectionData section in sections)
          _PolicySection(
            title: section.title,
            content: section.content,
            extraWidget: section.points.isEmpty
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        for (int i = 0; i < section.points.length; i++) ...<Widget>[
                          if (i > 0) const SizedBox(height: 8),
                          _RightAlignedPoint(text: section.points[i]),
                        ],
                      ],
                    ),
                  ),
          ),
        const SizedBox(height: 40),
        Center(
          child: Column(
            children: [
              Text(
                introText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF94A3B8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              SelectableText(
                contactEmail,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({
    required this.title,
    required this.content,
    this.extraWidget,
  });

  final String title;
  final String content;
  final Widget? extraWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.6,
            ),
          ),
          if (extraWidget != null) extraWidget!,
        ],
      ),
    );
  }
}

class _RightAlignedPoint extends StatelessWidget {
  const _RightAlignedPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
      ),
    );
  }
}
