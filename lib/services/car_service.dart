import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/car.dart';

class CarService {
  static const _baseUrl = 'https://myfakeapi.com/api/cars';

  Future<List<Car>> fetchCars() async {
    final uri = Uri.parse(_baseUrl);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Araçlar alınırken hata oluştu (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final carsJson = data['cars'] as List<dynamic>? ?? [];

    final firstTen = carsJson.take(10);

    return firstTen
        .map((e) => Car.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

