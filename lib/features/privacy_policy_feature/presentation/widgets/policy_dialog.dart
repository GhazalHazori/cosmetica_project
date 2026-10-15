import 'package:flutter/material.dart';

import 'policy_content.dart';

const List<PolicySectionData> kPrivacyPolicySections = <PolicySectionData>[
  PolicySectionData(
    title: 'جمع البيانات',
    content:
        'نحن نجمع المعلومات التي تقدمها لنا مباشرة عند استخدامك لتطبيق COSMETICA، بما في ذلك الاسم، البريد الإلكتروني، وتفضيلات الجمال الخاصة بك. كما قد نقوم بجمع معلومات تقنية حول جهازك وكيفية تفاعلك مع التطبيق لضمان تقديم تجربة فاخرة ومخصصة تليق بك.',
  ),
  PolicySectionData(
    title: 'استخدام المعلومات',
    content:
        'تستخدم COSMETICA بياناتك لتحسين جودة منتجاتنا، ومعالجة طلباتك، وإرسال تحديثات حصرية حول مجموعاتنا الجديدة والعروض الخاصة التي تناسب ذوقك الرفيع. نحن نلتزم باستخدام بياناتك فقط في الإطارات المحجوزة لخدمة تجربة التسوق الخاصة بك.',
  ),
  PolicySectionData(
    title: 'حقوق المستخدم',
    content:
        'بصفتك مستخدماً مميزاً لـ COSMETICA، لك الحق في الوصول إلى بياناتك الشخصية وتصحيحها أو طلب حذفها في أي وقت. يمكنك أيضاً الاعتراض على معالجة بياناتك لأغراض تسويقية مباشرة من خلال إعدادات حسابك.',
    points: <String>[
      'حق الوصول إلى البيانات المحفوظة',
      'حق طلب تعديل البيانات غير الصحيحة',
      'حق حذف الحساب والبيانات المرتبطة',
    ],
  ),
  PolicySectionData(
    title: 'التعديلات على السياسة',
    content:
        'نحتفظ بالحق في مراجعة وتحديث سياسة الخصوصية هذه لتعكس التغييرات في ممارساتنا أو المتطلبات القانونية. سيتم إخطاركم بأي تغييرات جوهرية من خلال التطبيق أو البريد الإلكتروني المسجل لدينا لضمان شفافية تامة.',
  ),
];

const List<PolicySectionData> kTermsOfUseSections = <PolicySectionData>[
  PolicySectionData(
    title: 'شروط الاستخدام',
    content:
        'باستخدامك تطبيق COSMETICA فإنك توافق على الالتزام بهذه الشروط والأحكام. يتعين عليك استخدام التطبيق للأغراض المشروعة فقط وعدم محاولة الوصول غير المصرح به إلى أي جزء من النظام أو البيانات.',
  ),
  PolicySectionData(
    title: 'الحساب والأهلية',
    content:
        'أنت مسؤول عن سرية بيانات حسابك وكلمة المرور الخاصة بك، وعن كامل النشاط الذي يتم عبر حسابك. يجب أن تكون البيانات المدخلة صحيحة ومحدثة، ولنا الحق في تعليق أو إلغاء الحساب في حال مخالفة هذه الشروط.',
  ),
  PolicySectionData(
    title: 'الطلبات والأسعار',
    content:
        'جميع الأسعار المعروضة على التطبيق بالريال السعودي وتشمل الرسوم المطبّقة. نحتفظ بحق تعديل الأسعار أو إلغاء أي طلب في حال نفاد الكمية أو وجود خطأ واضح في السعر، وسيتم التواصل معك لتمام الإجراء.',
  ),
  PolicySectionData(
    title: 'الشحن والإرجاع',
    content:
        'يتم تنفيذ الطلبات وفق مدة التوصيل المذكورة عند تأكيد الطلب. يحق لك طلب الاستبدال أو الإرجاع خلال المدة المحددة وفق حالة المنتج، مع مراعاة أن مستحضرات العناية والتجميل المفتوحة لا تقبل الإرجاع إلا وفق الحالات الاستثنائية المنصوص عليها.',
  ),
  PolicySectionData(
    title: 'الملكية الفكرية',
    content:
        'جميع العلامات التجارية والشعارات ونصوص الواجهات داخل التطبيق مملوكة لـ COSMETICA أو مرخصة لها، ولا يجوز استخدامها أو إعادة نشرها دون إذن كتابي مسبق.',
  ),
];

void showPolicyDialog(BuildContext context, {required bool isTermsOfUse}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                     Radius.circular(8),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF1F5F9)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          isTermsOfUse
                              ? 'شروط الاستخدام'
                              : 'سياسة الخصوصية والاستخدام',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: PolicyContent(
                      sections: isTermsOfUse
                          ? kTermsOfUseSections
                          : kPrivacyPolicySections,
                      contactEmail: isTermsOfUse
                          ? 'legal@cosmetica.luxury'
                          : 'privacy@cosmetica.luxury',
                    ),
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
