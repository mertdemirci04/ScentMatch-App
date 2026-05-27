# 🧴 ScentMatch AI - Flutter Mobile App

ScentMatch AI is a comprehensive mobile application designed to serve as a digital fragrance guide and personal library. It eliminates the complexity of navigating scent pyramids by providing an intelligent recommendation engine running entirely on-device.

Powered by a highly optimized local SQLite database containing over **20,000 perfumes**, the application uses the mathematical **Jaccard Similarity Index** to analyze "scent DNA," allowing users to discover highly similar alternatives without needing to physically test them.

---

## ✨ Core Features

* 🔍 **Comprehensive Library:** Search and filter through a massive catalog of 20,000+ perfumes instantly.
* 🤖 **AI Match Algorithm:** Find highly similar fragrance alternatives based on mathematical note comparisons and dynamic score capping.
* ⚖️ **Side-by-Side Comparison:** Visually compare the top, middle, and base notes of any two perfumes, complete with a similarity percentage.
* 📚 **Personal Collection & History:** Curate your own fragrance library, track your browsing history, and get dynamic recommendations based on your favorite raw notes.
* 🌿 **Notes Dictionary:** Explore and learn about individual fragrance notes, saving your favorites for future AI matches.


## 🏗️ Architecture & Tech Stack

The application is built using a strict **Layered Architecture** to ensure clear separation of concerns, high maintainability, and fast performance despite the massive local dataset.

* **Framework:** Flutter / Dart
* **Architecture Pattern:** Layered (Presentation, Domain, Repository, Data)
* **Local Storage:** SQLite (`sqflite`) utilizing batch processing (`txn.batch()`) for lightning-fast 20k+ row initializations.
* **Database Abstraction:** Data Access Objects (DAO) and Repository pattern.
* **State Management:** Provider (`ChangeNotifier`) for localized and global state synchronization.
* **Theme:** Custom Dark Theme (`AppColors.bg`) with Gold Accents (`AppColors.gold`) for a premium feel.

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (Latest Stable Version)
* Dart SDK
* Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   git clone [https://github.com/mertdemirci04/ScentMatch-App.git](https://github.com/mertdemirci04/ScentMatch-App.git)

2. Navigate to the project directory:
  cd ScentMatch-App

3. Install dependencies:
  flutter pub get

4.Run the app:
  flutter run

Note: On the first launch, the app will parse a large CSV file and populate the SQLite database. Thanks to batch processing, this takes only a few seconds.
