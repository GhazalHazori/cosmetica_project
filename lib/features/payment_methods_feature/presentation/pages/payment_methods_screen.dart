import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection_container.dart';
import '../cubit/payment_methods_cubit.dart';
import '../widgets/dotted_border_painter.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  static const String routeName = '/payment-methods';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PaymentMethodsCubit>(),
      child: BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text(
                  'طرق الدفع',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: SizedBox.shrink(),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              body: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'البطاقات المحفوظة',
                                style: TextStyle(
                                  color: Color(0xff64748B),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildPaymentOption(
                                context: context,
                                id: 'visa',
                                title: 'Visa Platinum',
                                subtitle: '.... .... .... 4242',
                                icon: Icons.credit_card,
                                iconColor: const Color(0xFF00579F),
                              ),
                              const SizedBox(height: 12),
                              _buildPaymentOption(
                                context: context,
                                id: 'mastercard',
                                title: 'Mastercard World',
                                subtitle: '.... .... .... 5555',
                                icon: Icons.credit_card,
                                iconColor: const Color(0xFFEB001B),
                              ),
                              const SizedBox(height: 12),
                              _buildAddNewCardButton(),
                              const SizedBox(height: 28),
                              const Text(
                                'طرق دفع أخرى',
                                style: TextStyle(
                                   color: Color(0xff64748B),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildPaymentOption(
                                context: context,
                                id: 'apple_pay',
                                title: 'Apple Pay',
                                icon: Icons.apple,
                                iconColor: Colors.black,
                              ),
                              const SizedBox(height: 12),
                              _buildPaymentOption(
                                context: context,
                                id: 'cod',
                                title: 'الدفع عند الاستلام',
                                icon: Icons.payments_outlined,
                                iconColor: Color(0xFF0F172A),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'تأكيد طريقة الدفع',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentOption({
    required BuildContext context,
    required String id,
    required String title,
    String? subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    final selectedMethod = context.select<PaymentMethodsCubit, String?>(
      (cubit) => cubit.state.selectedMethod,
    );
    final isSelected = selectedMethod == id;

    return GestureDetector(
      onTap: () {
        context.read<PaymentMethodsCubit>().selectMethod(id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0F172A)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
           Container(
              width: 44,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(6),
                border:
                    Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff64748B),
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ],
              ),
            ),
        
                 Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFCBD5E1),
                  width: isSelected ? 6.5 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewCardButton() {
    return CustomPaint(
      painter: DottedBorderPainter(
        color: const Color(0xFFCBD5E1),
        strokeWidth: 1.2,
        gap: 4.0,
        radius: 16.0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 18, color: Color(0xFF0F172A)),
            SizedBox(width: 6),
            Text(
              'إضافة بطاقة جديدة',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
