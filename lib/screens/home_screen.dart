import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../config/app_theme.dart';
import '../models/recipe.dart';
import '../services/recipe_data_service.dart';
import '../services/favorites_service.dart';
import '../widgets/recipe_card.dart';
import '../widgets/app_drawer.dart';
import '../widgets/assistive_touch.dart'; // ADD THIS
import '../widgets/sdg_popup.dart'; // ADD THIS
import '../screens/profile_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/create_recipe_screen.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static const String _sdgPopupSeenKey = 'sdg_popup_seen';

  late AnimationController _animationController;
  List<Recipe> _displayedRecipes = RecipeDataService.recipes;
  String _selectedCategory = 'All';
  String _currentPage = 'home';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();

    FavoritesService.initializeDemoFavorites();

    // Check if this is first login and show popup
    _checkAndShowSDGPopup();
  }

  /// Check if SDG popup has been shown before, if not show it automatically
  Future<void> _checkAndShowSDGPopup() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenPopup = prefs.getBool(_sdgPopupSeenKey) ?? false;

    if (!hasSeenPopup && mounted) {
      // Wait a bit for the screen to fully load
      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        // Mark as seen
        await prefs.setBool(_sdgPopupSeenKey, true);

        // Show popup
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => const SDGPopup(),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _filterRecipesByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _displayedRecipes = RecipeDataService.getRecipesByCategory(category);
    });
  }

  void _onPageSelected(String page) {
    if (_currentPage != 'home') {
      setState(() {
        _currentPage = 'home';
      });
    }

    switch (page) {
      case 'profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        ).then((_) {
          setState(() {
            _currentPage = 'home';
          });
        });
        break;
      case 'favorites':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritesScreen()),
        ).then((_) {
          setState(() {
            _currentPage = 'home';
          });
        });
        break;
      case 'settings':
        _showSnackBar('Settings page coming soon!');
        break;
      default:
        setState(() {
          _currentPage = 'home';
        });
        break;
    }
  }

  void _navigateToCreateRecipe() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateRecipeScreen()),
    ).then((_) {
      setState(() {
        _displayedRecipes = RecipeDataService.getRecipesByCategory(_selectedCategory);
      });
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: AppTheme.fontFamily)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(
                text: 'flavorful',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: '.',
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary),
              onPressed: () => _showSnackBar('Search feature coming soon!'),
            ),
          ),
        ],
      ),

      drawer: AppDrawer(
        currentPage: _currentPage,
        onPageSelected: _onPageSelected,
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _navigateToCreateRecipe,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(Icons.add, size: 24),
          label: const Text(
            'Create',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildCategoryFilter()),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: _buildAnimatedRecipeList(),
              ),
            ],
          ),

          // ADD ASSISTIVE TOUCH BUTTON
          const AssistiveTouch(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return FutureBuilder<UserModel?>(
      future: _getUserData(),
      builder: (context, snapshot) {
        String displayName = 'there';

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          displayName = snapshot.data!.displayName;
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                  children: [
                    const TextSpan(
                      text: 'What are we cooking\ntoday, ',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    TextSpan(
                      text: displayName,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text: '?',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'From verified chefs around the world!',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<UserModel?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final authService = AuthService();
      return await authService.getUserData(user.uid);
    }
    return null;
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: RecipeDataService.categories.length,
        itemBuilder: (context, index) {
          final category = RecipeDataService.categories[index];
          final isSelected = _selectedCategory == category;

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(
                category,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) => _filterRecipesByCategory(category),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              elevation: isSelected ? 4 : 2,
              shadowColor: AppColors.primary.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedRecipeList() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    index * 0.1,
                    1.0,
                    curve: Curves.easeOutCubic,
                  ),
                )),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      index * 0.1,
                      1.0,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: RecipeCard(recipe: _displayedRecipes[index]),
                ),
              );
            },
            childCount: _displayedRecipes.length,
          ),
        );
      },
    );
  }
}