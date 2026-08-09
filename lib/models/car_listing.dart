import 'package:flutter/foundation.dart';

class CarListing {
  final int id;
  final String title;
  final int year;
  final int mileageKm;
  final String transmission;
  final String bodyType;
  final String city;
  final String price;
  final int priceValue;
  final bool isDealer;
  final bool verified;
  final int plateIndex;
  final String photoCount;
  final String fuelType;
  final int ownerCount;

  const CarListing({
    required this.id,
    required this.title,
    required this.year,
    required this.mileageKm,
    required this.transmission,
    required this.bodyType,
    required this.city,
    required this.price,
    required this.priceValue,
    required this.isDealer,
    required this.verified,
    required this.plateIndex,
    required this.photoCount,
    this.fuelType = 'Petrol',
    this.ownerCount = 1,
  });

  CarListing copyWith({bool? verified}) => CarListing(
        id: id,
        title: title,
        year: year,
        mileageKm: mileageKm,
        transmission: transmission,
        bodyType: bodyType,
        city: city,
        price: price,
        priceValue: priceValue,
        isDealer: isDealer,
        verified: verified ?? this.verified,
        plateIndex: plateIndex,
        photoCount: photoCount,
        fuelType: fuelType,
        ownerCount: ownerCount,
      );

  String get mileageLabel => '${_km(mileageKm)} km';
  String get ownerLabel => switch (ownerCount) {
        1 => '1st owner',
        2 => '2nd owner',
        _ => '3rd+ owner',
      };
  String get specLine => '$year · $mileageLabel · $transmission';
  String get specLineWithCity => '$year · $mileageLabel · $city';

