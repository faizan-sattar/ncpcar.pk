import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/car_listing.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

enum _PhotoAction { camera, gallery, remove }

const bodyTypeOptions = ['Hatchback', 'Sedan', 'SUV'];

String _formatPriceLabel(int rupees) {
  if (rupees >= 10000000) return 'Rs ${_trimDecimal(rupees / 10000000)} cr';
  if (rupees >= 100000) return 'Rs ${_trimDecimal(rupees / 100000)} lac';
  return 'Rs $rupees';
}

String _trimDecimal(double v) {
  final s = v.toStringAsFixed(1);
  return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
}

class SellScreen extends StatefulWidget {
  final VoidCallback? onPublished;
  const SellScreen({super.key, this.onPublished});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  int step = 1;
  final List<Uint8List?> photos = List<Uint8List?>.filled(6, null);
  final picker = ImagePicker();

  String bodyType = 'Sedan';

  final makeCtrl = TextEditingController(text: 'Toyota');
  final modelCtrl = TextEditingController(text: 'Corolla Altis');
  final yearCtrl = TextEditingController(text: '2021');
  final mileageCtrl = TextEditingController(text: '34,200');
  final priceCtrl = TextEditingController(text: '6,250,000');
  final cityCtrl = TextEditingController(text: 'Gilgit');

  static const stepLabels = ['Photos', 'Specs', 'Publish'];

  int get photoCount => photos.where((p) => p != null).length;

  @override
  void dispose() {
    for (final ctrl in [makeCtrl, modelCtrl, yearCtrl, mileageCtrl, priceCtrl, cityCtrl]) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto(int index) async {
    final choice = await showModalBottomSheet<_PhotoAction>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (sheetContext) {
        final c = sheetContext.colors;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.photo_camera_outlined, color: c.ink),
                title: Text('Take a photo', style: bodyStyle(size: 14, weight: 700, color: c.ink)),
                onTap: () => Navigator.of(sheetContext).pop(_PhotoAction.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library_outlined, color: c.ink),
                title: Text('Choose from gallery', style: bodyStyle(size: 14, weight: 700, color: c.ink)),
                onTap: () => Navigator.of(sheetContext).pop(_PhotoAction.gallery),
              ),
              if (photos[index] != null)
                ListTile(
                  leading: Icon(Icons.delete_outline_rounded, color: c.red),
                  title: Text('Remove photo', style: bodyStyle(size: 14, weight: 700, color: c.red)),
                  onTap: () => Navigator.of(sheetContext).pop(_PhotoAction.remove),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (choice == null) return;
    if (choice == _PhotoAction.remove) {
      setState(() => photos[index] = null);
      return;
    }
    final source = choice == _PhotoAction.camera ? ImageSource.camera : ImageSource.gallery;
    final file = await picker.pickImage(source: source, imageQuality: 85, maxWidth: 1600);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() => photos[index] = bytes);
  }

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

  void _goNext() {
    if (step == 1 && photoCount < 6) {
      _toast('Add at least 6 photos to continue');
      return;
    }
    if (step < 3) setState(() => step += 1);
  }

  void _goBack() {
    if (step > 1) setState(() => step -= 1);
  }

