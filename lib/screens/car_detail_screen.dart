import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:math';

import '../models/car.dart';

class CarDetailScreen extends StatelessWidget {
  const CarDetailScreen({super.key, required this.car});

  final Car car;

  Future<List<_CarComment>> _loadComments() async {
    try {
      final jsonString = await rootBundle.loadString('assets/comments.json');
      final data = jsonDecode(jsonString);

      if (data is! List) return const [];

      final all = data
          .map(
            (e) => _CarComment.fromJson(e as Map<String, dynamic>),
          )
          .toList()
          .cast<_CarComment>();

      if (all.isEmpty) return const [];

      all.shuffle();
      final count = _randomCommentCount().clamp(1, all.length);
      return all.take(count).toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${car.brand} ${car.model}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<_CarComment>>(
        future: _loadComments(),
        builder: (context, snapshot) {
          final comments = snapshot.data ?? const <_CarComment>[];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      car.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.directions_car, size: 80),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _DetailChip(
                            icon: Icons.calendar_today,
                            label: 'Yıl',
                            value: '${car.year}',
                          ),
                          const SizedBox(width: 12),
                          _DetailChip(
                            icon: Icons.local_gas_station,
                            label: 'Yakıt',
                            value: 'Benzin',
                          ),
                          const SizedBox(width: 12),
                          _DetailChip(
                            icon: Icons.settings,
                            label: 'Vites',
                            value: 'Otomatik',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_formatPrice(car.price)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Açıklama',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _buildDynamicDescription(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Yorumlar',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (comments.isEmpty)
                        Text(
                          'Bu araç için henüz yorum yok.',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      else
                        Column(
                          children: comments
                              .map(
                                (c) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: _CommentTile(comment: c),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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

  String _buildDynamicDescription() {
    const motorType = '1.6 Turbo';
    const screenSize = '10.25\"';
    final modelName = car.model.isNotEmpty ? car.model : '${car.brand}';

    return '''
Başlık: Şehrin Yeni Ritmi: $modelName

Genel Bakış:
Modern tasarımı, yüksek konfor standartları ve yenilikçi teknolojileriyle $modelName, sadece bir ulaşım aracı değil, yaşam tarzınızın bir parçası olmaya aday. Şehir trafiğinde çevik, uzun yolda ise güven veren yapısıyla her yolculuğu bir keyfe dönüştürün.

Öne Çıkan Özellikler:

Verimlilik: Düşük yakıt tüketimi ve optimize edilmiş $motorType motor performansı.

Teknoloji: $screenSize dokunmatik multimedya ekranı, kablosuz bağlantı seçenekleri ve akıllı sürüş asistanları.

Konfor: Geniş iç hacim, ergonomik koltuk tasarımı ve premium malzeme kalitesi.

Neden $modelName?
Güvenliği ön planda tutan donanımları ve göz alıcı estetiğiyle hem aileniz hem de sizin için en ideal seçenek.
''';
  }

  int _randomCommentCount() {
    final random = Random();
    return 2 + random.nextInt(7); // 2 ile 8 arası
  }
}

class _CarComment {
  const _CarComment({
    required this.carModel,
    required this.username,
    required this.text,
    this.rating,
    this.date,
  });

  final String carModel;
  final String username;
  final String text;
  final int? rating;
  final String? date;

  factory _CarComment.fromJson(Map<String, dynamic> json) {
    return _CarComment(
      carModel: json['car_model'] as String? ?? '',
      username: json['username'] as String? ?? 'Anonim',
      text: (json['text'] as String?) ?? (json['comment'] as String?) ?? '',
      rating: (json['rating'] as num?)?.toInt(),
      date: json['date'] as String?,
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final _CarComment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                comment.username,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              if (comment.date != null)
                Text(
                  comment.date!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(width: 8),
              if (comment.rating != null)
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${comment.rating}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            comment.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
