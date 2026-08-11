import 'package:flutter/material.dart';
import '../models/car_listing.dart';
import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import '../widgets/common.dart';

const kAllCities = 'All cities';
const kAllBodyTypes = 'All types';
const kAllTransmissions = 'All transmissions';
const kAllFuelTypes = 'All fuel types';
const kAllOwners = 'Any owners';
const kCityOptions = [kAllCities, 'Gilgit', 'Skardu', 'Hunza', 'Lahore', 'Karachi', 'Islamabad'];
const kBodyTypeOptions = [kAllBodyTypes, 'Sedan', 'Hatchback', 'SUV', 'Crossover'];
const kTransmissionOptions = [kAllTransmissions, 'Automatic', 'Manual'];
const kFuelTypeOptions = [kAllFuelTypes, 'Petrol', 'Diesel', 'Hybrid'];
const kOwnerOptions = [kAllOwners, '1st owner', '2nd owner', '3rd+ owner'];
const kMinPriceLac = 0.0;
const kMaxPriceLac = 150.0;
const kMinYear = 2005;
const kMaxYear = 2026;
const kMinYearD = 2005.0;
const kMaxYearD = 2026.0;
const kMinMileage = 0.0;
const kMaxMileage = 100000.0;

/// Preset range buckets for the quick-filter chips — lets price/year/mileage
/// be picked from a horizontal dropdown chip instead of a slider.
const kPriceBuckets = <String, RangeValues>{
  'Price': RangeValues(kMinPriceLac, kMaxPriceLac),
  'Under 30 lac': RangeValues(kMinPriceLac, 30),
  '30–60 lac': RangeValues(30, 60),
  '60–100 lac': RangeValues(60, 100),
  '100+ lac': RangeValues(100, kMaxPriceLac),
};
const kYearBuckets = <String, RangeValues>{
  'Year': RangeValues(kMinYearD, kMaxYearD),
  '2005–2015': RangeValues(2005, 2015),
  '2016–2020': RangeValues(2016, 2020),
  '2021–2026': RangeValues(2021, kMaxYearD),
};
const kMileageBuckets = <String, RangeValues>{
  'Mileage': RangeValues(kMinMileage, kMaxMileage),
  'Under 20,000 km': RangeValues(kMinMileage, 20000),
  '20,000–50,000 km': RangeValues(20000, 50000),
  '50,000+ km': RangeValues(50000, kMaxMileage),
};

/// The bucket label matching a range value, for showing the current
/// selection on a quick-filter chip; falls back to the placeholder label.
String labelForBucket(Map<String, RangeValues> buckets, RangeValues value) {
  for (final entry in buckets.entries) {
    if (entry.value == value) return entry.key;
  }
  return buckets.keys.first;
}

/// Filter criteria applied to the listings feed on the Buy screen.
class CarFilters {
  final RangeValues priceLacRange;
  final RangeValues yearRange;
  final RangeValues mileageKmRange;
  final String city;
  final String bodyType;
  final String transmission;
  final String fuelType;
  final String owner;
  final bool verifiedOnly;
  final bool dealerOnly;

  const CarFilters({
    this.priceLacRange = const RangeValues(kMinPriceLac, kMaxPriceLac),
    this.yearRange = const RangeValues(kMinYearD, kMaxYearD),
    this.mileageKmRange = const RangeValues(kMinMileage, kMaxMileage),
    this.city = kAllCities,
    this.bodyType = kAllBodyTypes,
    this.transmission = kAllTransmissions,
    this.fuelType = kAllFuelTypes,
    this.owner = kAllOwners,
    this.verifiedOnly = false,
    this.dealerOnly = false,
  });

  bool get isDefault => this == const CarFilters();

  bool matches(CarListing car) {
    final priceLac = car.priceValue / 100000;
    if (priceLac < priceLacRange.start || priceLac > priceLacRange.end) return false;
    if (car.year < yearRange.start.round() || car.year > yearRange.end.round()) return false;
    final mileage = car.mileageKm.toDouble();
    if (mileage < mileageKmRange.start || mileage > mileageKmRange.end) return false;
    if (city != kAllCities && car.city != city) return false;
    if (bodyType != kAllBodyTypes && car.bodyType != bodyType) return false;
    if (transmission != kAllTransmissions && car.transmission != transmission) return false;
    if (fuelType != kAllFuelTypes && car.fuelType != fuelType) return false;
    if (owner != kAllOwners && car.ownerLabel != owner) return false;
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
        if (mileageKmRange.start != kMinMileage || mileageKmRange.end != kMaxMileage)
          '${mileageKmRange.start.round()}–${mileageKmRange.end.round()} km',
        if (city != kAllCities) city,
        if (bodyType != kAllBodyTypes) bodyType,
        if (transmission != kAllTransmissions) transmission,
        if (fuelType != kAllFuelTypes) fuelType,
        if (owner != kAllOwners) owner,
        if (verifiedOnly) 'Verified only',
        if (dealerOnly) 'Dealer only',
      ];

