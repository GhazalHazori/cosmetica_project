import 'package:flutter/material.dart';

import '../widgets/policy_content.dart';
import '../widgets/policy_dialog.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const String routeName = '/privacy-policy';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
              onPressed: () => Navigator.maybePop(context),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size(1, 1),
            child: const Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          leading: const SizedBox.shrink(),
          title: const Text(
            'سياسة الخصوصية والاستخدام',
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
          child: const PolicyContent(sections: kPrivacyPolicySections),
        ),
      ),
    );
  }
}
