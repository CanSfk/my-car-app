import 'package:flutter/material.dart';
import '../models/car.dart';
import '../screens/car_detail_screen.dart';

class CarCard extends StatelessWidget {
  const CarCard({
    super.key,
    required this.car,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final Car car;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailScreen(car: car),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _buildImage(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${car.brand} ${car.model}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${car.year} · ${_formatPrice(car.price)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16, 
                  backgroundColor: Colors.black,
                  child: IconButton(
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 16, 
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(), 
                    splashRadius: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatPrice(double price) {
    if (price >= 1000000) {
        double million = price / 1000000;
        return '${million.toStringAsFixed(1)}M ₺';
    } else if (price >= 1000) {
        return '${price.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (Match m) => '${m[1]}.')} ₺';
    } else {
        return '${price.toStringAsFixed(0)} ₺';
  }
}

  Widget _buildImage() {
    return Image.asset(
      car.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.directions_car, size: 40),
      ),
    );
  }
}
