import 'package:flutter/material.dart';
import '../auth/auth_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class BecomeDealerScreen extends StatefulWidget {
  const BecomeDealerScreen({super.key});

  @override
  State<BecomeDealerScreen> createState() => _BecomeDealerScreenState();
}

class _BecomeDealerScreenState extends State<BecomeDealerScreen> {
  final businessController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  String? businessError;
  String? cityError;
  String? phoneError;

  @override
  void dispose() {
    businessController.dispose();
    cityController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    final business = businessController.text.trim();
    final city = cityController.text.trim();
    final phone = phoneController.text.trim();
    setState(() {
      businessError = business.isEmpty ? 'Enter your business name' : null;
      cityError = city.isEmpty ? 'Enter your city' : null;
      phoneError = phone.length < 7 ? 'Enter a valid phone number' : null;
    });
    if (businessError != null || cityError != null || phoneError != null) return;

    authController.registerDealer(businessName: business, city: city, phone: phone);

    final c = context.colors;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You\'re now a ValleyWheels dealer!', style: bodyStyle(size: 13, weight: 700, color: c.paper)),
        backgroundColor: c.ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: IconCircleButton(icon: Icons.close_rounded, size: 36, onTap: () => Navigator.of(context).pop(false)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(color: c.red, shape: BoxShape.circle),
                        child: const Icon(Icons.storefront_outlined, color: Colors.white, size: 26),
                      ),
                      const SizedBox(height: 18),
                      Text('Become a dealer', style: bodyStyle(size: 24, weight: 800, color: c.ink)),
                      const SizedBox(height: 6),
                      Text(
                        'Tell us about your business to get a storefront, bulk listings & priority placement.',
                        style: bodyStyle(size: 13.5, color: c.inkSoft),
                      ),
                      const SizedBox(height: 26),
                      _Field(
                        label: 'Business name',
                        hint: 'e.g. Al-Fateh Motors',
                        controller: businessController,
                        errorText: businessError,
                      ),
                      _Field(
                        label: 'City',
                        hint: 'e.g. Gilgit',
                        controller: cityController,
                        errorText: cityError,
                      ),
                      _Field(
                        label: 'Phone number',
                        hint: '03XX-XXXXXXX',
                        controller: phoneController,
                        errorText: phoneError,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Submit application', onTap: _submit),
              const SizedBox(height: 14),
              Text(
                'Your storefront will be reviewed before it goes live.',
                textAlign: TextAlign.center,
                style: bodyStyle(size: 11, color: c.ash),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? errorText;
  final TextInputType? keyboardType;
  const _Field({required this.label, required this.controller, this.hint, this.errorText, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: bodyStyle(size: 12, weight: 700, color: c.inkSoft)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: bodyStyle(size: 15, color: c.ink),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: bodyStyle(size: 15, color: c.ash),
              errorText: errorText,
              errorMaxLines: 2,
              filled: true,
              fillColor: c.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: c.ashSoft, width: 1.4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: c.ashSoft, width: 1.4),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: c.red, width: 1.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
