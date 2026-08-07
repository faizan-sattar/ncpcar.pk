import 'package:flutter/material.dart';
import '../auth/auth_controller.dart';
import '../models/car_listing.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/listing_card.dart';
import 'car_details_screen.dart';
import 'filters_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onGoToTab;
  const HomeScreen({super.key, required this.onGoToTab});

  void _openDetails(BuildContext context, CarListing car) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CarDetailsScreen(car: car)));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset('assets/images/logo_circle.png', fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LOCATION', style: eyebrowStyle(c.ash)),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Gilgit, Gilgit-Baltistan',
                              style: bodyStyle(size: 15, weight: 800, color: c.ink),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.expand_more_rounded, size: 18, color: c.ink),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ValueListenableBuilder<String?>(
                  valueListenable: authController,
                  builder: (context, email, _) {
                    if (email != null) {
                      return Row(
                        children: [
                          IconCircleButton(icon: Icons.notifications_none_rounded, onTap: () {}),
                          const SizedBox(width: 10),
                          IconCircleButton(icon: Icons.person_outline_rounded, onTap: () => onGoToTab(4)),
                        ],
                      );
                    }
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _HeaderAuthButton(
                          label: 'Sign in',
                          filled: false,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) => const LoginScreen(initialMode: AuthMode.signIn))),
                        ),
                        const SizedBox(width: 8),
                        _HeaderAuthButton(
                          label: 'Sign up',
                          filled: true,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) => const LoginScreen(initialMode: AuthMode.signUp))),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: GestureDetector(
              onTap: () => onGoToTab(1),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: c.ashSoft, width: 1.4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, size: 19, color: c.ash),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search Corolla, Civic, Alto…',
                        style: bodyStyle(size: 13.5, color: c.ash),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Expanded(child: _QuickAction(icon: Icons.search_rounded, label: 'Buy', onTap: () => onGoToTab(1))),
                Expanded(child: _QuickAction(icon: Icons.sell_outlined, label: 'Sell', onTap: () => onGoToTab(2))),
                Expanded(child: _QuickAction(icon: Icons.my_location_rounded, label: 'Demand', onTap: () => onGoToTab(3))),
              ],
            ),
          ),
          _QuickFilterBar(onGoToTab: onGoToTab),
          SectionHeader(title: 'Browse by body type'),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                AppChip(label: 'All', active: true, onTap: () => onGoToTab(1)),
                const SizedBox(width: 9),
                AppChip(label: 'Sedan', onTap: () => onGoToTab(1)),
                const SizedBox(width: 9),
                AppChip(label: 'Hatchback', onTap: () => onGoToTab(1)),
                const SizedBox(width: 9),
                AppChip(label: 'SUV', onTap: () => onGoToTab(1)),
                const SizedBox(width: 9),
                AppChip(label: 'Crossover', onTap: () => onGoToTab(1)),
              ],
            ),
          ),
          ValueListenableBuilder<List<CarListing>>(
            valueListenable: listingsStore,
            builder: (context, listings, _) {
              final featured = listings.take(3).toList();
              final latest = listings.skip(3).toList();
              return Column(
                children: [
                  SectionHeader(title: 'Featured verified cars', actionLabel: 'See all', onAction: () => onGoToTab(1)),
                  SizedBox(
                    height: 250,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: featured.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 14),
                      itemBuilder: (_, i) => FeaturedCard(car: featured[i], onTap: () => _openDetails(context, featured[i])),
                    ),
                  ),
                  SectionHeader(title: 'Latest listings', actionLabel: 'See all', onAction: () => onGoToTab(1)),
                  ...latest.map((car) => ListingRowCard(car: car, onTap: () => _openDetails(context, car))),
                ],
              );
            },
          ),
          SectionHeader(title: 'Trusted dealers near you'),
          SizedBox(
            height: 122,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                _DealerCard(name: 'Al-Fateh Motors', meta: '4.8 ★ · 212 cars'),
                SizedBox(width: 12),
                _DealerCard(name: 'Shahzad Autos', meta: '4.6 ★ · 98 cars'),
                SizedBox(width: 12),
                _DealerCard(name: 'City Car Hub', meta: '4.9 ★ · 156 cars'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 18, 30, 4),
            child: Text(
              'ValleyWheels — every listing inspected. No cut, no compromise.',
              textAlign: TextAlign.center,
              style: bodyStyle(size: 11, color: c.ash),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: c.redTint, shape: BoxShape.circle),
            child: Icon(icon, color: c.red, size: 23),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: bodyStyle(size: 10.5, weight: 700, color: c.inkSoft),
          ),
        ],
      ),
    );
  }
}

class _QuickFilterBar extends StatelessWidget {
  final ValueChanged<int> onGoToTab;
  const _QuickFilterBar({required this.onGoToTab});

  Future<void> _open(BuildContext context) async {
    final result = await Navigator.of(context).push<CarFilters>(
      MaterialPageRoute(builder: (_) => FiltersScreen(initialFilters: activeFilters.value)),
    );
    if (result != null) {
      activeFilters.value = result;
      onGoToTab(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ValueListenableBuilder<CarFilters>(
      valueListenable: activeFilters,
      builder: (context, filters, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
        child: GestureDetector(
          onTap: () => _open(context),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.red, c.redStrong],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [BoxShadow(color: c.red.withValues(alpha: 0.28), blurRadius: 18, offset: const Offset(0, 8))],
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle),
                  child: const Icon(Icons.tune_rounded, color: Colors.white, size: 19),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Find your car', style: bodyStyle(size: 14.5, weight: 800, color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(
                        filters.isDefault ? 'Set your price, city, year & more' : filters.activeLabels.join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bodyStyle(size: 11.5, color: Colors.white.withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill)),
                  child: Text(
                    filters.isDefault ? 'Filter' : 'Edit',
                    style: bodyStyle(size: 12.5, weight: 800, color: c.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DealerCard extends StatelessWidget {
  final String name;
  final String meta;
  const _DealerCard({required this.name, required this.meta});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 132,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: c.ashSoft),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: c.surface2, shape: BoxShape.circle),
            child: Icon(Icons.storefront_outlined, size: 22, color: c.ash),
          ),
          const SizedBox(height: 8),
          Text(name, style: bodyStyle(size: 12, weight: 800, color: c.ink), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(meta, style: monoStyle(size: 10.5, color: c.ash)),
        ],
      ),
    );
  }
}

class _HeaderAuthButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;
  const _HeaderAuthButton({required this.label, required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: filled ? c.red : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: filled ? null : Border.all(color: c.ashSoft, width: 1.4),
        ),
        child: Text(label, style: bodyStyle(size: 12, weight: 800, color: filled ? Colors.white : c.ink)),
      ),
    );
  }
}
