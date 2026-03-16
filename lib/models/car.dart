class Car {
  final String brand;
  final String model;
  final int year;
  final double price;
  final String imageUrl;
  final String description;
  final bool isFavorite;

  const Car({
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    final priceString =
        (json['price'] as String? ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    final parsedPrice =
        double.tryParse(priceString.isEmpty ? '0' : priceString) ?? 0;

    final brand = json['car'] as String? ?? 'Car';
    final model = json['car_model'] as String? ?? '';
    final fullName = '$brand $model'.trim();
    final imageUrl = getCarImagePath(fullName);

    return Car(
      brand: brand,
      model: model,
      year: (json['car_model_year'] as num?)?.toInt() ?? 0,
      price: parsedPrice,
      imageUrl: imageUrl,
      description:
          'Renk: ${json['car_color'] ?? '-'} · VIN: ${json['car_vin'] ?? '-'} · Uygunluk: ${json['availability'] ?? '-'}',
      isFavorite: false,
    );
  }
}

String getCarImagePath(String carName) {
  final normalized = carName.toLowerCase().replaceAll(' ', '-');
  return 'assets/images/cars/$normalized.jpg';
}

/// Test amaçlı örnek araç listesi.
List<Car> mockCars = [
  Car(
    brand: 'Toyota',
    model: 'Corolla',
    year: 2023,
    price: 850000,
    imageUrl: getCarImagePath('Toyota Corolla'),
    description:
        'Güvenilir ve ekonomik sedan. Düşük yakıt tüketimi ve geniş bagaj alanı ile günlük kullanım için ideal.',
    isFavorite: false,
  ),
  Car(
    brand: 'Honda',
    model: 'Civic',
    year: 2024,
    price: 920000,
    imageUrl: getCarImagePath('Honda Civic'),
    description:
        'Sportif tasarım ve konforlu sürüş. Yüksek güvenlik donanımları ve modern teknoloji paketi sunar.',
    isFavorite: true,
  ),
  Car(
    brand: 'Volkswagen',
    model: 'Golf',
    year: 2023,
    price: 1100000,
    imageUrl: getCarImagePath('Volkswagen Golf'),
    description:
        'Komakt segmentin referans modeli. Dengeli sürüş dinamikleri ve kaliteli iç mekan.',
    isFavorite: false,
  ),
  Car(
    brand: 'Ford',
    model: 'Focus',
    year: 2022,
    price: 780000,
    imageUrl: getCarImagePath('Ford Focus'),
    description:
        'Uygun fiyatlı ve verimli. Şehir içi ve şehirlerarası kullanım için uygundur.',
    isFavorite: false,
  ),
  Car(
    brand: 'Renault',
    model: 'Megane',
    year: 2024,
    price: 950000,
    imageUrl: getCarImagePath('Renault Megane'),
    description:
        'Fransız tasarımı ve konforu. Geniş iç hacim ve zengin donanım seçenekleri.',
    isFavorite: true,
  ),
  Car(
    brand: 'BMW',
    model: '3 Serisi',
    year: 2023,
    price: 1850000,
    imageUrl: getCarImagePath('BMW 3 Serisi'),
    description:
        'Lüks sedan segmentinde sürüş keyfi ve prestij. Güçlü motor seçenekleri ve lüks donanım.',
    isFavorite: false,
  ),
];
