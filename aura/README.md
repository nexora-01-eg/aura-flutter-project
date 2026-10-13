# AURA — Discipline Creates Freedom 🖤✨

A luxury cinematic dark productivity OS built in Flutter.

## ⚡ Quick Setup (5 minutes)

### 1. Prerequisites
Make sure you have Flutter installed:
```bash
flutter --version  # needs 3.0+
```

### 2. Install Dependencies
```bash
cd aura
flutter pub get
```

### 3. Run on Device/Emulator
```bash
# Android
flutter run

# iOS
flutter run -d ios

# Chrome (web preview)
flutter run -d chrome
```

---

## 📁 Project Structure

```
lib/
├── main.dart                        # Entry point + Hive init
├── core/
│   ├── router.dart                  # GoRouter navigation
│   └── theme/
│       └── app_theme.dart           # Colors, typography, design tokens
├── features/
│   ├── splash/
│   │   └── splash_screen.dart       # Cinematic animated splash
│   ├── onboarding/
│   │   └── onboarding_screen.dart   # 3-slide emotional onboarding
│   ├── dashboard/
│   │   ├── main_shell.dart          # Bottom nav shell
│   │   └── dashboard_screen.dart    # Home dashboard
│   ├── tasks/
│   │   └── tasks_screen.dart        # Task management + XP
│   ├── habits/
│   │   └── habits_screen.dart       # Habit tracker + heatmap
│   ├── focus/
│   │   └── focus_screen.dart        # Pomodoro deep focus mode
│   └── stats/
│       └── stats_screen.dart        # Analytics + badges
```

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Background | `#000000` |
| Surface | `#111111` |
| Gold | `#E8BD70` |
| Gold 2 | `#EDD185` |
| Gold 3 | `#F5CB86` |
| Text | `#F0EDE8` |

---

## 📦 Packages Used

| Package | Purpose |
|---------|---------|
| `flutter_animate` | Cinematic animations |
| `fl_chart` | Bar, radar charts |
| `flutter_riverpod` | State management |
| `go_router` | Navigation |
| `hive_flutter` | Local offline database |
| `shared_preferences` | Settings persistence |
| `google_fonts` | Inter font |
| `flutter_staggered_animations` | List stagger effects |
| `awesome_notifications` | Local notifications |

---

## 🔧 What to Customize

1. **User name** → `dashboard_screen.dart` line with `'Alex'`
2. **Daily quote** → `dashboard_screen.dart` `_buildQuote()`
3. **Tasks** → `tasks_screen.dart` `_tasks` list
4. **Habits** → `habits_screen.dart` `_habits` list
5. **Pomodoro time** → `focus_screen.dart` `_totalSeconds`
6. **Colors** → `app_theme.dart` `AuraColors`

---

## 🚀 Next Steps (Phase 2)

- [ ] Hive persistent storage for tasks & habits
- [ ] Riverpod state providers
- [ ] Local notifications (awesome_notifications)
- [ ] Lottie animations for splash
- [ ] Dopamine Detox Mode
- [ ] Daily Aura Report screen
- [ ] Settings screen

---

**AURA** — *The Operating System for Disciplined People.*
