import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _favoritesKey = 'favoriteInstitutions';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> addFavorite(String institutionId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();
    if (!favorites.contains(institutionId)) {
      favorites.add(institutionId);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  Future<void> removeFavorite(String institutionId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();
    favorites.remove(institutionId);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<bool> isFavorite(String institutionId) async {
    List<String> favorites = await getFavorites();
    return favorites.contains(institutionId);
  }
}