  CarFilters copyWith({
    RangeValues? priceLacRange,
    RangeValues? yearRange,
    RangeValues? mileageKmRange,
    String? city,
    String? bodyType,
    String? transmission,
    String? fuelType,
    String? owner,
    bool? verifiedOnly,
    bool? dealerOnly,
  }) =>
      CarFilters(
        priceLacRange: priceLacRange ?? this.priceLacRange,
        yearRange: yearRange ?? this.yearRange,
        mileageKmRange: mileageKmRange ?? this.mileageKmRange,
        city: city ?? this.city,
        bodyType: bodyType ?? this.bodyType,
        transmission: transmission ?? this.transmission,
        fuelType: fuelType ?? this.fuelType,
        owner: owner ?? this.owner,
        verifiedOnly: verifiedOnly ?? this.verifiedOnly,
        dealerOnly: dealerOnly ?? this.dealerOnly,
      );

  @override
  bool operator ==(Object other) =>
      other is CarFilters &&
      other.priceLacRange == priceLacRange &&
      other.yearRange == yearRange &&
      other.mileageKmRange == mileageKmRange &&
      other.city == city &&
      other.bodyType == bodyType &&
      other.transmission == transmission &&
      other.fuelType == fuelType &&
      other.owner == owner &&
      other.verifiedOnly == verifiedOnly &&
      other.dealerOnly == dealerOnly;

  @override
  int get hashCode => Object.hash(
        priceLacRange,
        yearRange,
        mileageKmRange,
        city,
        bodyType,
        transmission,
        fuelType,
        owner,
        verifiedOnly,
        dealerOnly,
      );
}

/// The filter criteria currently applied across the app — set from the Buy
/// screen's own filter button or from the dashboard's quick-filter bar, and
/// read by the Buy screen's listings feed either way.
final activeFilters = ValueNotifier<CarFilters>(const CarFilters());

/// Opens the filters UI. On wide (tablet/desktop) viewports it slides in as a
/// panel docked to the right edge instead of taking over the whole screen;
/// on phones it's a full-screen page, since there isn't room for a side panel.
Future<CarFilters?> openFiltersPanel(BuildContext context, CarFilters initial) {
  if (!context.isWide) {
    return Navigator.of(context).push<CarFilters>(
      MaterialPageRoute(builder: (_) => FiltersScreen(initialFilters: initial)),
    );
  }
  final c = context.colors;
  return showGeneralDialog<CarFilters>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Filters',
    barrierColor: Colors.black.withValues(alpha: 0.4),
    transitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (context, _, _) => Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: c.paper,
        elevation: 8,
        child: SizedBox(
          width: 440,
          height: double.infinity,
          child: FiltersScreen(initialFilters: initial),
        ),
      ),
    ),
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(curved),
        child: child,
      );
    },
  );
}

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
        child: ResponsiveContent(
          maxWidth: 560,
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
                  Text('TRANSMISSION', style: eyebrowStyle(c.ash)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: kTransmissionOptions
                        .map((t) => AppChip(
                              label: t,
                              active: t == filters.transmission,
                              onTap: () => setState(() => filters = filters.copyWith(transmission: t)),
                            ))
                        .toList(),
                  ),
                  const Divider(height: 28),
                  Text('FUEL TYPE', style: eyebrowStyle(c.ash)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: kFuelTypeOptions
                        .map((f) => AppChip(
                              label: f,
                              active: f == filters.fuelType,
                              onTap: () => setState(() => filters = filters.copyWith(fuelType: f)),
                            ))
                        .toList(),
                  ),
                  const Divider(height: 28),
                  Text('OWNERS', style: eyebrowStyle(c.ash)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: kOwnerOptions
                        .map((o) => AppChip(
                              label: o,
                              active: o == filters.owner,
                              onTap: () => setState(() => filters = filters.copyWith(owner: o)),
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
                  Text('MILEAGE (KM)', style: eyebrowStyle(c.ash)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${filters.mileageKmRange.start.round()} km', style: monoStyle(size: 14, weight: 700, color: c.red)),
                        Text('${filters.mileageKmRange.end.round()} km', style: monoStyle(size: 14, weight: 700, color: c.red)),
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
                      values: filters.mileageKmRange,
                      min: kMinMileage,
                      max: kMaxMileage,
                      onChanged: (v) => setState(() => filters = filters.copyWith(mileageKmRange: v)),
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
