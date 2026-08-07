import 'package:flutter/material.dart';
import '../models/car_listing.dart';
import '../theme/app_theme.dart';
import 'car_plate.dart';
import 'common.dart';

class ListingRowCard extends StatefulWidget {
  final CarListing car;
  final VoidCallback onTap;
  const ListingRowCard({super.key, required this.car, required this.onTap});

  @override
  State<ListingRowCard> createState() => _ListingRowCardState();
}

class _ListingRowCardState extends State<ListingRowCard> {
  bool fav = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final car = widget.car;
    final plate = plateFor(car.plateIndex);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: c.ashSoft),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 112,
                  height: 88,
                  child: CarPlate(
                    plateA: plate.a,
                    plateB: plate.b,
                    glyphColor: plate.glyph,
                    verified: car.verified,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(car.title,
                                style: bodyStyle(size: 14.5, weight: 800, color: c.ink),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => fav = !fav),
                            child: Icon(
                              fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 18,
                              color: fav ? c.red : c.ash,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(car.specLineWithCity, style: monoStyle(size: 11.5, color: c.ash)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              car.price,
                              style: displayStyle(size: 20, color: c.red),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          SellerBadge(isDealer: car.isDealer),
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
  }
}

class FeaturedCard extends StatelessWidget {
  final CarListing car;
  final VoidCallback onTap;
  const FeaturedCard({super.key, required this.car, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final plate = plateFor(car.plateIndex);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 198,
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: c.ashSoft),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 18, offset: const Offset(0, 8))],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 118,
              width: double.infinity,
              child: CarPlate(
                plateA: plate.a,
                plateB: plate.b,
                glyphColor: plate.glyph,
                verified: car.verified,
                photoCount: car.photoCount,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 10, 3, 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(car.title, style: bodyStyle(size: 13.5, weight: 800, color: c.ink), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(car.specLine, style: monoStyle(size: 11, color: c.ash)),
                  const SizedBox(height: 4),
                  Text(car.price, style: displayStyle(size: 19, color: c.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
