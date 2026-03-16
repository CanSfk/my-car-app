import 'package:flutter/material.dart';
import '../models/car.dart';
import '../widgets/car_card.dart';
import '../services/car_service.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _service = CarService();

  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;

  List<Car> _cars = [];

  Set<String> _favoriteIds = {};

  List<Car> get _filteredCars => _cars
      .where((c) =>
          c.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.model.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  List<Car> get _favoriteCars => _cars
      .where(
        (c) => _favoriteIds.contains('${c.brand}-${c.model}'),
      )
      .toList();

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cars = await _service.fetchCars();
      setState(() {
        _cars = cars;
        _favoriteIds = {
          for (final c in _cars.where((c) => c.isFavorite))
            '${c.brand}-${c.model}',
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Veriler alınırken bir hata oluştu.';
        _isLoading = false;
      });
    }
  }

  void _toggleFavorite(Car car) {
    setState(() {
      final key = '${car.brand}-${car.model}';
      if (_favoriteIds.contains(key)) {
        _favoriteIds.remove(key);
      } else {
        _favoriteIds.add(key);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My-Car'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favorites: _favoriteCars,
                    isFavorite: (car) =>
                        _favoriteIds.contains('${car.brand}-${car.model}'),
                    onToggleFavorite: _toggleFavorite,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Marka veya model ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Araç Kataloğu',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Listelenen araçlara tıklayarak detayları inceleyebilirsiniz.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer
                            .withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_errorMessage!),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _loadCars,
                              child: const Text('Tekrar dene'),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _filteredCars.length,
                        itemBuilder: (context, index) {
                          final car = _filteredCars[index];
                          return CarCard(
                            car: car,
                            isFavorite: _favoriteIds
                                .contains('${car.brand}-${car.model}'),
                            onFavoriteToggle: () => _toggleFavorite(car),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