  void _publish() {
    final rawPrice = int.tryParse(priceCtrl.text.replaceAll(',', '').trim()) ?? 0;
    final year = int.tryParse(yearCtrl.text.trim()) ?? DateTime.now().year;
    final mileage = int.tryParse(mileageCtrl.text.replaceAll(',', '').trim()) ?? 0;
    final make = makeCtrl.text.trim();
    final model = modelCtrl.text.trim();

    listingsStore.addListing(CarListing(
      id: 0,
      title: [make, model].where((s) => s.isNotEmpty).join(' '),
      year: year,
      mileageKm: mileage,
      transmission: 'Automatic',
      bodyType: bodyType,
      city: cityCtrl.text.trim().isEmpty ? 'Gilgit' : cityCtrl.text.trim(),
      price: _formatPriceLabel(rawPrice),
      priceValue: rawPrice,
      isDealer: false,
      verified: false,
      plateIndex: listingsStore.value.length,
      photoCount: '1/$photoCount',
    ));

    _toast('Listing published — find it under Latest listings on Home');
    setState(() {
      step = 1;
      bodyType = 'Sedan';
      for (final p in [0, 1, 2, 3, 4, 5]) {
        photos[p] = null;
      }
    });
    widget.onPublished?.call();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Align(alignment: Alignment.centerLeft, child: Text('Sell your car', style: bodyStyle(size: 18, weight: 800, color: c.ink))),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Row(
              children: List.generate(stepLabels.length, (i) {
                final n = i + 1;
                final done = n < step;
                final active = n == step;
                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          if (i > 0) Expanded(child: Container(height: 2, color: done || active ? c.verified : c.surface2)),
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: done ? c.verified : (active ? c.red : c.surface2),
                            ),
                            child: Center(
                              child: done
                                  ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                                  : Text('$n', style: bodyStyle(size: 11, weight: 800, color: active ? Colors.white : c.ash)),
                            ),
                          ),
                          if (i < stepLabels.length - 1) Expanded(child: Container(height: 2, color: c.surface2)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(stepLabels[i], style: bodyStyle(size: 10, weight: 700, color: active ? c.ink : c.ash)),
                    ],
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: switch (step) {
              1 => _PhotosStep(photos: photos, onPick: _pickPhoto, onContinue: _goNext),
              2 => _SpecsStep(
                  makeCtrl: makeCtrl,
                  modelCtrl: modelCtrl,
                  yearCtrl: yearCtrl,
                  mileageCtrl: mileageCtrl,
                  priceCtrl: priceCtrl,
                  cityCtrl: cityCtrl,
                  bodyType: bodyType,
                  onBodyTypeChanged: (v) => setState(() => bodyType = v),
                  onBack: _goBack,
                  onContinue: _goNext,
                ),
              _ => _PublishStep(
                  photoCount: photoCount,
                  make: makeCtrl.text,
                  model: modelCtrl.text,
                  year: yearCtrl.text,
                  price: priceCtrl.text,
                  city: cityCtrl.text,
                  bodyType: bodyType,
                  onBack: _goBack,
                  onPublish: _publish,
                ),
            },
          ),
        ],
      ),
    );
  }
}

class _PhotosStep extends StatelessWidget {
  final List<Uint8List?> photos;
  final void Function(int index) onPick;
  final VoidCallback onContinue;
  const _PhotosStep({required this.photos, required this.onPick, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final count = photos.where((p) => p != null).length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('PHOTOS (MIN. 6)', style: eyebrowStyle(c.ash)),
            Text('$count/6 added', style: bodyStyle(size: 11.5, weight: 700, color: c.ash)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Clear, well-lit photos from every angle help buyers trust your listing.', style: bodyStyle(size: 12, color: c.inkSoft)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(6, (i) {
            final bytes = photos[i];
            return InkWell(
              onTap: () => onPick(i),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Ink(
                decoration: BoxDecoration(
                  color: c.surface2.withValues(alpha: bytes != null ? 1 : 0.5),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: c.ashSoft, width: 1.4),
                ),
                child: bytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md - 1.4),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(bytes, fit: BoxFit.cover),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.55), shape: BoxShape.circle),
                                child: const Icon(Icons.edit_rounded, size: 12, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Icon(Icons.add_photo_alternate_outlined, color: c.ash, size: 22),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        PrimaryButton(label: 'Continue to specs', onTap: onContinue),
      ],
    );
  }
}

