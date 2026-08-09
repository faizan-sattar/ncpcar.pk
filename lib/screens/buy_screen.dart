import 'package:flutter/material.dart';
import '../models/car_listing.dart';
import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import '../widgets/common.dart';
import '../widgets/listing_card.dart';
import 'car_details_screen.dart';
import 'filters_screen.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final searchController = TextEditingController();
  String query = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<CarListing> _filter(List<CarListing> source, CarFilters filters) {
    final q = query.trim().toLowerCase();
    return source.where((car) {
      if (!filters.matches(car)) return false;
      if (q.isEmpty) return true;
      return car.title.toLowerCase().contains(q) || car.city.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _openFilters() async {
    final result = await openFiltersPanel(context, activeFilters.value);
    if (result != null) activeFilters.value = result;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      child: ValueListenableBuilder<CarFilters>(
        valueListenable: activeFilters,
        builder: (context, filters, _) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Text('Buy a car', style: bodyStyle(size: 18, weight: 800, color: c.ink)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: context.isWide ? 22 : 16, vertical: context.isWide ? 14 : 0),
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: c.ashSoft, width: 1.4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded, size: context.isWide ? 22 : 18, color: c.ash),
                          SizedBox(width: context.isWide ? 14 : 10),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (v) => setState(() => query = v),
                              style: bodyStyle(size: context.isWide ? 16 : 13.5, color: c.ink),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Search make, model or city',
                                hintStyle: bodyStyle(size: context.isWide ? 16 : 13.5, color: c.ash),
                              ),
                            ),
                          ),
                          if (query.isNotEmpty)
                            GestureDetector(
                              onTap: () => setState(() {
                                searchController.clear();
                                query = '';
                              }),
                              child: Icon(Icons.close_rounded, size: 17, color: c.ash),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconCircleButton(
                    icon: Icons.tune_rounded,
                    borderColor: c.red,
                    iconColor: c.red,
                    size: context.isWide ? 54 : 38,
                    onTap: _openFilters,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                children: [
                  for (final label in filters.activeLabels) ...[
                    AppChip(label: '$label ✕', active: true, onTap: _openFilters),
                    const SizedBox(width: 9),
                  ],
                  AppChip(label: filters.isDefault ? 'Filters' : '+ More filters', onTap: _openFilters),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<CarListing>>(
                valueListenable: listingsStore,
                builder: (context, listings, _) {
                  final filtered = _filter(listings, filters);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: bodyStyle(size: 12.5, color: c.inkSoft),
                                children: [
                                  TextSpan(text: '${filtered.length} ', style: bodyStyle(size: 12.5, weight: 800, color: c.ink)),
                                  const TextSpan(text: 'cars found'),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text('Sort: Newest', style: bodyStyle(size: 12.5, weight: 700, color: c.red)),
                                Icon(Icons.expand_more_rounded, size: 16, color: c.red),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: filtered.isEmpty
                            ? _EmptyState(query: query, filtersActive: !filters.isDefault)
                            : GridView.builder(
                                padding: const EdgeInsets.only(top: 6, bottom: 20),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 560, mainAxisExtent: 140),
                                itemCount: filtered.length,
                                itemBuilder: (context, i) {
                                  final car = filtered[i];
                                  return ListingRowCard(
                                    car: car,
                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CarDetailsScreen(car: car))),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  final bool filtersActive;
  const _EmptyState({required this.query, required this.filtersActive});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final title = query.isNotEmpty ? 'No cars match "$query"' : 'No cars match your filters';
    final subtitle = query.isNotEmpty
        ? 'Try a different make, model or city.'
        : (filtersActive ? 'Try widening your price, year or city filters.' : 'Try a different make, model or city.');
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 40, color: c.ash),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: bodyStyle(size: 14, weight: 800, color: c.ink)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center, style: bodyStyle(size: 12.5, color: c.ash)),
          ],
        ),
      ),
    );
  }
}
