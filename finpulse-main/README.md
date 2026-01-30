# FinPulse 💸

**AI-Powered Personal Finance Tracker with Real-Time Transaction Detection**

FinPulse is a Flutter-based personal finance application that leverages native Android services and AI to provide instant transaction detection and intelligent expense categorization.

---

## ✨ Key Features

### 🔔 Real-Time Transaction Detection ("The Detection Stack")
- **Notification Listener**: Monitors financial apps (PhonePe, GPay, Paytm, etc.) for payment notifications.
- **Accessibility Service**: Instant "UI Consciousness Layer" that detects payment success screens.
- **SMS Receiver**: Universal content-first detection — catches ANY bank SMS containing financial keywords (₹, Rs, debited, UPI, etc.).

### ⏱️ The "10-Second Golden Window"
When a transaction is detected, an instant bottom sheet appears allowing you to:
- **Tag the expense** with a category (Food, Groceries, Transport, etc.)
- **Teach the app** — learned merchants are auto-categorized next time!
- **Voice input** (placeholder) for Hinglish expense logging.

### 🧠 Merchant Learning System
- Per-user merchant-to-category mappings stored locally.
- Automatic category pre-fill for recognized merchants.
- "Learned Merchants" screen to view and manage your mappings.

### 🏦 Bank Account Aggregation
- Multi-account dashboard with live balance display.
- Indian bank support (HDFC, ICICI, SBI, Axis, Kotak, etc.).
- Swipeable account cards with category breakdown.

---

## 📁 Project Structure

### `/lib` (Flutter/Dart)

| File | Description |
|------|-------------|
| `main.dart` | App entry point, auth gate, navigation shell, and global Golden Window listener. |
| `models/transaction.dart` | Transaction model with `DetectionSource` enum (SMS, notification, accessibility). |
| `models/bank_account.dart` | Bank account model with Indian bank metadata. |
| `services/transaction_parser.dart` | Universal SMS/notification parser using Regex (+ Gemini Flash fallback). |
| `services/gemini_service.dart` | Mock Gemini AI service for parsing unstructured SMS. |
| `services/merchant_learning_service.dart` | SQLite-backed per-user merchant-to-category learning. |
| `services/notification_service.dart` | Manages Golden Window notifications and pending transaction queue. |
| `services/native_detection_service.dart` | Flutter ↔ Android bridge via MethodChannel. |
| `screens/mock_trigger_screen.dart` | Demo screen to simulate payments + GoldenWindowSheet widget. |
| `screens/detection_settings_screen.dart` | UI to enable Notification Access and Accessibility Service. |
| `screens/learned_merchants_screen.dart` | View/manage learned merchant mappings. |
| `providers/auth_provider.dart` | Authentication state management. |
| `providers/bank_provider.dart` | Bank account state management. |

### `/android` (Kotlin)

| File | Description |
|------|-------------|
| `MainActivity.kt` | Flutter MethodChannel bridge; shares channel with native services. |
| `TransactionNotificationListener.kt` | `NotificationListenerService` monitoring financial apps. |
| `TransactionAccessibilityService.kt` | `AccessibilityService` for instant UI-based detection. |
| `SmsReceiver.kt` | `BroadcastReceiver` with **Content-First** SMS detection (no sender whitelist). |
| `AndroidManifest.xml` | Permissions (SMS, Notifications, Accessibility) and service declarations. |
| `res/xml/accessibility_service_config.xml` | Accessibility service configuration. |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x
- Android Studio with Android SDK 34
- Android Emulator (API 33+) or physical device

### Installation

```bash
# Clone the repository
git clone <repo-url>
cd finpulse-main

# Install dependencies
flutter pub get

# Run on Android Emulator
flutter run -d emulator-5554
```

### Enable Detection Services

1. Open the app and go to **Settings → Developer → Detection Settings**.
2. Enable **Notification Access** → Find FinPulse → Toggle ON.
3. Enable **Accessibility Service** → Downloaded Apps → FinPulse → Toggle ON.
4. (Optional) Grant SMS permissions when prompted.

---

## 🧪 Testing the Demo

### Mock Payment Trigger
1. Go to **Settings → Developer → Mock Payment Trigger**.
2. Tap any sample SMS/notification tile.
3. The **Golden Window** bottom sheet will appear instantly!

### Real SMS Test (Emulator)
1. Open emulator's extended controls (**...**) → **Phone** → **SMS**.
2. Send: `Paid ₹500 to Swiggy on 28-Jan. UPI Ref 123456`.
3. The Golden Window pops up automatically!

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Financial Apps / SMS                      │
└─────────────────────┬───────────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────────────┐
│              Native Detection Layer (Kotlin)                 │
│  ┌───────────────┐ ┌────────────────┐ ┌─────────────────┐   │
│  │ Notification  │ │ Accessibility  │ │  SMS Receiver   │   │
│  │   Listener    │ │    Service     │ │ (Content-First) │   │
│  └───────┬───────┘ └───────┬────────┘ └────────┬────────┘   │
└──────────┼─────────────────┼───────────────────┼────────────┘
           └─────────────────┼───────────────────┘
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                MethodChannel Bridge                          │
└─────────────────────────────┬───────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              Flutter Application Layer                       │
│  ┌───────────────────┐  ┌─────────────────────────────────┐ │
│  │ Universal Parser  │  │     Merchant Learning DB        │ │
│  │ (Regex + Gemini)  │  │        (SQLite + SharedPrefs)   │ │
│  └─────────┬─────────┘  └──────────────┬──────────────────┘ │
│            └──────────────┬────────────┘                    │
│                           ▼                                  │
│            ┌──────────────────────────────┐                 │
│            │  Golden Window Bottom Sheet  │                 │
│            │  (Instant Tag & Learn UI)    │                 │
│            └──────────────────────────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

---

## 📄 License

This project is for demonstration and hackathon purposes.

---

## 🙏 Acknowledgments

- Built for the **Google DeepMind Hackathon**
- Powered by Flutter, Kotlin, and Gemini AI
