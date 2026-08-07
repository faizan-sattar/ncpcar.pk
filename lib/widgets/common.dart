import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SealBadge extends StatelessWidget {
  final String label;
  const SealBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
      decoration: BoxDecoration(color: c.verifiedBg, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, size: 15, color: c.verified),
          const SizedBox(width: 6),
          Text(label, style: bodyStyle(size: 12.5, weight: 800, color: c.verified)),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool block;
  const PrimaryButton({super.key, required this.label, this.onTap, this.icon, this.block = true});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final child = ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: c.red,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
          Text(label, style: bodyStyle(size: 14.5, weight: 800, color: Colors.white)),
        ],
      ),
    );
    return block ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  const GhostButton({super.key, required this.label, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: c.surface2,
        foregroundColor: c.ink,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
          Text(label, style: bodyStyle(size: 14.5, weight: 800, color: c.ink)),
        ],
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const OutlineButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: c.red,
        side: BorderSide(color: c.red, width: 1.4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
      ),
      child: Text(label, style: bodyStyle(size: 13, weight: 800, color: c.red)),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(title, style: bodyStyle(size: 16, weight: 800, color: c.ink), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(actionLabel!, style: bodyStyle(size: 13, weight: 700, color: c.red)),
            ),
        ],
      ),
    );
  }
}

class AppChip extends StatelessWidget {
  final String label;
  final bool active;
  final IconData? icon;
  final VoidCallback? onTap;
  const AppChip({super.key, required this.label, this.active = false, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: active ? c.redTint : c.surface2,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: active ? c.red : Colors.transparent, width: 1.4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: active ? c.redStrong : c.inkSoft),
              const SizedBox(width: 6),
            ],
            Text(label, style: bodyStyle(size: 12.5, weight: 700, color: active ? c.redStrong : c.inkSoft)),
          ],
        ),
      ),
    );
  }
}

class IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? iconColor;
  final double size;
  const IconCircleButton({super.key, required this.icon, this.onTap, this.borderColor, this.iconColor, this.size = 38});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: c.surface,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor ?? c.ashSoft, width: 1.4),
        ),
        child: Icon(icon, size: size * 0.46, color: iconColor ?? c.ink),
      ),
    );
  }
}

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const AppSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 42,
        height: 24,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? c.red : c.ashSoft,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class SpecItem extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;
  const SpecItem({super.key, required this.label, required this.value, this.mono = false});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
      decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: eyebrowStyle(c.ash).copyWith(fontSize: 9.5)),
          const SizedBox(height: 3),
          Text(value, style: mono ? monoStyle(size: 13.5, weight: 700, color: c.ink) : bodyStyle(size: 13.5, weight: 800, color: c.ink)),
        ],
      ),
    );
  }
}

class SellerBadge extends StatelessWidget {
  final bool isDealer;
  const SellerBadge({super.key, required this.isDealer});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDealer ? c.amberBg : c.surface2,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        isDealer ? 'Dealer' : 'Owner',
        style: bodyStyle(size: 10.5, weight: 800, color: isDealer ? c.amber : c.inkSoft),
      ),
    );
  }
}
