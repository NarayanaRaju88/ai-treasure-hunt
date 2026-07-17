# AI Treasure Hunt - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites
- Flutter installed (3.x or later)
- Dart installed (3.x or later)
- Git installed
- A code editor (VS Code or Android Studio)

### Step 1: Clone Repository

```bash
git clone https://github.com/NarayanaRaju88/ai-treasure-hunt.git
cd ai-treasure-hunt
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Configure Firebase

```bash
flutterfire configure
```

Select your Firebase project and platforms.

### Step 4: Add API Keys

1. Copy `.env.example` to `.env.development`
2. Add your API keys:
   - Google Maps API Key
   - Gemini API Key
   - Firebase credentials

### Step 5: Run the App

```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d web
```

## 📚 Project Structure

```
ai-treasure-hunt/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── presentation/                # UI layer
│   ├── domain/                      # Business logic
│   ├── data/                        # Data layer
│   ├── core/                        # Core utilities
│   ├── config/                      # Configuration
│   └── services/                    # External services
├── test/                            # Tests
├── pubspec.yaml                     # Dependencies
└── README.md                        # Documentation
```

## 🎮 Features Overview

### Authentication
- Google Sign-In
- Email/Password
- Guest Login

### Core Features
- Daily AI-generated treasures
- Interactive maps
- User profiles
- Gamification (XP, levels, achievements)

### AI Integration
- Gemini API for treasure generation
- Natural language search
- Fun facts generation

## 📖 Documentation

- **[README.md](README.md)** - Full project overview
- **[SETUP.md](SETUP.md)** - Detailed setup instructions
- **[API_REFERENCE.md](API_REFERENCE.md)** - API documentation
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines
- **[ROADMAP.md](ROADMAP.md)** - Future features
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Release process

## 🛠️ Development Commands

```bash
# Format code
dart format lib/

# Analyze code
dart analyze

# Run tests
flutter test

# Clean build
flutter clean

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

## 🐛 Debugging

### Enable Verbose Output
```bash
flutter run -v
```

### Launch DevTools
```bash
dart devtools
```

### View Logs
```bash
flutter logs
```

## 📱 App Structure

### Authentication Flow
1. Login/Signup Screen
2. Home Screen (Dashboard)
3. Map Screen (Treasure Locations)
4. Discovery Screen (Treasure Details)
5. Profile Screen (User Stats)

### Navigation
Using `go_router` for declarative routing.

## 🎯 First Steps

1. **Explore the code**: Start with `main.dart`
2. **Understand architecture**: Read `README.md`
3. **Check home screen**: `lib/presentation/screens/home/home_screen.dart`
4. **Review providers**: `lib/core/providers/`
5. **Test the app**: Run on device/emulator

## 🤝 Need Help?

- Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Review [SETUP.md](SETUP.md)
- Read [CONTRIBUTING.md](CONTRIBUTING.md)
- Create an issue on GitHub

## 📞 Contact & Support

- GitHub Issues: Report bugs and request features
- Email: maintainer@example.com
- Twitter: @AITreasureHunt

## 🎉 You're Ready!

Start exploring and building amazing features!

---

**Happy Coding! 🚀**
