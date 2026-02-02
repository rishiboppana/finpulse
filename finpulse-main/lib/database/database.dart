import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// DAO imports
import 'daos/transaction_dao.dart';
import 'daos/user_response_dao.dart';
import 'daos/custom_category_dao.dart';
import 'daos/merchant_dao.dart';
import 'daos/budget_dao.dart';
import 'daos/insight_dao.dart';
import 'daos/chat_dao.dart';
import 'daos/preference_dao.dart';

// Generated code
part 'database.g.dart';

/// FinPulse SQLite Database using Drift ORM
/// 
/// Tables:
/// 1. transactions - Core transaction data
/// 2. user_responses - Natural language categorization responses
/// 3. custom_categories - User-defined categories
/// 4. merchants - Learned merchant mappings
/// 5. budgets - Spending limits
/// 6. insights - AI-generated insights cache
/// 7. chat_messages - Conversation history
/// 8. accounts - Linked bank accounts
/// 9. preferences - App settings

// ============================================================================
// TABLE DEFINITIONS
// ============================================================================

/// Core transaction table with de-duplication support
class Transactions extends Table {
  // Primary key
  TextColumn get id => text()();
  
  // De-duplication fingerprint (hash of amount + merchant + timestamp + account)
  TextColumn get fingerprint => text().nullable()();
  
  // Amount & Currency
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  
  // Timing (all preserved for de-duplication)
  IntColumn get timestamp => integer()(); // Unix epoch of transaction
  IntColumn get detectedAt => integer()(); // When we detected it
  TextColumn get rawDate => text().nullable()(); // Original date string
  TextColumn get rawTime => text().nullable()(); // Original time string
  
  // Source Info
  TextColumn get source => text()(); // sms, notification, accessibility, manual, receipt
  TextColumn get rawText => text()(); // Original SMS/notification text
  
  // Account Info
  TextColumn get accountId => text().nullable()();
  TextColumn get accountLastDigits => text().nullable()();
  
  // Merchant Info
  TextColumn get rawMerchantId => text().nullable()(); // Original cryptic string
  TextColumn get normalizedMerchantId => text().nullable()(); // Normalized for matching
  TextColumn get merchantName => text().nullable()(); // Display name
  
  // Classification
  TextColumn get category => text().nullable()();
  BoolColumn get isCustomCategory => boolean().withDefault(const Constant(false))();
  TextColumn get subcategory => text().nullable()(); // Gemini-suggested
  
  // Transaction Type
  TextColumn get type => text()(); // debit, credit, unknown
  
  // Status Flags
  BoolColumn get isCategorized => boolean().withDefault(const Constant(false))();
  BoolColumn get isParsedByAi => boolean().withDefault(const Constant(false))();
  
  // Metadata
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// User responses for Gemini learning
/// Stores natural language inputs and AI interpretations
class UserResponses extends Table {
  // Auto-increment ID
  IntColumn get id => integer().autoIncrement()();
  
  // Link to transaction
  TextColumn get transactionId => text().references(Transactions, #id)();
  
  // What AI suggested (before user input)
  TextColumn get aiSuggestions => text().nullable()(); // JSON array
  
  // RAW USER INPUT
  TextColumn get inputMethod => text()(); // tap, voice, text
  TextColumn get rawInput => text().nullable()(); // Exactly what user said/typed
  TextColumn get voiceTranscript => text().nullable()(); // Raw speech-to-text
  RealColumn get voiceConfidence => real().nullable()(); // Speech recognition confidence
  
  // GEMINI INTERPRETATION
  TextColumn get geminiInterpretation => text().nullable()(); // What Gemini understood
  TextColumn get geminiCategory => text().nullable()(); // Category Gemini mapped to
  TextColumn get geminiSubcategory => text().nullable()(); // Optional subcategory
  RealColumn get geminiConfidence => real().nullable()(); // 0.0 to 1.0
  TextColumn get geminiReasoning => text().nullable()(); // Why this category
  
  // FINAL RESULT
  TextColumn get finalCategory => text()(); // What was actually applied
  BoolColumn get isCustomCategory => boolean().withDefault(const Constant(false))();
  BoolColumn get userConfirmed => boolean().withDefault(const Constant(true))();
  TextColumn get userCorrection => text().nullable()(); // If user corrected
  
  // CONTEXT FOR LEARNING
  TextColumn get merchantAtTime => text().nullable()();
  RealColumn get amountAtTime => real().nullable()();
  
  // Timing
  IntColumn get responseTimeMs => integer().nullable()(); // How long before responded
  IntColumn get interpretedAt => integer().nullable()(); // When Gemini processed
  IntColumn get confirmedAt => integer().nullable()(); // When user confirmed
  IntColumn get createdAt => integer()();
}

/// User-defined custom categories
class CustomCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // Category Info
  TextColumn get name => text().unique()(); // Internal name
  TextColumn get displayName => text()(); // Can be renamed
  TextColumn get emoji => text().nullable()();
  TextColumn get color => text().nullable()(); // Hex color
  
