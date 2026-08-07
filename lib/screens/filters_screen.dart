import 'package:flutter/material.dart';
import '../models/car_listing.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

const kAllCities = 'All cities';
const kAllBodyTypes = 'All types';
const kCityOptions = [kAllCities, 'Gilgit', 'Skardu', 'Hunza', 'Lahore', 'Karachi', 'Islamabad'];
const kBodyTypeOptions = [kAllBodyTypes, 'Sedan', 'Hatchback', 'SUV', 'Crossover'];
const kMinPriceLac = 0.0;
const kMaxPriceLac = 150.0;
const kMinYear = 2005;
const kMaxYear = 2026;
const kMinYearD = 2005.0;
const kMaxYearD = 2026.0;

/// Filter criteria applied to the listings feed on the Buy screen.
class CarFilters {
  final RangeValues priceLacRange;
  final RangeValues yearRange;
  final String city;
  final String bodyType;
  final bool verifiedOnly;
  final bool dealerOnly;

  const CarFilters({
    this.priceLacRange = const RangeValues(kMinPriceLac, kMaxPriceLac),
    this.yearRange = const RangeValues(kMinYearD, kMaxYearD),
    this.city = kAllCities,
    this.bodyType = kAllBodyTypes,
    this.verifiedOnly = false,
    this.dealerOnly = false,
  });

  bool get isDefault => this == const CarFilters();

  bool matches(CarListing car) {
    final priceLac = car.priceValue / 100000;
    if (priceLac < priceLacRange.start || priceLac > priceLacRange.end) return false;
    if (car.year < yearRange.start.round() || car.year > yearRange.end.round()) return false;
    if (city != kAllCities && car.city != city) return false;
    if (bodyType != kAllBodyTypes && car.bodyType != bodyType) return false;
    if (verifiedOnly && !car.verified) return false;
    if (dealerOnly && !car.isDealer) return false;
    return true;
  }

  /// Short human-readable labels for each non-default dimension, used to
  /// render the active-filter chips on the Buy screen.
  List<String> get activeLabels => [
        if (priceLacRange.start != kMinPriceLac || priceLacRange.end != kMaxPriceLac)
          'Rs ${priceLacRange.start.round()}–${priceLacRange.end.round()} lac',
        if (yearRange.start.round() != kMinYear || yearRange.end.round() != kMaxYear)
          '${yearRange.start.round()}–${yearRange.end.round()}',
        if (city != kAllCities) city,
        if (bodyType != kAllBodyTypes) bodyType,
        if (verifiedOnly) 'Verified only',
        if (dealerOnly) 'Dealer only',
      ];

  CarFilters copyWith({
    RangeValues? priceLacRange,
    RangeValues? yearRange,
    String? city,
    String? bodyType,
    bool? verifiedOnly,
    bool? dealerOnly,
  }) =>
      CarFilters(
        priceLacRange: priceLacRange ?? this.priceLacRange,
        yearRange: yearRange ?? this.yearRange,
        city: city ?? this.city,
        bodyType: bodyType ?? this.bodyType,
        verifiedOnly: verifiedOnly ?? this.verifiedOnly,
        dealerOnly: dealerOnly ?? this.dealerOnly,
      );

  @override
  bool operator ==(Object other) =>
      other is CarFilters &&
      other.priceLacRange == priceLacRange &&
      other.yearRange == yearRange &&
      other.city == city &&
      other.bodyType == bodyType &&
      other.verifiedOnly == verifiedOnly &&
      other.dealerOnly == dealerOnly;

  @override
  int get hashCode => Object.hash(priceLacRange, yearRange, city, bodyType, verifiedOnly, dealerOnly);
}

/// The filter criteria currently applied across the app — set from the Buy
/// screen's own filter button or from the dashboard's quick-filter bar, and
/// read by the Buy screen's listings feed either way.
final activeFilters = ValueNotifier<CarFilters>(const CarFilters());

