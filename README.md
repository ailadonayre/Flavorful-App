# flavorful. 🍽️

A beautiful recipe sharing app built with Flutter, featuring verified chefs from around the world sharing their authentic culinary creations.

## 📱 Features

### ✨ Core Features
- **Recipe Discovery** - Browse authentic recipes from verified chefs worldwide
- **Category Filtering** - Explore by cuisine type (Italian, Japanese, Korean, Healthy, Desserts)
- **Favorites System** - Save and organize your favorite recipes
- **Chef Profiles** - View detailed profiles with follower counts and verification badges
- **Recipe Creation** - Create and share your own culinary masterpieces
- **Detailed Instructions** - Step-by-step cooking instructions with ingredients list

### 🎨 UI/UX Highlights
- **Modern Design** - Clean, contemporary interface with smooth animations
- **Orange Brand Theme** - Consistent warm color palette throughout the app
- **Responsive Layout** - Optimized for various screen sizes
- **Intuitive Navigation** - Easy-to-use drawer navigation with visual indicators
- **Interactive Elements** - Smooth transitions and engaging micro-animations

### 👨‍🍳 Chef Features
- **Verified Badges** - Distinguished verified chef accounts
- **Profile Statistics** - Follower counts, recipe counts, and engagement metrics
- **Recipe Management** - Create, edit, and manage personal recipe collections

## 🛠️ Technical Stack

### Frontend
- **Flutter** - Cross-platform mobile development framework
- **Dart** - Programming language
- **Material Design** - Google's design system implementation

### Architecture
- **MVVM Pattern** - Model-View-ViewModel architecture
- **Service Layer** - Separated business logic and data management
- **Widget Composition** - Modular, reusable UI components

### Key Libraries & Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

## 📂 Project Structure

```
lib/
├── config/
│   └── app_theme.dart          # App colors, themes, and styling constants
├── models/
│   ├── recipe.dart             # Recipe data model
│   └── user.dart               # User/Chef data model
├── screens/
│   ├── home_screen.dart        # Main discovery screen
│   ├── profile_screen.dart     # User profile and recipe management
│   ├── favorites_screen.dart   # Saved recipes collection
│   ├── recipe_detail_screen.dart # Individual recipe view
│   └── create_recipe_screen.dart # Recipe creation form
├── services/
│   ├── recipe_data_service.dart # Recipe data management
│   └── favorites_service.dart   # Favorites functionality
├── widgets/
│   ├── recipe_card.dart        # Recipe display component
│   ├── app_drawer.dart         # Navigation drawer
│   ├── category_filter.dart    # Category selection widget
│   └── common_widgets.dart     # Reusable UI components
└── main.dart                   # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=2.19.0 <4.0.0)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/flavorful.git
cd flavorful
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Add assets**
   Make sure you have the following directories:
```
assets/
├── img/          # Recipe images
└── fonts/        # Montserrat font files
```

4. **Run the app**
```bash
flutter run
```

### Build for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📸 Screenshots

| Home Screen | Recipe Details | Profile |
|-------------|---------------|---------|
| *Recipe discovery with category filters* | *Detailed cooking instructions* | *Chef profile and statistics* |

| Favorites | Create Recipe | Navigation |
|-----------|--------------|------------|
| *Saved recipe collection* | *Recipe creation form* | *Beautiful drawer navigation* |

## 🎯 Key Features Breakdown

### Recipe Discovery
- **Smart Filtering** - Filter by cuisine, difficulty, cooking time
- **Beautiful Cards** - Rich recipe cards with images, ratings, and chef info
- **Quick Actions** - One-tap favorites, easy navigation to details

### Recipe Details
- **Comprehensive Info** - Cooking time, servings, difficulty, ingredients
- **Step-by-Step** - Numbered instructions with clear formatting
- **Chef Integration** - Direct access to chef profiles and social stats

### User Experience
- **Smooth Animations** - Engaging transitions and micro-interactions
- **Consistent Theming** - Unified orange brand color throughout
- **Intuitive Navigation** - Clear visual hierarchy and navigation patterns

## 🔧 Development Highlights

### Custom Widgets
- **RecipeCard** - Reusable recipe display component with animations
- **StatChip** - Elegant info chips for recipe metadata
- **UserInfo** - Consistent chef information display

### State Management
- **StatefulWidgets** - Local state management for UI interactions
- **Service Classes** - Centralized data management
- **Controller Pattern** - Text input and form handling

### Styling System
- **AppColors** - Centralized color palette
- **AppTheme** - Consistent typography and styling
- **Material Design** - Following Google's design guidelines

## 🚦 Current Status

### ✅ Completed Features
- Recipe browsing and filtering
- Detailed recipe views
- Favorites system
- User profiles
- Recipe creation UI
- Navigation system

### 🚧 In Development
- Backend integration
- User authentication
- Recipe upload functionality
- Social features (comments, ratings)
- Search functionality

### 📋 Roadmap
- [ ] User registration and login
- [ ] Real-time recipe sharing
- [ ] Advanced search and filters
- [ ] Social interactions (likes, comments)
- [ ] Recipe recommendations
- [ ] Offline recipe access
- [ ] Shopping list integration
- [ ] Video recipe support

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart best practices
- Maintain consistent code formatting
- Add comments for complex logic
- Test on both iOS and Android
- Follow the existing architectural patterns

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Authors

- **John Alcaraz**
- **John Timothy Carranza**
- **Aila Roshiele Donayre**
- **Paul Raimiel Gonda**
- **Kent Ian Ramirez**
- **Irish Rivera**

## 🙏 Acknowledgments

- Montserrat font family for beautiful typography
- Material Design for UI/UX inspiration
- Flutter community for excellent documentation and support
- Food photography contributors for recipe images

---

Made with ❤️ for food lovers everywhere

*Bringing authentic flavors from around the world to your kitchen* 🌍👨‍🍳