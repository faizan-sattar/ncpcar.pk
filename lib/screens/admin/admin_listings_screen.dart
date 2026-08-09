import 'package:flutter/material.dart';
import '../../models/car_listing.dart';
import '../../theme/app_theme.dart';
import '../../theme/responsive.dart';
import '../../widgets/car_plate.dart';
import '../../widgets/common.dart';

class AdminListingsScreen extends StatelessWidget {
  const AdminListingsScreen({super.key});

  void _confirmRemove(BuildContext context, CarListing car) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final c = dialogContext.colors;
        return AlertDialog(
          backgroundColor: c.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
          title: Text('Remove listing?', style: bodyStyle(size: 16, weight: 800, color: c.ink)),
          content: Text(
            '"${car.title}" will be removed from Home and Buy immediately.',
            style: bodyStyle(size: 13, color: c.inkSoft),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel', style: bodyStyle(size: 13, weight: 700, color: c.inkSoft)),
            ),
            TextButton(
              onPressed: () {
                listingsStore.removeListing(car.id);
                Navigator.of(dialogContext).pop();
              },
              child: Text('Remove', style: bodyStyle(size: 13, weight: 800, color: c.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      top: false,
      child: ResponsiveContent(
        maxWidth: 900,
        child: ValueListenableBuilder<List<CarListing>>(
        valueListenable: listingsStore,
        builder: (context, listings, _) {
          if (listings.isEmpty) {
            return Center(
              child: Text('No listings to moderate', style: bodyStyle(size: 13.5, weight: 700, color: c.ink)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            itemCount: listings.length,
            itemBuilder: (context, i) {
              final car = listings[i];
              final plate = plateFor(car.plateIndex);
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: c.ashSoft),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 52,
                          child: CarPlate(plateA: plate.a, plateB: plate.b, glyphColor: plate.glyph, verified: car.verified),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(car.title, style: bodyStyle(size: 13, weight: 800, color: c.ink), overflow: TextOverflow.ellipsis),
                              Text(car.specLineWithCity, style: monoStyle(size: 10.5, color: c.ash)),
                              Text(car.price, style: displayStyle(size: 15, color: c.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text('Verified', style: bodyStyle(size: 11.5, weight: 700, color: c.inkSoft)),
                              const SizedBox(width: 8),
                              AppSwitch(value: car.verified, onChanged: (v) => listingsStore.setVerified(car.id, v)),
                            ],
                          ),
                        ),
                        IconCircleButton(
                          icon: Icons.delete_outline_rounded,
                          size: 34,
                          iconColor: c.red,
                          borderColor: c.red,
                          onTap: () => _confirmRemove(context, car),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        ),
      ),
    );
  }
}