  // Purpose
  TextColumn get description => text().nullable()(); // "Track wedding expenses"
  
  // Learning keywords (updated by Gemini)
  TextColumn get learnedKeywords => text().nullable()(); // JSON array
  TextColumn get learnedMerchants => text().nullable()(); // JSON array
  
  // Stats
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  IntColumn get lastUsedAt => integer().nullable()();
  
  // Metadata
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

/// Learned merchant mappings
class Merchants extends Table {
  // Normalized merchant ID as primary key
  TextColumn get id => text()();
  TextColumn get rawId => text()(); // Original cryptic string
  
  // Category
  TextColumn get category => text().nullable()();
  BoolColumn get isCustomCategory => boolean().withDefault(const Constant(false))();
  
  // Display
  TextColumn get friendlyName => text().nullable()();
  
  // Learning stats
  IntColumn get timesCategorized => integer().withDefault(const Constant(0))();
  TextColumn get lastCategoryCounts => text().nullable()(); // JSON: {"Food": 5, "Coffee": 2}
  
  // Usage
  IntColumn get usageCount => integer().withDefault(const Constant(1))();
  RealColumn get totalSpent => real().withDefault(const Constant(0.0))();
  IntColumn get lastUsedAt => integer().nullable()();
  IntColumn get learnedAt => integer()();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// User budget limits
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  TextColumn get category => text()();
  BoolColumn get isCustomCategory => boolean().withDefault(const Constant(false))();
  TextColumn get period => text()(); // daily, weekly, monthly
  RealColumn get amount => real()();
  
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  
  @override
  List<Set<Column>> get uniqueKeys => [{category, period}];
}

/// AI-generated insights cache
class Insights extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  TextColumn get type => text()(); // spending_alert, trend, anomaly, tip, goal
  TextColumn get title => text()();
  TextColumn get subtitle => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get category => text().nullable()();
  
  // Validity
  IntColumn get generatedAt => integer()();
  IntColumn get expiresAt => integer().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();
  
  // Context for regeneration
  TextColumn get dataJson => text().nullable()();
}

/// Chat conversation history
class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  TextColumn get content => text()();
  BoolColumn get isUser => boolean()();
  IntColumn get timestamp => integer()();
  
  // Context used for AI response
  TextColumn get contextJson => text().nullable()();
}

/// Linked bank accounts
class Accounts extends Table {
  TextColumn get id => text()();
  
  TextColumn get accountName => text()();
  TextColumn get institutionId => text()();
  TextColumn get institutionName => text()();
  TextColumn get maskedNumber => text()();
  TextColumn get accountType => text()(); // savings, current, credit
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// App preferences (key-value store)
class Preferences extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  IntColumn get updatedAt => integer()();
  
  @override
  Set<Column> get primaryKey => {key};
}

// ============================================================================
// DATABASE CLASS
// ============================================================================

@DriftDatabase(
  tables: [
    Transactions,
    UserResponses,
    CustomCategories,
    Merchants,
    Budgets,
    Insights,
    ChatMessages,
    Accounts,
    Preferences,
  ],
  daos: [
    TransactionDao,
    UserResponseDao,
    CustomCategoryDao,
    MerchantDao,
    BudgetDao,
    InsightDao,
    ChatDao,
    PreferenceDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  // For testing with in-memory database
  AppDatabase.forTesting(super.e);
  
  // Database version - increment when schema changes
  @override
  int get schemaVersion => 1;
  
  // Singleton instance
  static AppDatabase? _instance;
  static AppDatabase get instance {
    _instance ??= AppDatabase();
    return _instance!;
  }
  
  // Reset singleton (for testing)
  static void resetInstance() {
    _instance = null;
  }
  
  // DAO Accessors - use @override since they're generated in _$AppDatabase
  @override
  TransactionDao get transactionDao => TransactionDao(this);
  @override
  UserResponseDao get userResponseDao => UserResponseDao(this);
  @override
  CustomCategoryDao get customCategoryDao => CustomCategoryDao(this);
  @override
  MerchantDao get merchantDao => MerchantDao(this);
  @override
  BudgetDao get budgetDao => BudgetDao(this);
  @override
  InsightDao get insightDao => InsightDao(this);
  @override
  ChatDao get chatDao => ChatDao(this);
  @override
  PreferenceDao get preferenceDao => PreferenceDao(this);

  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
        // Example for future:
        // if (from < 2) {
        //   await m.addColumn(transactions, transactions.newColumn);
        // }
      },
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
  
  /// Close the database
  Future<void> closeDatabase() async {
    await close();
    _instance = null;
  }
}

/// Open database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'finpulse.db'));
    return NativeDatabase.createInBackground(file);
  });
}
