import 'package:flutter/material.dart';
import '../auth/auth_controller.dart';
import '../models/car_listing.dart';
import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import '../widgets/car_plate.dart';
import '../widgets/common.dart';
import '../widgets/listing_card.dart';
import 'car_details_screen.dart';
import 'filters_screen.dart';
import 'login_screen.dart';

const _dealers = [
  ('Al-Fateh Motors', '4.8 ★ · 212 cars'),
  ('Shahzad Autos', '4.6 ★ · 98 cars'),
  ('City Car Hub', '4.9 ★ · 156 cars'),
];

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onGoToTab;
  const HomeScreen({super.key, required this.onGoToTab});

  void _openDetails(BuildContext context, CarListing car) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CarDetailsScreen(car: car)));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final header = Padding(
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
    );

    final content = ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      children: [
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
          _LatestListingHero(onOpenDetails: _openDetails),
          const _TrustStrip(),
          if (!context.isWide) _QuickFilterBar(onGoToTab: onGoToTab),
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
              final featuredCount = context.isWide ? 6 : 3;
              final featured = listings.take(featuredCount).toList();
              final latest = listings.skip(featuredCount).toList();
              return Column(
                children: [
                  SectionHeader(title: 'Featured verified cars', actionLabel: 'See all', onAction: () => onGoToTab(1)),
                  context.isWide
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 280, mainAxisExtent: 250, crossAxisSpacing: 14, mainAxisSpacing: 14),
                            itemCount: featured.length,
                            itemBuilder: (_, i) => FeaturedCard(car: featured[i], onTap: () => _openDetails(context, featured[i])),
                          ),
                        )
                      : SizedBox(
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 560, mainAxisExtent: 140),
                    itemCount: latest.length,
                    itemBuilder: (_, i) => ListingRowCard(car: latest[i], onTap: () => _openDetails(context, latest[i])),
                  ),
                ],
              );
            },
          ),
          SectionHeader(title: 'Trusted dealers near you'),
          SizedBox(
            height: 122,
            child: context.isWide
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        for (var i = 0; i < _dealers.length; i++) ...[
                          if (i > 0) const SizedBox(width: 12),
                          Expanded(child: _DealerCard(name: _dealers[i].$1, meta: _dealers[i].$2, width: null)),
                        ],
                      ],
                    ),
                  )
                : ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      for (var i = 0; i < _dealers.length; i++) ...[
                        _DealerCard(name: _dealers[i].$1, meta: _dealers[i].$2),
                        if (i < _dealers.length - 1) const SizedBox(width: 12),
                      ],
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
    );

    return SafeArea(
      child: Column(
        children: [
          header,
          Expanded(
            child: context.isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: content),
                      _HomeFilterSidebar(onGoToTab: onGoToTab),
                    ],
                  )
                : content,
          ),
        ],
      ),
    );
  }
}

class _HomeFilterSidebar extends StatefulWidget {
  final ValueChanged<int> onGoToTab;
  const _HomeFilterSidebar({required this.onGoToTab});

  @override
  State<_HomeFilterSidebar> createState() => _HomeFilterSidebarState();
}

class _HomeFilterSidebarState extends State<_HomeFilterSidebar> {
  late CarFilters filters = activeFilters.value;

  int get _matchCount => listingsStore.value.where(filters.matches).length;