class _SpecsStep extends StatelessWidget {
  final TextEditingController makeCtrl;
  final TextEditingController modelCtrl;
  final TextEditingController yearCtrl;
  final TextEditingController mileageCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController cityCtrl;
  final String bodyType;
  final ValueChanged<String> onBodyTypeChanged;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  const _SpecsStep({
    required this.makeCtrl,
    required this.modelCtrl,
    required this.yearCtrl,
    required this.mileageCtrl,
    required this.priceCtrl,
    required this.cityCtrl,
    required this.bodyType,
    required this.onBodyTypeChanged,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        Text('VEHICLE SPECS', style: eyebrowStyle(c.ash)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _MiniField(label: 'Make', controller: makeCtrl)),
            const SizedBox(width: 10),
            Expanded(child: _MiniField(label: 'Model', controller: modelCtrl)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _MiniField(label: 'Year', controller: yearCtrl, mono: true)),
            const SizedBox(width: 10),
            Expanded(child: _MiniField(label: 'Mileage (km)', controller: mileageCtrl, mono: true)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _MiniField(label: 'Asking price (PKR)', controller: priceCtrl, mono: true)),
            const SizedBox(width: 10),
            Expanded(child: _MiniField(label: 'City', controller: cityCtrl)),
          ],
        ),
        Text('BODY TYPE', style: eyebrowStyle(c.ash)),
        const SizedBox(height: 10),
        Row(
          children: bodyTypeOptions.map((bt) {
            final active = bt == bodyType;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: bt == bodyTypeOptions.last ? 0 : 10),
                child: GestureDetector(
                  onTap: () => onBodyTypeChanged(bt),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active ? c.redTint : c.surface2,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: active ? c.red : Colors.transparent, width: 1.4),
                    ),
                    child: Text(bt, style: bodyStyle(size: 12.5, weight: 700, color: active ? c.redStrong : c.inkSoft)),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            GhostButton(label: 'Back', onTap: onBack),
            const SizedBox(width: 10),
            Expanded(child: PrimaryButton(label: 'Continue to publish', onTap: onContinue)),
          ],
        ),
      ],
    );
  }
}

class _PublishStep extends StatelessWidget {
  final int photoCount;
  final String make;
  final String model;
  final String year;
  final String price;
  final String city;
  final String bodyType;
  final VoidCallback onBack;
  final VoidCallback onPublish;
  const _PublishStep({
    required this.photoCount,
    required this.make,
    required this.model,
    required this.year,
    required this.price,
    required this.city,
    required this.bodyType,
    required this.onBack,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        Text('REVIEW & PUBLISH', style: eyebrowStyle(c.ash)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: c.ashSoft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$make $model', style: bodyStyle(size: 15, weight: 800, color: c.ink)),
              const SizedBox(height: 2),
              Text('$year · Rs $price · $bodyType · $city', style: monoStyle(size: 12.5, color: c.inkSoft)),
              const Divider(height: 24),
              _ReviewRow(
                label: 'Photos',
                value: '$photoCount added',
                state: photoCount >= 6 ? _ReviewState.done : _ReviewState.pending,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Once published, buyers can find your listing on Home and in Buy right away.',
          style: bodyStyle(size: 12, color: c.inkSoft, height: 1.4),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            GhostButton(label: 'Back', onTap: onBack),
            const SizedBox(width: 10),
            Expanded(child: PrimaryButton(label: 'Publish listing', icon: Icons.check_circle_outline_rounded, onTap: onPublish)),
          ],
        ),
      ],
    );
  }
}

enum _ReviewState { done, pending, skipped }

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final _ReviewState state;
  const _ReviewRow({required this.label, required this.value, required this.state});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (icon, color) = switch (state) {
      _ReviewState.done => (Icons.check_circle_rounded, c.verified),
      _ReviewState.pending => (Icons.error_outline_rounded, c.amber),
      _ReviewState.skipped => (Icons.remove_circle_outline_rounded, c.ash),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bodyStyle(size: 12.5, color: c.inkSoft)),
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Text(value, style: bodyStyle(size: 12.5, weight: 700, color: color)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool mono;
  const _MiniField({required this.label, required this.controller, this.mono = false});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: bodyStyle(size: 11.5, weight: 700, color: c.inkSoft)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            style: mono ? monoStyle(size: 14, color: c.ink) : bodyStyle(size: 14, color: c.ink),
            decoration: InputDecoration(
              hintStyle: bodyStyle(size: 14, color: c.ash),
              filled: true,
              fillColor: c.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
