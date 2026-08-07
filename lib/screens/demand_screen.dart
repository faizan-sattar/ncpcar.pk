import 'package:flutter/material.dart';
import '../auth/require_signed_in.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class DemandScreen extends StatefulWidget {
  const DemandScreen({super.key});

  @override
  State<DemandScreen> createState() => _DemandScreenState();
}

class _DemandScreenState extends State<DemandScreen> {
  String condition = 'Inspection verified only';
  static const conditions = ['Inspection verified only', 'Any condition', 'Under 30,000 km', 'Automatic only'];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Text('Request a car', style: bodyStyle(size: 18, weight: 800, color: c.ink)),
          const SizedBox(height: 8),
          Text(
            "Can't find the exact car you want? Tell us your requirements and we'll alert matching verified sellers.",
            style: bodyStyle(size: 13, color: c.inkSoft, height: 1.4),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _Field(label: 'Preferred make', hint: 'e.g. Honda')),
              const SizedBox(width: 10),
              Expanded(child: _Field(label: 'Model', hint: 'e.g. Civic')),
            ],
          ),
          _Field(label: 'Budget range (PKR)', hint: '40 lac – 60 lac', mono: true),
          _Field(label: 'City', value: 'Gilgit'),
          const SizedBox(height: 6),
          Text('CONDITION PREFERENCE', style: eyebrowStyle(c.ash)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.6,
            children: conditions.map((cond) {
              final active = cond == condition;
              return GestureDetector(
                onTap: () => setState(() => condition = cond),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? c.redTint : c.surface2,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: active ? c.red : Colors.transparent, width: 1.4),
                  ),
                  child: Text(cond, textAlign: TextAlign.center, style: bodyStyle(size: 12, weight: 700, color: active ? c.redStrong : c.inkSoft)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          _Field(label: 'Your mobile number', value: '+92 300 1234567', mono: true),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: c.ashSoft),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, size: 22, color: c.verified),
                const SizedBox(width: 10),
                Expanded(
                  child: Text("We'll notify you the moment a verified match is listed — usually within days.",
                      style: bodyStyle(size: 12, color: c.inkSoft)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Submit request',
            onTap: () async {
              if (!await ensureSignedIn(context)) return;
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Request submitted — we'll be in touch soon", style: bodyStyle(size: 13, weight: 700, color: c.paper)),
                  backgroundColor: c.ink,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String? value;
  final String? hint;
  final bool mono;
  const _Field({required this.label, this.value, this.hint, this.mono = false});

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
            controller: value != null ? TextEditingController(text: value) : null,
            style: mono ? monoStyle(size: 14, color: c.ink) : bodyStyle(size: 14, color: c.ink),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: bodyStyle(size: 14, color: c.ash),
              filled: true,
              fillColor: c.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.sm), borderSide: BorderSide(color: c.ashSoft, width: 1.4)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.sm), borderSide: BorderSide(color: c.ashSoft, width: 1.4)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.sm), borderSide: BorderSide(color: c.red, width: 1.6)),
            ),
          ),
        ],
      ),
    );
  }
}
