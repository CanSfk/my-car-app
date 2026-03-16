import 'package:flutter/material.dart';
import '../models/car.dart';
import '../widgets/favorite_car_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final List<Car> favorites;
  final bool Function(Car) isFavorite;
  final void Function(Car) onToggleFavorite;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Car> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = List<Car>.from(widget.favorites);
  }

  void _handleToggle(Car car) {
    setState(() {
      _favorites.removeWhere(
        (c) =>
            c.brand == car.brand &&
            c.model == car.model &&
            c.year == car.year &&
            c.price == car.price,
      );
    });
    widget.onToggleFavorite(car);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriler'),
      ),
      body: _favorites.isEmpty
          ? const Center(
              child: Text('Henüz favori araç eklemediniz'),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final car = _favorites[index];
                return FavoriteCarCard(
                  car: car,
                  isFavorite: widget.isFavorite(car),
                  onFavoriteToggle: () => _handleToggle(car),
                );
              },
            ),
    );
  }
}

