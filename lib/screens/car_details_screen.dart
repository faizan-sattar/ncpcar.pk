import 'package:flutter/material.dart';
import '../auth/require_signed_in.dart';
import '../models/car_listing.dart';
import '../theme/app_theme.dart';
import '../widgets/car_plate.dart';
import '../widgets/common.dart';

class CarDetailsScreen extends StatefulWidget {
  final CarListing car;
  const CarDetailsScreen({super.key, required this.car});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  int photoIndex = 0;
  bool reportOpen = false;
  bool fav = false;

  void _toast(String message) {
    final c = context.colors;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: bodyStyle(size: 13, weight: 700, color: c.paper)),
        backgroundColor: c.ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    );
  }

  Future<void> _startChat() async {
    if (!await ensureSignedIn(context)) return;
    if (!mounted) return;
    _toast('Message sent — the seller usually replies within an hour.');
  }

  Future<void> _callSeller() async {
    if (!await ensureSignedIn(context)) return;
    if (!mounted) return;
    _toast('Connecting you to the seller…');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final car = widget.car;
    final plate = plateFor(car.plateIndex);

    return Scaffold(
      backgroundColor: c.paper,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  GestureDetector(
                    onHorizontalDragEnd: (d) {
                      if (d.primaryVelocity == null) return;
                      setState(() {
                        if (d.primaryVelocity! < 0) {
                          photoIndex = (photoIndex + 1) % 5;
                        } else {
                          photoIndex = (photoIndex - 1 + 5) % 5;
                        }
                      });
                    },
                    child: Stack(
                    children: [
                      SizedBox(
                        height: 230,
                        width: double.infinity,
                        child: CarPlate(
                          plateA: plate.a,
                          plateB: plate.b,
                          glyphColor: plate.glyph,
                          radius: BorderRadius.zero,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: IconCircleButton(
                          icon: Icons.arrow_back_rounded,
                          size: 36,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: IconCircleButton(
                          icon: fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 36,
                          iconColor: fav ? c.red : c.ink,
                          onTap: () => setState(() => fav = !fav),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) {
                            final active = i == photoIndex;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(horizontal: 2.5),
                              width: active ? 14 : 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: active ? 1 : 0.55),
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                              ),
                            );
                          }),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(AppRadius.pill)),
                          child: Text('${photoIndex + 1} / 14 photos', style: bodyStyle(size: 10.5, weight: 700, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(car.title, style: bodyStyle(size: 18, weight: 800, color: c.ink)),
                              const SizedBox(height: 3),
                              Text('${car.city} · Listed 2 days ago', style: bodyStyle(size: 12, color: c.ash)),
                            ],
                          ),
                        ),
                        Text(car.price, style: displayStyle(size: 30, color: c.red)),
                      ],
                    ),
                  ),
                  if (car.verified)
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Align(alignment: Alignment.centerLeft, child: SealBadge(label: 'Inspection verified · Score 8.7/10')),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.55,
                      children: [
                        SpecItem(label: 'Year', value: '${car.year}', mono: true),
                        SpecItem(label: 'Mileage', value: car.mileageLabel, mono: true),
                        const SpecItem(label: 'Fuel', value: 'Petrol'),
                        SpecItem(label: 'Transmission', value: car.transmission),
                        const SpecItem(label: 'Engine', value: '1598 cc', mono: true),
                        const SpecItem(label: 'Colour', value: 'Pearl White'),
                      ],
                    ),
                  ),
                  SectionHeader(title: 'Inspection report'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: c.ashSoft),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                _ScoreRing(score: 8.7),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('120-point technician inspection', style: bodyStyle(size: 13, weight: 800, color: c.ink)),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.check_rounded, size: 14, color: c.verified),
                                          const SizedBox(width: 3),
                                          Text('112 passed', style: bodyStyle(size: 11.5, weight: 700, color: c.verified)),
                                          const SizedBox(width: 12),
                                          Icon(Icons.warning_amber_rounded, size: 14, color: c.amber),
                                          const SizedBox(width: 3),
                                          Text('8 minor flags', style: bodyStyle(size: 11.5, weight: 700, color: c.amber)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() => reportOpen = !reportOpen),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                              decoration: BoxDecoration(border: Border(top: BorderSide(color: c.ashSoft))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('View full report', style: bodyStyle(size: 12.5, weight: 800, color: c.red)),
                                  Icon(reportOpen ? Icons.expand_less_rounded : Icons.expand_more_rounded, size: 18, color: c.red),
                                ],
                              ),
                            ),
                          ),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 220),
                            crossFadeState: reportOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                            firstChild: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                              child: Column(
                                children: const [
                                  _ReportLine('Body panels & paint depth', 'No cuts found', good: true),
                                  _ReportLine('Chassis & frame alignment', 'Pass'),
                                  _ReportLine('Engine & transmission', 'Pass'),
                                  _ReportLine('Suspension & brakes', 'Pass'),
                                  _ReportLine('AC, electricals & interior', 'Minor wear'),
                                  _ReportLine('Tyres tread depth (avg)', '6.2mm', mono: true),
                                ],
                              ),
                            ),
                            secondChild: const SizedBox(width: double.infinity),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SectionHeader(title: 'Seller'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: c.ashSoft),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(color: c.surface2, shape: BoxShape.circle),
                            child: Icon(Icons.person_outline_rounded, size: 22, color: c.ash),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(car.isDealer ? 'Al-Fateh Motors' : 'Ahmed Raza', style: bodyStyle(size: 13.5, weight: 800, color: c.ink)),
                                Row(
                                  children: [
                                    Text(car.isDealer ? 'Verified dealer' : 'Private seller', style: bodyStyle(size: 11, color: c.ash)),
                                    Text(' · ', style: bodyStyle(size: 11, color: c.ash)),
                                    Icon(Icons.star_rounded, size: 13, color: c.amber),
                                    Text(' 4.9', style: bodyStyle(size: 11, color: c.ash)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconCircleButton(icon: Icons.chat_bubble_outline_rounded, size: 40, onTap: _startChat),
                          const SizedBox(width: 8),
                          IconCircleButton(icon: Icons.call_outlined, size: 40, onTap: _callSeller),
                        ],
                      ),
                    ),
                  ),
                  SectionHeader(title: 'Description'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Single-owner ${car.title}, full company maintained. Genuine ${car.mileageLabel}, no accident history, no panel cuts — inspection certified. Sunroof, cruise control, original paint throughout.',
                      style: bodyStyle(size: 13, color: c.inkSoft, height: 1.55),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(color: c.paper, border: Border(top: BorderSide(color: c.ashSoft))),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: [
                Expanded(child: GhostButton(label: 'Chat', icon: Icons.chat_bubble_outline_rounded, onTap: _startChat)),
                const SizedBox(width: 10),
                Expanded(child: PrimaryButton(label: 'Call seller', icon: Icons.call_outlined, onTap: _callSeller)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final double score;
  const _ScoreRing({required this.score});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 10,
            strokeWidth: 6,
            backgroundColor: c.surface2,
            valueColor: AlwaysStoppedAnimation(c.verified),
          ),
          Text(score.toStringAsFixed(1), style: displayStyle(size: 16, color: c.ink)),
        ],
      ),
    );
  }
}

class _ReportLine extends StatelessWidget {
  final String label;
  final String value;
  final bool good;
  final bool mono;
  const _ReportLine(this.label, this.value, {this.good = false, this.mono = false});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: bodyStyle(size: 12.5, color: c.ink))),
          Text(
            value,
            style: mono
                ? monoStyle(size: 12.5, weight: 700, color: c.ink)
                : bodyStyle(size: 12.5, weight: good ? 800 : 700, color: good ? c.verified : c.ink),
          ),
        ],
      ),
    );
  }
}