  void _set(CarFilters next) {
    setState(() => filters = next);
    activeFilters.value = next;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 300,
      margin: const EdgeInsets.fromLTRB(0, 0, 20, 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: c.ashSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter cars', style: bodyStyle(size: 15, weight: 800, color: c.ink)),
              Icon(Icons.tune_rounded, size: 18, color: c.red),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PRICE RANGE (LAC)', style: eyebrowStyle(c.ash)),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${filters.priceLacRange.start.round()}', style: monoStyle(size: 12.5, weight: 700, color: c.red)),
                        Text('${filters.priceLacRange.end.round()}', style: monoStyle(size: 12.5, weight: 700, color: c.red)),
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: c.red,
                      inactiveTrackColor: c.ashSoft,
                      thumbColor: c.red,
                      overlayColor: c.red.withValues(alpha: 0.15),
                      trackHeight: 3,
                    ),
                    child: RangeSlider(
                      values: filters.priceLacRange,
                      min: kMinPriceLac,
                      max: kMaxPriceLac,
                      onChanged: (v) => _set(filters.copyWith(priceLacRange: v)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('CITY', style: eyebrowStyle(c.ash)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kCityOptions
                        .map((ct) => AppChip(label: ct, active: ct == filters.city, onTap: () => _set(filters.copyWith(city: ct))))
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  Text('BODY TYPE', style: eyebrowStyle(c.ash)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kBodyTypeOptions
                        .map((bt) => AppChip(label: bt, active: bt == filters.bodyType, onTap: () => _set(filters.copyWith(bodyType: bt))))
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  Text('YEAR', style: eyebrowStyle(c.ash)),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${filters.yearRange.start.round()}', style: monoStyle(size: 12.5, weight: 700, color: c.red)),
                        Text('${filters.yearRange.end.round()}', style: monoStyle(size: 12.5, weight: 700, color: c.red)),
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: c.red,
                      inactiveTrackColor: c.ashSoft,
                      thumbColor: c.red,
                      overlayColor: c.red.withValues(alpha: 0.15),
                      trackHeight: 3,
                    ),
                    child: RangeSlider(
                      values: filters.yearRange,
                      min: kMinYearD,
                      max: kMaxYearD,
                      divisions: kMaxYear - kMinYear,
                      onChanged: (v) => _set(filters.copyWith(yearRange: v)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('MILEAGE (KM)', style: eyebrowStyle(c.ash)),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${filters.mileageKmRange.start.round()}', style: monoStyle(size: 12.5, weight: 700, color: c.red)),
                        Text('${filters.mileageKmRange.end.round()}', style: monoStyle(size: 12.5, weight: 700, color: c.red)),
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: c.red,
                      inactiveTrackColor: c.ashSoft,
                      thumbColor: c.red,
                      overlayColor: c.red.withValues(alpha: 0.15),
                      trackHeight: 3,
                    ),
                    child: RangeSlider(
                      values: filters.mileageKmRange,
                      min: kMinMileage,
                      max: kMaxMileage,
                      onChanged: (v) => _set(filters.copyWith(mileageKmRange: v)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('TRANSMISSION', style: eyebrowStyle(c.ash)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kTransmissionOptions
                        .map((t) => AppChip(label: t, active: t == filters.transmission, onTap: () => _set(filters.copyWith(transmission: t))))
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  Text('FUEL TYPE', style: eyebrowStyle(c.ash)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kFuelTypeOptions
                        .map((f) => AppChip(label: f, active: f == filters.fuelType, onTap: () => _set(filters.copyWith(fuelType: f))))
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  Text('OWNERS', style: eyebrowStyle(c.ash)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kOwnerOptions
                        .map((o) => AppChip(label: o, active: o == filters.owner, onTap: () => _set(filters.copyWith(owner: o))))
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  _ToggleRow(
                    label: 'Verified only',
                    value: filters.verifiedOnly,
                    onChanged: (v) => _set(filters.copyWith(verifiedOnly: v)),
                  ),
                  _ToggleRow(
                    label: 'Dealer only',
                    value: filters.dealerOnly,
                    onChanged: (v) => _set(filters.copyWith(dealerOnly: v)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              GhostButton(label: 'Reset', onTap: () => _set(const CarFilters())),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryButton(
                  label: 'Show $_matchCount cars',
                  onTap: () {
                    activeFilters.value = filters;
                    widget.onGoToTab(1);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: bodyStyle(size: 12.5, weight: 700, color: c.ink))),
          AppSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _LatestListingHero extends StatelessWidget {
  final void Function(BuildContext, CarListing) onOpenDetails;
  const _LatestListingHero({required this.onOpenDetails});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CarListing>>(
      valueListenable: listingsStore,
      builder: (context, listings, _) {
        if (listings.isEmpty) return const SizedBox.shrink();
        final car = listings.first;
        final plate = plateFor(car.plateIndex);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: GestureDetector(
            onTap: () => onOpenDetails(context, car),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: SizedBox(
                height: 260,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CarPlate(plateA: plate.a, plateB: plate.b, glyphColor: plate.glyph, radius: BorderRadius.zero),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                          stops: const [0.35, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 22,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bolt_rounded, size: 13, color: Color(0xFFDC2626)),
                                const SizedBox(width: 3),
                                Text('LATEST LISTING', style: eyebrowStyle(const Color(0xFFDC2626))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(car.title, style: displayStyle(size: 28, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(car.specLineWithCity, style: monoStyle(size: 12.5, color: Colors.white70)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(car.price, style: displayStyle(size: 22, color: Colors.white)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill)),
                                child: Text('View details', style: bodyStyle(size: 12.5, weight: 800, color: Colors.black)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  static const _items = [
    (Icons.verified_user_outlined, 'Verified listings', 'Every car inspection-checked before it goes live.'),
    (Icons.storefront_outlined, 'Trusted dealers', 'Buy from rated dealers or private sellers — your choice.'),
    (Icons.support_agent_outlined, 'Direct support', 'Chat or call sellers directly, any time.'),
  ];

  @override
  Widget build(BuildContext context) {
    final items = _items
        .map((item) => _TrustItem(icon: item.$1, title: item.$2, subtitle: item.$3))
        .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 4),
      child: context.isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(width: 20),
                  Expanded(child: items[i]),
                ],
              ],
            )
          : Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  items[i],
                ],
              ],
            ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _TrustItem({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: c.redTint, shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: c.red),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: bodyStyle(size: 13.5, weight: 800, color: c.ink)),
              const SizedBox(height: 2),
              Text(subtitle, style: bodyStyle(size: 11.5, color: c.ash, height: 1.35)),
            ],
          ),
        ),
      ],
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
    final result = await openFiltersPanel(context, activeFilters.value);
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
  final double? width;
  const _DealerCard({required this.name, required this.meta, this.width = 132});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: width,
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