class FiltersScreen extends StatefulWidget {
  final CarFilters initialFilters;
  const FiltersScreen({super.key, this.initialFilters = const CarFilters()});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late CarFilters filters = widget.initialFilters;

  int get _matchCount => listingsStore.value.where(filters.matches).length;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.paper,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
              child: Row(
                children: [
                  IconCircleButton(icon: Icons.close_rounded, size: 34, onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: 12),
                  Text('Filters', style: bodyStyle(size: 17, weight: 800, color: c.ink)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Text('PRICE RANGE (PKR)', style: eyebrowStyle(c.ash)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${filters.priceLacRange.start.round()} lac', style: monoStyle(size: 14, weight: 700, color: c.red)),
                        Text('${filters.priceLacRange.end.round()} lac', style: monoStyle(size: 14, weight: 700, color: c.red)),
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: c.red,
                      inactiveTrackColor: c.ashSoft,
                      thumbColor: c.red,
                      overlayColor: c.red.withValues(alpha: 0.15),
                      trackHeight: 4,
                    ),
                    child: RangeSlider(
                      values: filters.priceLacRange,
                      min: kMinPriceLac,
                      max: kMaxPriceLac,
                      onChanged: (v) => setState(() => filters = filters.copyWith(priceLacRange: v)),
                    ),
                  ),
                  const Divider(height: 28),
                  Text('CITY', style: eyebrowStyle(c.ash)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: kCityOptions
                        .map((ct) => AppChip(
                              label: ct,
                              active: ct == filters.city,
                              onTap: () => setState(() => filters = filters.copyWith(city: ct)),
                            ))
                        .toList(),
                  ),
                  const Divider(height: 28),
                  Text('BODY TYPE', style: eyebrowStyle(c.ash)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: kBodyTypeOptions
                        .map((bt) => AppChip(
                              label: bt,
                              active: bt == filters.bodyType,
                              onTap: () => setState(() => filters = filters.copyWith(bodyType: bt)),
                            ))
                        .toList(),
                  ),
                  const Divider(height: 28),
                  Text('YEAR', style: eyebrowStyle(c.ash)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${filters.yearRange.start.round()}', style: monoStyle(size: 14, weight: 700, color: c.red)),
                        Text('${filters.yearRange.end.round()}', style: monoStyle(size: 14, weight: 700, color: c.red)),
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: c.red,
                      inactiveTrackColor: c.ashSoft,
                      thumbColor: c.red,
                      overlayColor: c.red.withValues(alpha: 0.15),
                      trackHeight: 4,
                    ),
                    child: RangeSlider(
                      values: filters.yearRange,
                      min: kMinYear.toDouble(),
                      max: kMaxYear.toDouble(),
                      divisions: kMaxYear - kMinYear,
                      onChanged: (v) => setState(() => filters = filters.copyWith(yearRange: v)),
                    ),
                  ),
                  const Divider(height: 28),
                  _ToggleRow(
                    title: 'Inspection-verified only',
                    subtitle: 'Only show cars with a passed report',
                    value: filters.verifiedOnly,
                    onChanged: (v) => setState(() => filters = filters.copyWith(verifiedOnly: v)),
                  ),
                  _ToggleRow(
                    title: 'Dealer listings only',
                    subtitle: 'Hide private-seller listings',
                    value: filters.dealerOnly,
                    onChanged: (v) => setState(() => filters = filters.copyWith(dealerOnly: v)),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  GhostButton(label: 'Reset', onTap: () => setState(() => filters = const CarFilters())),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Show $_matchCount cars',
                      onTap: () => Navigator.of(context).pop(filters),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: bodyStyle(size: 14, weight: 800, color: c.ink)),
                const SizedBox(height: 2),
                Text(subtitle, style: bodyStyle(size: 11.5, color: c.ash)),
              ],
            ),
          ),
          AppSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
