import '../models/recipe.dart';
import '../services/recipe_data_service.dart';

class FavoritesService {
  static final Set<String> _favoriteRecipeIds = <String>{};

  // Add a recipe to favorites
  static void addToFavorites(String recipeId) {
    _favoriteRecipeIds.add(recipeId);
  }

  // Remove a recipe from favorites
  static void removeFromFavorites(String recipeId) {
    _favoriteRecipeIds.remove(recipeId);
  }

  // Toggle favorite status
  static bool toggleFavorite(String recipeId) {
    if (_favoriteRecipeIds.contains(recipeId)) {
      _favoriteRecipeIds.remove(recipeId);
      return false; // Not favorited anymore
    } else {
      _favoriteRecipeIds.add(recipeId);
      return true; // Now favorited
    }
  }

  // Check if a recipe is favorited
  static bool isFavorite(String recipeId) {
    return _favoriteRecipeIds.contains(recipeId);
  }

  // Get all favorite recipe IDs
  static Set<String> getFavoriteRecipeIds() {
    return Set<String>.from(_favoriteRecipeIds);
  }

  // Get all favorite recipes as Recipe objects
  static List<Recipe> getFavoriteRecipes() {
    final allRecipes = RecipeDataService.recipes;
    return allRecipes
        .where((recipe) => _favoriteRecipeIds.contains(recipe.id))
        .toList();
  }

  // Get favorite count
  static int getFavoriteCount() {
    return _favoriteRecipeIds.length;
  }

  // Clear all favorites (useful for logout or reset)
  static void clearFavorites() {
    _favoriteRecipeIds.clear();
  }

  // Add some initial favorites for demo purposes
  static void initializeDemoFavorites() {
    // Add first two recipes as favorites for demo
    if (_favoriteRecipeIds.isEmpty) {
      _favoriteRecipeIds.addAll(['1', '3', '5']); // Risotto, Korean BBQ, and Ramen
    }
  }
}