  static String _km(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}

const _initialListings = [
  CarListing(
    id: 1,
    title: 'Toyota Corolla Altis',
    year: 2021,
    mileageKm: 34200,
    transmission: 'Automatic',
    bodyType: 'Sedan',
    city: 'Gilgit',
    price: 'Rs 62.5 lac',
    priceValue: 6250000,
    isDealer: false,
    verified: true,
    plateIndex: 0,
    photoCount: '1/14',
    fuelType: 'Petrol',
    ownerCount: 1,
  ),
  CarListing(
    id: 2,
    title: 'Honda Civic Oriel',
    year: 2020,
    mileageKm: 41000,
    transmission: 'Automatic',
    bodyType: 'Sedan',
    city: 'Skardu',
    price: 'Rs 71.9 lac',
    priceValue: 7190000,
    isDealer: true,
    verified: true,
    plateIndex: 1,
    photoCount: '1/10',
    fuelType: 'Petrol',
    ownerCount: 2,
  ),
  CarListing(
    id: 3,
    title: 'Suzuki Alto VXR',
    year: 2022,
    mileageKm: 12600,
    transmission: 'Manual',
    bodyType: 'Hatchback',
    city: 'Gilgit',
    price: 'Rs 24.8 lac',
    priceValue: 2480000,
    isDealer: false,
    verified: true,
    plateIndex: 2,
    photoCount: '1/9',
    fuelType: 'Petrol',
    ownerCount: 1,
  ),
  CarListing(
    id: 4,
    title: 'KIA Sportage AWD',
    year: 2023,
    mileageKm: 8400,
    transmission: 'Automatic',
    bodyType: 'SUV',
    city: 'Islamabad',
    price: 'Rs 1.12 cr',
    priceValue: 11200000,
    isDealer: true,
    verified: true,
    plateIndex: 3,
    photoCount: '1/16',
    fuelType: 'Diesel',
    ownerCount: 1,
  ),
  CarListing(
    id: 5,
    title: 'Toyota Yaris ATIV X',
    year: 2022,
    mileageKm: 19800,
    transmission: 'Automatic',
    bodyType: 'Sedan',
    city: 'Karachi',
    price: 'Rs 48.3 lac',
    priceValue: 4830000,
    isDealer: false,
    verified: false,
    plateIndex: 4,
    photoCount: '1/8',
    fuelType: 'Petrol',
    ownerCount: 1,
  ),
  CarListing(
    id: 6,
    title: 'Toyota Corolla GLI',
    year: 2019,
    mileageKm: 58900,
    transmission: 'Manual',
    bodyType: 'Sedan',
    city: 'Lahore',
    price: 'Rs 45.2 lac',
    priceValue: 4520000,
    isDealer: true,
    verified: true,
    plateIndex: 5,
    photoCount: '1/11',
    fuelType: 'Petrol',
    ownerCount: 3,
  ),
  CarListing(
    id: 7,
    title: 'Suzuki Cultus VXL',
    year: 2021,
    mileageKm: 27300,
    transmission: 'Manual',
    bodyType: 'Hatchback',
    city: 'Gilgit',
    price: 'Rs 32.6 lac',
    priceValue: 3260000,
    isDealer: false,
    verified: true,
    plateIndex: 6,
    photoCount: '1/9',
    fuelType: 'Petrol',
    ownerCount: 2,
  ),
  CarListing(
    id: 8,
    title: 'Honda City Aspire',
    year: 2020,
    mileageKm: 45200,
    transmission: 'Automatic',
    bodyType: 'Sedan',
    city: 'Hunza',
    price: 'Rs 52.4 lac',
    priceValue: 5240000,
    isDealer: false,
    verified: true,
    plateIndex: 7,
    photoCount: '1/12',
    fuelType: 'Petrol',
    ownerCount: 1,
  ),
  CarListing(
    id: 9,
    title: 'Toyota Prado TX',
    year: 2018,
    mileageKm: 71500,
    transmission: 'Automatic',
    bodyType: 'SUV',
    city: 'Islamabad',
    price: 'Rs 1.85 cr',
    priceValue: 18500000,
    isDealer: true,
    verified: true,
    plateIndex: 8,
    photoCount: '1/18',
    fuelType: 'Diesel',
    ownerCount: 2,
  ),
  CarListing(
    id: 10,
    title: 'Suzuki Wagon R VXL',
    year: 2022,
    mileageKm: 15900,
    transmission: 'Manual',
    bodyType: 'Hatchback',
    city: 'Skardu',
    price: 'Rs 28.9 lac',
    priceValue: 2890000,
    isDealer: false,
    verified: true,
    plateIndex: 9,
    photoCount: '1/7',
    fuelType: 'Petrol',
    ownerCount: 1,
  ),
  CarListing(
    id: 11,
    title: 'Toyota Fortuner Sigma 4',
    year: 2023,
    mileageKm: 6200,
    transmission: 'Automatic',
    bodyType: 'SUV',
    city: 'Lahore',
    price: 'Rs 2.1 cr',
    priceValue: 21000000,
    isDealer: true,
    verified: true,
    plateIndex: 10,
    photoCount: '1/20',
    fuelType: 'Diesel',
    ownerCount: 1,
  ),
  CarListing(
    id: 12,
    title: 'Honda Civic RS Turbo',
    year: 2021,
    mileageKm: 22400,
    transmission: 'Automatic',
    bodyType: 'Sedan',
    city: 'Karachi',
    price: 'Rs 89.5 lac',
    priceValue: 8950000,
    isDealer: false,
    verified: true,
    plateIndex: 11,
    photoCount: '1/13',
    fuelType: 'Petrol',
    ownerCount: 1,
  ),
  CarListing(
    id: 13,
    title: 'Suzuki Swift DLX',
    year: 2020,
    mileageKm: 38700,
    transmission: 'Manual',
    bodyType: 'Hatchback',
    city: 'Gilgit',
    price: 'Rs 31.4 lac',
    priceValue: 3140000,
    isDealer: false,
    verified: false,
    plateIndex: 12,
    photoCount: '1/6',
    fuelType: 'Petrol',
    ownerCount: 3,
  ),
  CarListing(
    id: 14,
    title: 'Toyota Land Cruiser V8',
    year: 2017,
    mileageKm: 89000,
    transmission: 'Automatic',
    bodyType: 'SUV',
    city: 'Islamabad',
    price: 'Rs 3.4 cr',
    priceValue: 34000000,
    isDealer: true,
    verified: true,
    plateIndex: 13,
    photoCount: '1/22',
    fuelType: 'Diesel',
    ownerCount: 3,
  ),
  CarListing(
    id: 15,
    title: 'Hyundai Elantra GLS',
    year: 2022,
    mileageKm: 17600,
    transmission: 'Automatic',
    bodyType: 'Sedan',
    city: 'Skardu',
    price: 'Rs 68.7 lac',
    priceValue: 6870000,
    isDealer: false,
    verified: true,
    plateIndex: 14,
    photoCount: '1/10',
    fuelType: 'Petrol',
    ownerCount: 1,
  ),
  CarListing(
    id: 16,
    title: 'KIA Sorento AWD',
    year: 2021,
    mileageKm: 31200,
    transmission: 'Automatic',
    bodyType: 'SUV',
    city: 'Hunza',
    price: 'Rs 95.8 lac',
    priceValue: 9580000,
    isDealer: true,
    verified: true,
    plateIndex: 15,
    photoCount: '1/15',
    fuelType: 'Hybrid',
    ownerCount: 2,
  ),
];

/// Live listings feed: seeded with the demo cars, and appended to whenever a
/// seller publishes through the Sell flow, so new listings appear on Home
/// and Buy immediately without a fake backend round-trip. Also the source
/// admins moderate from (remove a listing, toggle its verified badge).
class ListingsStore extends ValueNotifier<List<CarListing>> {
  ListingsStore() : super(List.unmodifiable(_initialListings));

  int _nextId = _initialListings.length + 1;

  void addListing(CarListing car) {
    value = List.unmodifiable([car.copyWith()._withId(_nextId++), ...value]);
  }

  void removeListing(int id) {
    value = List.unmodifiable(value.where((c) => c.id != id));
  }

  void setVerified(int id, bool verified) {
    value = List.unmodifiable(value.map((c) => c.id == id ? c.copyWith(verified: verified) : c));
  }
}

extension _WithId on CarListing {
  CarListing _withId(int newId) => CarListing(
        id: newId,
        title: title,
        year: year,
        mileageKm: mileageKm,
        transmission: transmission,
        bodyType: bodyType,
        city: city,
        price: price,
        priceValue: priceValue,
        isDealer: isDealer,
        verified: verified,
        plateIndex: plateIndex,
        photoCount: photoCount,
        fuelType: fuelType,
        ownerCount: ownerCount,
      );
}

final listingsStore = ListingsStore();
