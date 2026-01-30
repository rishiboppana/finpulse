import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/bank_account.dart';
import 'models/transaction.dart';
import 'providers/auth_provider.dart';
import 'providers/bank_provider.dart';
import 'screens/login_screen.dart';
import 'screens/mock_trigger_screen.dart';
import 'screens/learned_merchants_screen.dart';
import 'screens/detection_settings_screen.dart';
import 'services/merchant_learning_service.dart';
import 'services/native_detection_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await MerchantLearningService.instance.init();
  await NativeDetectionService.instance.init();
  
  runApp(const FinPulseApp());
}

class FinPulseApp extends StatelessWidget {
  const FinPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF29D6C7); // teal like screenshot
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BankProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: seed),
          scaffoldBackgroundColor: const Color(0xFFF7F8FA),
          cardTheme: const CardThemeData(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
        home: const AuthGate(),
      ),
    );
  }
}

/// Auth gate that shows login or main app based on auth state.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _lastUserId;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        // Still initializing - show splash
        if (auth.status == AuthStatus.initial) {
          return const _SplashScreen();
        }

        // Authenticated - initialize bank provider and show main app
        if (auth.isAuthenticated && auth.user != null) {
          // Initialize bank provider when user logs in
          if (_lastUserId != auth.user!.id) {
            _lastUserId = auth.user!.id;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<BankProvider>().initialize(auth.user!.id);
            });
          }
          return const MainShell();
        }

        // Not authenticated - reset bank provider and show login
        if (_lastUserId != null) {
          _lastUserId = null;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<BankProvider>().reset();
          });
        }
        return const LoginScreen();
      },
    );
  }
}

/// Simple splash screen while checking auth state
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: teal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: 42,
                color: teal,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "FinPulse",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    // Listen for new detections to show Golden Window globally
    NotificationService.instance.addListener(_onNotificationUpdate);
  }

  @override
  void dispose() {
    NotificationService.instance.removeListener(_onNotificationUpdate);
    super.dispose();
  }

  void _onNotificationUpdate() {
    final notifications = NotificationService.instance.pendingNotifications;
    if (notifications.isNotEmpty) {
      final latest = notifications.first;
      // If it's new (< 2 seconds old) and not handled, show the sheet
      if (latest.age.inSeconds < 2 && !latest.isHandled) {
        _showGoldenWindow(latest.transaction);
      }
    }
  }

  void _showGoldenWindow(Transaction transaction) {
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GoldenWindowSheet(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      DashboardScreen(),
      StatsScreen(),
      CategoriesScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: pages[index],
      floatingActionButton: FloatingActionButton(
        onPressed: () => showNewTransactionSheet(context),
        backgroundColor: const Color(0xFF29D6C7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        height: 70,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart),
            label: "Stats",
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: "Categories",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
//Below is the code for Dashboard or Homepage 
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

enum _AccountMode { debit, credit }
enum _ScopeMode { daily, monthly }

class _DashboardScreenState extends State<DashboardScreen> {
  int activeAccountIndex = 0;
  final PageController _acctController = PageController(viewportFraction: 0.92);
  
  // Toggles
  _AccountMode accountMode = _AccountMode.debit;
  _ScopeMode scopeMode = _ScopeMode.daily;

  // Pending (Yet to Transponse) queue - kept mock for now until Transactions implemented
  final List<_PendingTxn> pending = [
    _PendingTxn(accountId: "chase_checking", merchant: "Starbucks Coffee", amount: 5.50, time: "18 Jan • 12:02 PM", to: "YYYY"),
    _PendingTxn(accountId: "chase_checking", merchant: "Whole Foods", amount: 84.20, time: "18 Jan • 02:10 PM", to: "YYYY"),
    _PendingTxn(accountId: "chase_checking", merchant: "Shell Gas Station", amount: 42.10, time: "18 Jan • 07:30 AM", to: "YYYY"),
    _PendingTxn(accountId: "amex_credit", merchant: "Amazon", amount: 29.99, time: "17 Jan • 08:12 PM", to: "YYYY"),
    _PendingTxn(accountId: "ally_savings", merchant: "Target", amount: 64.20, time: "17 Jan • 05:40 PM", to: "YYYY"),
  ];

  // Fake category breakdown for the top mini-bars
  final List<_MiniCatBar> miniBars = const [
    _MiniCatBar(label: "Food", value: 0.75),
    _MiniCatBar(label: "Bills", value: 0.35),
    _MiniCatBar(label: "Fuel", value: 0.55),
  ];

  // Insights (Home-only) - Restored
  final List<_InsightData> homeInsights = const [
    _InsightData(
      icon: Icons.coffee_rounded,
      iconBg: Color(0xFFFFF1E7),
      iconColor: Color(0xFFF97316),
      title: "You spent 15% more on Coffee today than your average.",
      subtitle: "That’s about \$2–\$5 extra.",
    ),
    _InsightData(
      icon: Icons.check_circle_rounded,
      iconBg: Color(0xFFE9FFF9),
      iconColor: Color(0xFF10B981),
      title: "Nice! You’re under today’s target.",
      subtitle: "Keep it up to hit your weekly goal.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Consumer<BankProvider>(
          builder: (context, bank, _) {
            // Get accounts based on toggle (Debit=Savings/Current, Credit=CreditCard)
            final allAccounts = bank.accounts;
            
            // Construct display list
            final displayList = <dynamic>[
              {'id': 'all', 'title': 'All Accounts', 'subtitle': 'Aggregated', 'balance': bank.totalBalance, 'formatted': bank.formattedTotalBalance},
              ...allAccounts.map((a) => {
                'id': a.id,
                'title': a.accountName,
                'subtitle': "${a.institutionName} • ${a.maskedNumber}",
                'balance': a.balance,
                'formatted': a.formattedBalance,
                'institutionId': a.institutionId,
              })
            ];

            // Safety check for index
            if (activeAccountIndex >= displayList.length) {
              activeAccountIndex = 0;
            }

            // Calculate visible pending transactions based on active account
            final activeAccountId = displayList[activeAccountIndex]['id'] as String;
            final visiblePending = activeAccountId == 'all' 
                ? pending 
                : pending.where((x) => x.accountId == activeAccountId).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar: avatar, title, bell
                Row(
                  children: [
                    _RoundIcon(
                      icon: Icons.person,
                      onTap: () => showProfileSideSheet(context),
                    ),
                    const Spacer(),
                    Text(
                      "Dashboard",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                    const Spacer(),
                    _RoundIcon(icon: Icons.notifications_none_rounded, onTap: () {}),
                  ],
                ),

                const SizedBox(height: 14),

                // Debit / Daily toggle row
                Row(
                  children: [
                    _PillToggle(
                      label: "Accounts",
                      selected: accountMode == _AccountMode.debit,
                      onTap: () => setState(() => accountMode = _AccountMode.debit),
                    ),
                    const SizedBox(width: 10),
                    // Hidden for now since we don't differentiate yet
                    // _PillToggle(label: "Credit", ...),
                    const Spacer(),
                    // scopeMode helps switch between Spend vs Balance display?
                    // For now, let's stick to Balance since we have that real data
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF2F6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        "Live Balance",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: muted),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // HERO (swipeable across accounts)
                SizedBox(
                  height: 210,
                  child: PageView.builder(
                    controller: _acctController,
                    itemCount: displayList.length,
                    onPageChanged: (i) => setState(() => activeAccountIndex = i),
                    itemBuilder: (_, i) {
                      final item = displayList[i];
                      final isAll = i == 0;
                      
                      // Get bank color if individual account
                      Color accentColor = const Color(0xFFE9FFF9);
                      if (!isAll) {
                        final meta = IndianBanks.getById(item['institutionId']);
                        if (meta != null) {
                          accentColor = Color(meta.color).withOpacity(0.08);
                        }
                      }

                      return Padding(
                        padding: EdgeInsets.only(right: i == displayList.length - 1 ? 0 : 12),
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                // Left: account label + balance
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          color: textDark,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['subtitle'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: muted,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),

                                      const SizedBox(height: 14),

                                      Text(
                                        "Available Funds",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: muted,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      FittedBox(
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          item['formatted'],
                                          style: TextStyle(
                                            fontSize: 34,
                                            fontWeight: FontWeight.w900,
                                            color: textDark,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: teal.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.trending_up, size: 18, color: teal),
                                            const SizedBox(width: 6),
                                            const Text(
                                              "Updated just now", 
                                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11), // Updated style
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // Right: mini bars (Mocked for now)
                                SizedBox(
                                  width: 130,
                                  child: _MiniCategoryBars(bars: miniBars),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // dots indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(displayList.length, (i) {
                    final active = i == activeAccountIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: active ? 18 : 7,
                      height: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: active ? teal : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),

            const SizedBox(height: 18),

            // Yet to Transponse (pending queue)
            Row(
              children: [
                Text(
                  "Yet to Transponse",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark),
                ),
                const Spacer(),
                Text(
                  "${visiblePending.length} pending",
                  style: TextStyle(color: muted, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (visiblePending.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "All caught up. No pending transactions.",
                          style: TextStyle(color: textDark, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      for (int i = 0; i < (visiblePending.length > 3 ? 3 : visiblePending.length); i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _PendingDismissTile(
                            txn: visiblePending[i],
                            onCategorize: () => _categorizeTxn(visiblePending[i]),
                            onSnooze: () => _snoozeTxn(visiblePending[i]),
                          ),
                        ),
                      if (visiblePending.length > 3)
                        InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => _showAllPending(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: teal.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              "Show ${visiblePending.length - 3} more",
                              style: TextStyle(color: teal, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 18),

            // A little help! (swipeable Yes/No prompt)
            Row(
              children: [
                Text(
                  "A little help!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark),
                ),
                const Spacer(),
                Text(
                  "Swipe",
                  style: TextStyle(color: muted, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 10),

            _QuickConfirmCarousel(
              items: visiblePending.take(5).toList(),
              onConfirm: (txn) => _saveCategory(txn, "Groceries"),
              onEdit: (txn) => _categorizeTxn(txn), // opens rename + category sheet
            ),


            const SizedBox(height: 18),

            // Daily Target vs Usage (two donuts) on HOME
            _BudgetVsActualCard(
              title: "Target vs Actual",
              rows: const [
                _BudgetActualRow(label: "Food", budget: 35, actual: 42),
                _BudgetActualRow(label: "Bills", budget: 30, actual: 28),
                _BudgetActualRow(label: "Fuel", budget: 20, actual: 18),
                _BudgetActualRow(label: "Shopping", budget: 15, actual: 22),
              ],
              footer: "You’re over on Shopping. Under on Bills & Fuel.",
            ),

            const SizedBox(height: 18),

            // Insights Today (Home-only)
            Row(
              children: [
                Text(
                  "Insights Today",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Later: navigate to full insights
                  },
                  child: Text("View All", style: TextStyle(color: teal, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...homeInsights.map((x) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _InsightCard(data: x),
                )),

            const SizedBox(height: 12),

            // Today's Transactions list (with category chip like your sketch)
            Text(
              "Today’s Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark),
            ),
            const SizedBox(height: 10),

            _TodayTxnRow(time: "12:02 PM", merchant: "Starbucks Coffee", amount: "-\$5.50", category: "FOOD"),
            const SizedBox(height: 12),
            _TodayTxnRow(time: "02:10 PM", merchant: "PG&E", amount: "-\$120.00", category: "BILLS"),
            const SizedBox(height: 12),
            _TodayTxnRow(
              time: "04:30 PM",
              merchant: "Unknown Merchant",
              amount: "-\$18.40",
              category: "UNCATEGORIZED",
              onFix: () {
                if (visiblePending.isNotEmpty) _categorizeTxn(visiblePending.first);
              },
            ),

            const SizedBox(height: 90),
          ],
        );
      },
    ),
      ),
    );
  }
  
  Future<void> _categorizeTxn(_PendingTxn txn) async {
    final result = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (_) => _ConfirmBottomSheet(merchant: txn.merchant),
  );

  if (result != null && mounted) {
    final parts = result.split("|||");
    final newName = parts.first;
    final category = parts.length > 1 ? parts[1] : "Other";

    setState(() {
      // ✅ If you want, store the renamed label on the txn in your model later
      pending.remove(txn);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Saved: $newName → $category")),
    );
  }
  }

  void _saveCategory(_PendingTxn txn, String category) {
    setState(() {
      pending.remove(txn);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Saved: ${txn.merchant} → $category")),
    );
  }

  void _snoozeTxn(_PendingTxn txn) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Snoozed: ${txn.merchant}")),
    );
  }

  Future<void> _showAllPending() async {
    final teal = const Color(0xFF29D6C7);
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
          children: [
            const Text("All Pending", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            for (final x in List<_PendingTxn>.from(pending))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PendingDismissTile(
                  txn: x,
                  onCategorize: () => _categorizeTxn(x),
                  onSnooze: () => _snoozeTxn(x),
                  accent: teal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BudgetActualRow {
  final String label;
  final double budget;
  final double actual;

  const _BudgetActualRow({
    required this.label,
    required this.budget,
    required this.actual,
  });
}

class _BudgetVsActualCard extends StatelessWidget {
  final String title;
  final List<_BudgetActualRow> rows;
  final String footer;

  const _BudgetVsActualCard({
    required this.title,
    required this.rows,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    // scale to the max value so bars look proportional
    final maxV = rows.fold<double>(0, (m, r) => [
          m,
          r.budget,
          r.actual,
        ].reduce((a, b) => a > b ? a : b));

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark)),
            const SizedBox(height: 12),

            // header labels
            Row(
              children: [
                const SizedBox(width: 92),
                Expanded(
                  child: Text("Budget", style: TextStyle(color: muted, fontWeight: FontWeight.w800)),
                ),
                Expanded(
                  child: Text("Actual", style: TextStyle(color: muted, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            for (final r in rows) ...[
              _BudgetVsActualRowView(row: r, maxV: maxV),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 2),
            Text(footer, style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _BudgetVsActualRowView extends StatelessWidget {
  final _BudgetActualRow row;
  final double maxV;

  const _BudgetVsActualRowView({
    required this.row,
    required this.maxV,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final budgetColor = const Color(0xFFCBD5E1); // soft gray
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    double w(double v) => (v / (maxV == 0 ? 1 : maxV)).clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 92,
          child: Text(
            row.label,
            style: TextStyle(color: muted, fontWeight: FontWeight.w900),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Budget bar
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2F6),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              FractionallySizedBox(
                widthFactor: w(row.budget),
                child: Container(
                  height: 22,
                  decoration: BoxDecoration(
                    color: budgetColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "\$${row.budget.toStringAsFixed(0)}",
                    style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Actual bar
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2F6),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              FractionallySizedBox(
                widthFactor: w(row.actual),
                child: Container(
                  height: 22,
                  decoration: BoxDecoration(
                    color: teal,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "\$${row.actual.toStringAsFixed(0)}",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class _PendingTxn {
  final String accountId;
  final String merchant;
  final double amount;
  final String time;
  final String to;

  const _PendingTxn({
    required this.accountId,
    required this.merchant,
    required this.amount,
    required this.time,
    required this.to,
  });
}

class _MiniCatBar {
  final String label;
  final double value; // 0..1
  const _MiniCatBar({required this.label, required this.value});
}

class _PillToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PillToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final border = const Color(0xFFE5E7EB);

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? teal : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? teal : border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _MiniCategoryBars extends StatelessWidget {
  final List<_MiniCatBar> bars;
  const _MiniCategoryBars({required this.bars});

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final muted = const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Top categories", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
        const SizedBox(height: 10),
        for (final b in bars)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ClipRect(
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Text(
                      b.label,
                      style: TextStyle(color: muted, fontWeight: FontWeight.w800, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF2F6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: b.value.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: teal.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _PendingDismissTile extends StatelessWidget {
  final _PendingTxn txn;
  final VoidCallback onCategorize;
  final VoidCallback onSnooze;
  final Color? accent;

  const _PendingDismissTile({
    required this.txn,
    required this.onCategorize,
    required this.onSnooze,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final teal = accent ?? const Color(0xFF29D6C7);
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return Dismissible(
      key: ValueKey("${txn.merchant}-${txn.time}-${txn.amount}"),
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: teal.withOpacity(0.16),
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRect(
          child: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: teal),
              const SizedBox(width: 10),
              Flexible(
                child: Text("Categorize", style: TextStyle(color: teal, fontWeight: FontWeight.w900), overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
      secondaryBackground: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: const Color(0xFFF43F5E).withOpacity(0.10),
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRect(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.snooze_rounded, color: Color(0xFFF43F5E)),
              const SizedBox(width: 10),
              Flexible(
                child: Text("Later", style: const TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.w900), overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onCategorize();
          return false; // keep item until user saves
        } else {
          onSnooze();
          return false;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.help_outline_rounded, color: Color(0xFF334155)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(txn.merchant, style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(txn.time, style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("-\$${txn.amount.toStringAsFixed(2)}", style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onCategorize,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text("Fix", style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickConfirmCarousel extends StatefulWidget {
  final List<_PendingTxn> items;
  final void Function(_PendingTxn) onConfirm;
  final void Function(_PendingTxn) onEdit;

  const _QuickConfirmCarousel({
    required this.items,
    required this.onConfirm,
    required this.onEdit,
  });

  @override
  State<_QuickConfirmCarousel> createState() => _QuickConfirmCarouselState();
}

class _QuickConfirmCarouselState extends State<_QuickConfirmCarousel> {
  final PageController _pc = PageController(viewportFraction: 0.92);
  int page = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final teal = const Color(0xFF29D6C7);

    return Column(
      children: [
        SizedBox(
          height: 150, // fixed height prevents bottom overflow
          child: PageView.builder(
            controller: _pc,
            onPageChanged: (i) => setState(() => page = i),
            itemCount: widget.items.length,
            itemBuilder: (_, i) {
              final x = widget.items[i];

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // top row: merchant + amount (safe)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                x.merchant,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "-\$${x.amount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // time row
                        Text(
                          x.time,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const Spacer(),

                        // bottom row: suggested chip + actions (safe)
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: teal.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                "Suggested: Groceries",
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 36,
                              child: ElevatedButton(
                                onPressed: () => widget.onConfirm(x),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: teal,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 36,
                              child: OutlinedButton(
                                onPressed: () => widget.onEdit(x),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (i) {
            final active = i == page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: active ? 18 : 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: active ? teal : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _HomeAccount {
  final String id;
  final String title;
  final String subtitle;
  final Color accentBg;
  const _HomeAccount({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.accentBg,
  });
}


class _TodayTxnRow extends StatelessWidget {
  final String time;
  final String merchant;
  final String amount;
  final String category;
  final VoidCallback? onFix;

  const _TodayTxnRow({
    required this.time,
    required this.merchant,
    required this.amount,
    required this.category,
    this.onFix,
  });

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);
    final teal = const Color(0xFF29D6C7);

    final isUncat = category.toUpperCase() == "UNCATEGORIZED";

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(time, style: TextStyle(color: muted, fontWeight: FontWeight.w800)),
            ),
            Expanded(
              child: Text(merchant, style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 10),
            Text(amount, style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
            const SizedBox(width: 12),
            if (isUncat)
              SizedBox(
                height: 34,
                child: OutlinedButton(
                  onPressed: onFix,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: teal),
                  ),
                  child: const Text("Fix", style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: teal.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(category, style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
              ),
          ],
        ),
      ),
    );
  }
}

// Below is th ecode for Categories and Vendors Screen 
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final teal = const Color(0xFF29D6C7);
  final textDark = const Color(0xFF0F172A);
  final muted = const Color(0xFF64748B);

  // ✅ Make these mutable so “Add new … category” can actually add chips later
  final List<String> mainCategories = ["Food", "Transport", "Utilities", "Health"];
  final List<String> customCategories = ["Hobby", "Pet Care", "Subscriptions", "Gifts"];

  // ✅ Mock “top 3 merchants” per category (backend later)
  final Map<String, List<_VendorRow>> vendorsByCategory = {
    "Food": const [
      _VendorRow(name: "Whole Foods", amount: 642.20, subtitle: "Groceries, Bread, Milk, Organic produce"),
      _VendorRow(name: "Starbucks", amount: 128.40, subtitle: "Latte, Espresso, Breakfast sandwich"),
      _VendorRow(name: "Blue Bottle", amount: 42.15, subtitle: "Pour over, Coffee beans"),
    ],
    "Transport": const [
      _VendorRow(name: "Uber", amount: 180.50, subtitle: "Commute, Weekend trip, Airport shuttle"),
      _VendorRow(name: "Shell", amount: 94.80, subtitle: "Premium Fuel"),
      _VendorRow(name: "BART", amount: 40.00, subtitle: "Train rides"),
    ],
    "Pet Care": const [
      _VendorRow(name: "Chewy", amount: 152.00, subtitle: "Kibble, Chew toys, Shampoo"),
      _VendorRow(name: "City Vet", amount: 60.00, subtitle: "Routine check-up"),
      _VendorRow(name: "Petco", amount: 35.00, subtitle: "Treats"),
    ],
    "Utilities": const [
      _VendorRow(name: "PG&E", amount: 120.00, subtitle: "Electricity + Gas"),
      _VendorRow(name: "Xfinity", amount: 80.00, subtitle: "Internet"),
      _VendorRow(name: "Water", amount: 45.00, subtitle: "City water bill"),
    ],
    "Health": const [
      _VendorRow(name: "CVS Pharmacy", amount: 56.20, subtitle: "Medicines"),
      _VendorRow(name: "City Dental", amount: 120.00, subtitle: "Cleaning"),
      _VendorRow(name: "Gym", amount: 35.00, subtitle: "Monthly membership"),
    ],
    "Hobby": const [
      _VendorRow(name: "Amazon", amount: 72.60, subtitle: "Accessories, parts"),
      _VendorRow(name: "Michaels", amount: 38.20, subtitle: "Craft supplies"),
      _VendorRow(name: "Steam", amount: 19.99, subtitle: "Game purchase"),
    ],
    "Subscriptions": const [
      _VendorRow(name: "Netflix", amount: 15.49, subtitle: "Monthly subscription"),
      _VendorRow(name: "Spotify", amount: 10.99, subtitle: "Monthly subscription"),
      _VendorRow(name: "iCloud", amount: 2.99, subtitle: "Storage plan"),
    ],
    "Gifts": const [
      _VendorRow(name: "Target", amount: 64.20, subtitle: "Gift items"),
      _VendorRow(name: "Amazon", amount: 29.99, subtitle: "Gift order"),
      _VendorRow(name: "Hallmark", amount: 12.50, subtitle: "Card"),
    ],
  };

  String selectedCategory = "Food";

  final ScrollController _sc = ScrollController();
  late final Map<String, GlobalKey> _sectionKeys = {
    for (final c in [...mainCategories, ...customCategories]) c: GlobalKey()
  };

  double _categoryTotal(String category) {
    final rows = vendorsByCategory[category] ?? const [];
    return rows.fold(0.0, (sum, r) => sum + r.amount);
  }

  Future<void> _scrollToCategory(String category) async {
    final key = _sectionKeys[category];
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      alignment: 0.08,
    );
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allCategories = [...mainCategories, ...customCategories];

    return SafeArea(
      child: SingleChildScrollView(
        controller: _sc,
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Row(
              children: [
                _RoundIcon(
                  icon: Icons.arrow_back,
                  onTap: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                ),
                const Spacer(),
                Text(
                  "Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: textDark),
                ),
                const Spacer(),
                _RoundIcon(icon: Icons.search, onTap: () {}),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              "Categories & Vendors",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textDark),
            ),

            const SizedBox(height: 18),

            // MAIN CATEGORIES
            Text(
              "MAIN CATEGORIES",
              style: TextStyle(
                color: muted,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final c in mainCategories)
                  _CategoryChip(
                    label: c,
                    selected: selectedCategory == c,
                    onTap: () async {
                      setState(() => selectedCategory = c);
                      await _scrollToCategory(c);
                    },
                  ),
                _AddChip(
                  label: "Add new main category",
                  onTap: () => _addCategoryFlow(isMain: true),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // CUSTOM CATEGORIES
            Text(
              "CUSTOM CATEGORIES",
              style: TextStyle(
                color: muted,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final c in customCategories)
                  _CategoryChip(
                    label: c,
                    selected: selectedCategory == c,
                    onTap: () async {
                      setState(() => selectedCategory = c);
                      await _scrollToCategory(c);
                    },
                  ),
                _AddChip(
                  label: "Add new custom category",
                  onTap: () => _addCategoryFlow(isMain: false),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ✅ SHOW ALL CATEGORY CARDS STACKED
            for (final cat in allCategories) ...[
              _CategorySectionCard(
                key: _sectionKeys[cat],
                title: cat,
                total: _categoryTotal(cat),
                expanded: selectedCategory == cat,
                rows: (vendorsByCategory[cat] ?? const []).take(3).toList(),
              ),
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Future<void> _addCategoryFlow({required bool isMain}) async {
    final label = isMain ? "Add new main category" : "Add new custom category";

    final result = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (_) => _AddCategorySheet(title: label),
    );

    if (result == null || result.trim().isEmpty) return;
    final name = result.trim();

    setState(() {
      if (isMain) {
        if (!mainCategories.contains(name)) mainCategories.add(name);
      } else {
        if (!customCategories.contains(name)) customCategories.add(name);
      }
      vendorsByCategory.putIfAbsent(name, () => const []);
      _sectionKeys.putIfAbsent(name, () => GlobalKey());
      selectedCategory = name;
    });

    await _scrollToCategory(name);
  }
}

class _CategorySectionCard extends StatelessWidget {
  final String title;
  final double total;
  final bool expanded;
  final List<_VendorRow> rows;

  const _CategorySectionCard({
    super.key,
    required this.title,
    required this.total,
    required this.expanded,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header row always visible
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: textDark),
                  ),
                ),
                Text(
                  "\$${total.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark),
                ),
              ],
            ),

            // Only selected category shows details "as shown"
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 220),
              crossFadeState: expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: rows.isEmpty
                    ? Text(
                        "No merchants yet for this category.",
                        style: TextStyle(color: muted, fontWeight: FontWeight.w700),
                      )
                    : Column(
                        children: [
                          for (int i = 0; i < rows.length; i++) ...[
                            _VendorTile(row: rows[i]),
                            if (i != rows.length - 1) const SizedBox(height: 16),
                          ],
                        ],
                      ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorRow {
  final String name;
  final double amount;
  final String subtitle;
  const _VendorRow({required this.name, required this.amount, required this.subtitle});
}

class _VendorTile extends StatelessWidget {
  final _VendorRow row;
  const _VendorTile({required this.row});

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                row.name,
                style: TextStyle(fontWeight: FontWeight.w900, color: textDark, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                row.subtitle,
                style: TextStyle(color: muted, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "\$${row.amount.toStringAsFixed(2)}",
          style: TextStyle(fontWeight: FontWeight.w900, color: textDark, fontSize: 16),
        ),
      ],
    );
  }
}

// --- Chips + Add bottom sheet (same style) ---

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? Colors.black : const Color(0xFFE5E7EB)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: selected ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }
}

class _AddChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _AddChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: teal.withOpacity(0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: teal.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 18, color: teal),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _AddCategorySheet extends StatefulWidget {
  final String title;
  const _AddCategorySheet({required this.title});

  @override
  State<_AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<_AddCategorySheet> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            TextField(
              controller: _c,
              decoration: InputDecoration(
                labelText: "Category name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _c.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: teal,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Save", style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Below is the code for settings screen 
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool budgetNotifications = true;
  bool biometrics = false;

  String themeLabel = "System";

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);
    final teal = const Color(0xFF29D6C7);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top header (like your ref)
            Row(
              children: [
                // If this screen is opened via navigation push, back works.
                // In bottom-tab root, it won't show (canPop=false), so we show it anyway:
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF2F6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(Icons.arrow_back, color: Color(0xFF334155)),
                  ),
                ),
                const Spacer(),
                Text(
                  "App Settings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 44), // balance layout
              ],
            ),

            const SizedBox(height: 18),

            // ACCOUNTS
            const _SettingsSectionTitle("ACCOUNTS"),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _SettingsNavTile(
                  icon: Icons.account_balance_rounded,
                  iconBg: teal.withOpacity(0.12),
                  iconColor: teal,
                  title: "Linked Accounts",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SelectAccountScreen()),
                    );
                  },
                ),
                _SettingsNavTile(
                  icon: Icons.add_circle_outline_rounded,
                  iconBg: teal.withOpacity(0.12),
                  iconColor: teal,
                  title: "Add New Account",
                  onTap: () {
                    // Later: open bank-linking flow
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Connect bank flow later (backend).")),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),

            // PERSONALIZATION
            const _SettingsSectionTitle("PERSONALIZATION"),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _SettingsNavTile(
                  icon: Icons.category_rounded,
                  iconBg: teal.withOpacity(0.12),
                  iconColor: teal,
                  title: "Categories",
                  subtitle: "Add / edit categories",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const _SimplePlaceholderPage(title: "Categories"),
                      ),
                    );
                  },
                ),
                _SettingsNavTile(
                  icon: Icons.tune_rounded,
                  iconBg: teal.withOpacity(0.12),
                  iconColor: teal,
                  title: "Budgets",
                  subtitle: "Add new budget, limits & alerts",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const _SimplePlaceholderPage(title: "Budgets"),
                      ),
                    );
                  },
                ),
                _SettingsNavTile(
                  icon: Icons.color_lens_rounded,
                  iconBg: teal.withOpacity(0.12),
                  iconColor: teal,
                  title: "App Theme",
                  trailingText: themeLabel,
                  onTap: () async {
                    final picked = await _themePicker(context, themeLabel);
                    if (picked != null) setState(() => themeLabel = picked);
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ALERTS & PRIVACY
            const _SettingsSectionTitle("ALERTS & PRIVACY"),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _SettingsSwitchTile(
                  icon: Icons.notifications_active_rounded,
                  iconBg: teal.withOpacity(0.12),
                  iconColor: teal,
                  title: "Budget Notifications",
                  value: budgetNotifications,
                  onChanged: (v) => setState(() => budgetNotifications = v),
                ),
                _SettingsSwitchTile(
                  icon: Icons.fingerprint_rounded,
                  iconBg: teal.withOpacity(0.12),
                  iconColor: teal,
                  title: "Security / Biometrics",
                  subtitle: "Require Face ID to open",
                  value: biometrics,
                  onChanged: (v) => setState(() => biometrics = v),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // DEVELOPER (Hackathon Demo)
            const _SettingsSectionTitle("DEVELOPER"),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _SettingsNavTile(
                  icon: Icons.science_rounded,
                  iconBg: const Color(0xFF8B5CF6).withOpacity(0.12),
                  iconColor: const Color(0xFF8B5CF6),
                  title: "Mock Payment Trigger",
                  subtitle: "Test AI parsing pipeline",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MockTriggerScreen()),
                    );
                  },
                ),
                _SettingsNavTile(
                  icon: Icons.school_rounded,
                  iconBg: const Color(0xFF10B981).withOpacity(0.12),
                  iconColor: const Color(0xFF10B981),
                  title: "Learned Merchants",
                  subtitle: "View AI-learned categories",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LearnedMerchantsScreen()),
                    );
                  },
                ),
                _SettingsNavTile(
                  icon: Icons.radar_rounded,
                  iconBg: const Color(0xFFF59E0B).withOpacity(0.12),
                  iconColor: const Color(0xFFF59E0B),
                  title: "Detection Settings",
                  subtitle: "Enable real-time transaction capture",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DetectionSettingsScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Logout button
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  final auth = context.read<AuthProvider>();
                  await auth.signOut();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout_rounded, color: Color(0xFFF43F5E)),
                      SizedBox(width: 10),
                      Text(
                        "Log Out",
                        style: TextStyle(
                          color: Color(0xFFF43F5E),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: Text(
                "Version 2.4.1 (Build 108)",
                style: TextStyle(color: muted, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Future<String?> _themePicker(BuildContext context, String current) async {
    const options = ["System", "Light", "Dark"];
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 10, 18, 8),
              child: Text("App Theme", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ),
            for (final opt in options)
              ListTile(
                title: Text(opt, style: const TextStyle(fontWeight: FontWeight.w700)),
                trailing: opt == current ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(context, opt),
              ),
          ],
        ),
      ),
    );
  }
}

class SelectAccountScreen extends StatefulWidget {
  const SelectAccountScreen({super.key});

  @override
  State<SelectAccountScreen> createState() => _SelectAccountScreenState();
}

class _SelectAccountScreenState extends State<SelectAccountScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load accounts when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BankProvider>().loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Consumer<BankProvider>(
            builder: (context, bank, _) {
              if (bank.isLoading && !bank.hasAccounts) {
                return const Center(child: CircularProgressIndicator());
              }

              final accounts = bank.accounts;
              final totalBalance = bank.formattedTotalBalance;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back + title
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF2F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Icon(Icons.arrow_back, color: Color(0xFF334155)),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Select Account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: textDark,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 44),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text("SUMMARY", style: TextStyle(color: muted, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
                  const SizedBox(height: 10),

                  // Summary Card
                  Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => setState(() => selectedIndex = 0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selectedIndex == 0 ? teal : Colors.transparent,
                            width: selectedIndex == 0 ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF2F6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF334155)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("All Accounts", style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 4),
                                  Text("Aggregated balance", style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(totalBalance, style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
                                const SizedBox(height: 6),
                                if (selectedIndex == 0)
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(color: teal, shape: BoxShape.circle),
                                    child: const Icon(Icons.check, size: 16, color: Colors.white),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text("CONNECTED ACCOUNTS", style: TextStyle(color: muted, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
                  const SizedBox(height: 10),

                  if (accounts.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_outlined, size: 48, color: muted.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text(
                              "No accounts linked yet",
                              style: TextStyle(color: muted, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: accounts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final acc = accounts[i];
                          final idx = i + 1;
                          final isSelected = selectedIndex == idx;
                          
                          // Find bank metadata for icon/color
                          final bankMeta = IndianBanks.getById(acc.institutionId);
                          final bankColor = bankMeta != null ? Color(bankMeta.color) : const Color(0xFF334155);

                          return Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => setState(() => selectedIndex = idx),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? teal : Colors.transparent,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: bankColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Icon(
                                            Icons.account_balance_rounded, 
                                            color: bankColor,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(acc.accountName, style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
                                              const SizedBox(height: 4),
                                              Text("${acc.institutionName} • ${acc.maskedNumber}", style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(acc.formattedBalance, style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
                                            const SizedBox(height: 6),
                                            if (isSelected)
                                              Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(color: teal, shape: BoxShape.circle),
                                                child: const Icon(Icons.check, size: 16, color: Colors.white),
                                              )
                                          ],
                                        ),
                                      ],
                                    ),
                                    
                                    // Action Buttons Row
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton.icon(
                                            onPressed: () => _showAddAccountSheet(context, account: acc),
                                            icon: const Icon(Icons.edit_rounded, size: 18),
                                            label: const Text("Edit"),
                                            style: TextButton.styleFrom(
                                              foregroundColor: textDark,
                                              visualDensity: VisualDensity.compact,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton.icon(
                                            onPressed: () async {
                                              final confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text("Remove Account?"),
                                                  content: Text("Are you sure you want to unlink ${acc.accountName}?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.of(ctx).pop(false),
                                                      child: const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.of(ctx).pop(true),
                                                      style: TextButton.styleFrom(foregroundColor: const Color(0xFFF43F5E)),
                                                      child: const Text("Remove"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              
                                              if (confirm == true) {
                                                context.read<BankProvider>().removeAccount(acc.id);
                                              }
                                            },
                                            icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                            label: const Text("Remove"),
                                            style: TextButton.styleFrom(
                                              foregroundColor: const Color(0xFFF43F5E),
                                              visualDensity: VisualDensity.compact,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 14),

                  // Link new account button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Link New Account",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      onPressed: () => _showAddAccountSheet(context),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showAddAccountSheet(BuildContext context, {BankAccount? account}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) => _BankFormSheet(account: account),
    );
  }
}

class _BankFormSheet extends StatefulWidget {
  final BankAccount? account;
  const _BankFormSheet({this.account});

  @override
  State<_BankFormSheet> createState() => _BankFormSheetState();
}

class _BankFormSheetState extends State<_BankFormSheet> {
  BankInstitution? selectedBank;
  late TextEditingController _accountNameController;
  late TextEditingController _balanceController;
  late TextEditingController _maskedNumberController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final acc = widget.account;
    if (acc != null) {
      selectedBank = IndianBanks.getById(acc.institutionId);
      _accountNameController = TextEditingController(text: acc.accountName);
      _balanceController = TextEditingController(text: acc.balance.toString());
      _maskedNumberController = TextEditingController(text: acc.maskedNumber.replaceAll("•••• ", ""));
    } else {
      _accountNameController = TextEditingController();
      _balanceController = TextEditingController();
      _maskedNumberController = TextEditingController(text: "•••• ");
    }
  }
  
  Future<void> _submit() async {
    if (selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a bank first")));
      return;
    }
    if (_accountNameController.text.isEmpty || _balanceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final isEdit = widget.account != null;
      bool success;

      final balance = double.tryParse(_balanceController.text) ?? 0.0;
      // Ensure masked number has dots
      var masked = _maskedNumberController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (!masked.startsWith("••••")) masked = "•••• $masked";

      if (isEdit) {
        final updated = widget.account!.copyWith(
          institutionId: selectedBank!.id,
          institutionName: selectedBank!.name,
          accountName: _accountNameController.text,
          maskedNumber: masked,
          balance: balance,
        );
        success = await context.read<BankProvider>().updateAccount(updated);
      } else {
        success = await context.read<BankProvider>().addAccount(
          institutionId: selectedBank!.id,
          institutionName: selectedBank!.name,
          accountName: _accountNameController.text,
          accountType: AccountType.savings,
          maskedNumber: masked,
          balance: balance,
        );
      }

      if (mounted && success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? "Account updated!" : "Account connected successfully!")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  @override
  void dispose() {
    _accountNameController.dispose();
    _balanceController.dispose();
    _maskedNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);
    final isEdit = widget.account != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isEdit ? "Edit Account" : "Connect Bank Account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: textDark)),
          const SizedBox(height: 8),
          Text(isEdit ? "Update account details." : "Select your bank to link securely.", style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
          
          const SizedBox(height: 24),

          // Bank Selector
          if (selectedBank == null) ...[
            Text("Popular Banks", style: TextStyle(color: muted, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1.1)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                shrinkWrap: true,
                children: IndianBanks.banks.take(6).map((bank) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedBank = bank;
                        _accountNameController.text = "${bank.name} Checking";
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance, color: Color(bank.color), size: 28),
                          const SizedBox(height: 8),
                          Text(
                            bank.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textDark),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                   showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    builder: (ctx) => DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.7,
                      maxChildSize: 0.9,
                      minChildSize: 0.5,
                      builder: (_, controller) => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Select Bank", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark)),
                          ),
                          Expanded(
                            child: ListView.separated(
                              controller: controller,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              itemCount: IndianBanks.banks.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final bank = IndianBanks.banks[i];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(bank.color).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.account_balance, color: Color(bank.color), size: 20),
                                  ),
                                  title: Text(bank.name, style: TextStyle(fontWeight: FontWeight.w700, color: textDark)),
                                  onTap: () {
                                    Navigator.pop(ctx);
                                    setState(() {
                                      selectedBank = bank;
                                      _accountNameController.text = "${bank.name} Checking";
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text("View All Banks", style: TextStyle(color: teal, fontWeight: FontWeight.w800)),
              ),
            ),
          ] else ...[
            // Details Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(selectedBank!.color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(selectedBank!.color).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_balance, color: Color(selectedBank!.color)),
                  const SizedBox(width: 12),
                  Text(selectedBank!.name, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.change_circle_outlined),
                    onPressed: () => setState(() => selectedBank = null),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              controller: _accountNameController,
              decoration: InputDecoration(
                labelText: "Account Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            
            const SizedBox(height: 12),
            
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Current Balance (₹)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            
            const SizedBox(height: 12),
            
            TextField(
              controller: _maskedNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Last 4 digits",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: teal,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
                      )
                    : Text(isEdit ? "Update Account" : "Securely Connect", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ),
          ],


          const SizedBox(height: 30),
        ],
      ),
    );
  }
}



class _SettingsSectionTitle extends StatelessWidget {
  final String text;
  const _SettingsSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF64748B),
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
        fontSize: 12,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: children),
      ),
    );
  }
}

class _SettingsNavTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback onTap;

  const _SettingsNavTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textDark,
          fontWeight: FontWeight.w900,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: TextStyle(color: muted, fontWeight: FontWeight.w600),
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(
                trailingText!,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textDark,
          fontWeight: FontWeight.w900,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: TextStyle(color: muted, fontWeight: FontWeight.w600),
            ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _SimplePlaceholderPage extends StatelessWidget {
  final String title;
  const _SimplePlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF2F6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF334155)),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                "UI screen placeholder.\nWe’ll build this next.",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





// Below is the code for stats screen
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // Time range tabs like the reference
  int rangeIndex = 2; // 0 Daily, 1 Weekly, 2 Monthly, 3 Yearly
  int? selectedBarIndex; // interactive selection
  String selectedMainCategory = "All";
  String? selectedSubCategory; 
  DateTimeRange? selectedRange;
  DateTime? selectedSingleDate;

  // Filters (UI only for now)
  final Map<String, String> filters = {
    "Accounts": "All",
    "Category": "All", // kept for backend compatibility
    "Dates": "Last 30d",
    "Type": "All",
  };

  // Searchable insights data (UI only for now)
  final List<_InsightData> insightsData = const [
    _InsightData(
      icon: Icons.coffee_rounded,
      iconBg: Color(0xFFFFF1E7),
      iconColor: Color(0xFFF97316),
      title: "You spent 15% more on Coffee this week than your average.",
      subtitle: "That’s about \$12.50 extra.",
    ),
    _InsightData(
      icon: Icons.check_circle_rounded,
      iconBg: Color(0xFFE9FFF9),
      iconColor: Color(0xFF10B981),
      title: "Great job! You are \$200 under your dining budget this month.",
      subtitle: "Keep it up to reach your savings goal.",
    ),
    _InsightData(
      icon: Icons.notifications_active_rounded,
      iconBg: Color(0xFFE8F0FF),
      iconColor: Color(0xFF3B82F6),
      title: "Subscription Alert: Netflix increased by \$2.00 starting next cycle.",
      subtitle: "Detected in your recurring payments.",
    ),
  ];
  String get _rangeLabel {
  if (selectedRange != null) return "${_fmt(selectedRange!.start)} - ${_fmt(selectedRange!.end)}";
  if (selectedSingleDate != null) return _fmt(selectedSingleDate!);
  return switch (rangeIndex) {
    0 => "Daily",
    1 => "Weekly",
    2 => "Monthly",
    _ => "Yearly",
  };
}

// Mock generator (replace with backend later)
// Generates 12 points by default for the selected rangeIndex
List<_TimePoint> _buildSeriesFor({
  required String mainCategory,
  String? subCategory,
}) {
  final r = _effectiveRange();

  // Decide bucket count based on rangeIndex or selectedRange size
  final days = r.end.difference(r.start).inDays + 1;

  int buckets;
  if (selectedRange != null || selectedSingleDate != null) {
    // if user picked range, choose “nice” buckets
    buckets = days <= 10 ? days : (days <= 35 ? 12 : 12);
  } else {
    buckets = switch (rangeIndex) {
      0 => 7,   // daily default
      1 => 8,   // weekly-ish bars
      2 => 12,  // monthly bars
      _ => 12,  // yearly months
    };
  }

  // Base values from category (fallback to All)
  final baseValues = seriesByMainCategory[mainCategory] ?? seriesByMainCategory["All"]!;
  // Use a repeat pattern so any bucket count works
  double v(int i) => baseValues[i % baseValues.length];

  // If subCategory is selected, shrink values a bit (mock behavior)
  final subFactor = (subCategory == null) ? 1.0 : 0.55;

  // Build buckets
  return List.generate(buckets, (i) {
    final start = DateTime.fromMillisecondsSinceEpoch(
      r.start.millisecondsSinceEpoch +
          ((r.end.millisecondsSinceEpoch - r.start.millisecondsSinceEpoch) * i ~/ buckets),
    );
    final end = DateTime.fromMillisecondsSinceEpoch(
      r.start.millisecondsSinceEpoch +
          ((r.end.millisecondsSinceEpoch - r.start.millisecondsSinceEpoch) * (i + 1) ~/ buckets) -
          1,
    );

    final label = switch (rangeIndex) {
      0 => "${start.day}",
      1 => "W${i + 1}",
      2 => "${start.month}/${start.day}",
      _ => ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"][start.month - 1],
    };

    return _TimePoint(
      label: label,
      start: start,
      end: end,
      amount: v(i) * subFactor,
    );
  });
}


  double _totalSpent(List<_TimePoint> pts) => pts.fold(0.0, (a, b) => a + b.amount);

  Widget _TotalSpentHeader({
    required double total,
    required String category,
  }) {
    final teal = const Color(0xFF29D6C7);
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TOTAL SPENT",
                    style: TextStyle(
                      color: muted,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$category • $_rangeLabel",
                    style: TextStyle(color: muted, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: teal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Icon(Icons.insights_rounded, size: 18, color: Color(0xFF29D6C7)),
                  SizedBox(width: 8),
                  Text("Insights", style: TextStyle(fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------
  // UI-only mock data (backend later)
  // Keep everything in maps so it's easy to replace with API responses.
  // ----------------------------

  final List<String> mainCategories = const [
    "All",
    "Food & Drinks",
    "Bills",
    "Fuel",
    "Shopping",
    "Transport",
    "Subscriptions",
  ];

  // Time-series values (12 points). Interpret based on rangeIndex (Daily/Weekly/Monthly/Yearly).
  final Map<String, List<double>> seriesByMainCategory = const {
    "All":          [120, 90, 150, 80, 140, 110, 175, 95, 130, 155, 105, 160],
    "Food & Drinks":[35,  25,  45,  22,  38,  28,  55,  26,  36,  48,  30,  50],
    "Bills":        [40,  38,  42,  41,  39,  40,  43,  38,  41,  42,  40,  41],
    "Fuel":         [18,  12,  20,  14,  17,  16,  22,  13,  18,  19,  12,  16],
    "Shopping":     [22,  15,  28,  12,  25,  18,  30,  20,  26,  29,  16,  27],
    "Transport":    [15,  10,  18,  9,   14,  12,  19,  11,  16,  18,  10,  15],
    "Subscriptions":[10,  10,  10,  10,  12,  10,  12,  10,  10,  12,  10,  10],
  };

  // Subcategory breakdowns per main category
  final Map<String, List<_SubSlice>> subcatsByMainCategory = const {
    "All": [
      _SubSlice("Groceries", 0.25, Color(0xFF29D6C7)),
      _SubSlice("Coffee", 0.20, Color(0xFF3B82F6)),
      _SubSlice("Dining Out", 0.15, Color(0xFFF59E0B)),
      _SubSlice("Public Transit", 0.15, Color(0xFFEC4899)),
      _SubSlice("Subscriptions", 0.13, Color(0xFF8B5CF6)),
      _SubSlice("Pharmacy", 0.12, Color(0xFF10B981)),
    ],
    "Food & Drinks": [
      _SubSlice("Groceries", 0.48, Color(0xFF29D6C7)),
      _SubSlice("Dining Out", 0.28, Color(0xFFF59E0B)),
      _SubSlice("Coffee", 0.24, Color(0xFF3B82F6)),
    ],
    "Bills": [
      _SubSlice("Rent", 0.55, Color(0xFF1F2937)),
      _SubSlice("Utilities", 0.25, Color(0xFF64748B)),
      _SubSlice("Internet", 0.20, Color(0xFF29D6C7)),
    ],
    "Fuel": [
      _SubSlice("Gas", 0.85, Color(0xFF3B82F6)),
      _SubSlice("Tolls", 0.15, Color(0xFF29D6C7)),
    ],
    "Shopping": [
      _SubSlice("Amazon", 0.45, Color(0xFF8B5CF6)),
      _SubSlice("Clothing", 0.35, Color(0xFFEC4899)),
      _SubSlice("Home", 0.20, Color(0xFF10B981)),
    ],
    "Transport": [
      _SubSlice("Public Transit", 0.65, Color(0xFFEC4899)),
      _SubSlice("Ride Share", 0.35, Color(0xFF29D6C7)),
    ],
    "Subscriptions": [
      _SubSlice("Netflix", 0.35, Color(0xFF3B82F6)),
      _SubSlice("Spotify", 0.25, Color(0xFF10B981)),
      _SubSlice("iCloud", 0.20, Color(0xFF29D6C7)),
      _SubSlice("Other", 0.20, Color(0xFF64748B)),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);
    
    
    final points = _buildSeriesFor(
      mainCategory: selectedMainCategory,
      subCategory: selectedSubCategory,
    );
    final total = _totalSpent(points);

    final subSlices = subcatsByMainCategory[selectedMainCategory] ??
        subcatsByMainCategory["All"]!;
    final filteredInsights = _filterInsights(insightsData, selectedMainCategory, selectedSubCategory);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar (calendar icon, title, search icon)
            Row(
              children: [
                _RoundIcon(
                  icon: Icons.calendar_month_outlined,
                  onTap: _openCalendarMenu,
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "Spending Insights",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "October 2023",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: muted,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _RoundIcon(
                  icon: Icons.search,
                  onTap: () async {
                    final result = await showSearch<_InsightData?>(
                      context: context,
                      delegate: _InsightSearchDelegate(filteredInsights),
                    );

                    if (result != null && mounted) {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        builder: (_) => SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  result.subtitle,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Range tabs (Daily/Weekly/Monthly/Yearly)
            _RangeTabs(
              selectedIndex: rangeIndex,
              onChanged: (i) => setState(() {
                rangeIndex = i;
                selectedBarIndex = null; // ✅ avoid stale highlight
              }),
            ),


            const SizedBox(height: 14),

            // Filter chips row (accounts/categories/dates...)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _FilterChip(
                  label: "Accounts: ${filters["Accounts"]}",
                  onTap: () => _showQuickPick(
                    title: "Accounts",
                    options: const ["All", "HDFC", "Chase", "Credit Card"],
                    onSelect: (v) => setState(() => filters["Accounts"] = v),
                  ),
                ),
                _FilterChip(
                  label: "Category: $selectedMainCategory",
                  onTap: () => _showQuickPick(
                    title: "Category",
                    options: mainCategories,
                    onSelect: (v) => setState(() {
                      selectedMainCategory = v;
                      filters["Category"] = v; // keep in sync for backend later
                    }),
                  ),
                ),
                _FilterChip(
                  label: "Dates: ${filters["Dates"]}",
                  onTap: () => _openCalendarMenu(),
                ),
                _FilterChip(
                  label: "Type: ${filters["Type"]}",
                  onTap: () => _showQuickPick(
                    title: "Type",
                    options: const ["All", "Debit", "Credit", "Split-only"],
                    onSelect: (v) => setState(() => filters["Type"] = v),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Total spent header
            _TotalSpentHeader(total: total, category: selectedMainCategory),
            const SizedBox(height: 16),

            // ------------------------
            // 1) Main category time-series bar chart (tap category to filter)
            // ------------------------
            _MainCategoryTrendsCard(
              title: "MAIN CATEGORY EXPENDITURE",
              categories: mainCategories,
              selectedCategory: selectedMainCategory,
              points: points,
              selectedBarIndex: selectedBarIndex,
              onSelectCategory: (c) => setState(() {
                selectedMainCategory = c;
                filters["Category"] = c;
                selectedSubCategory = null;     // ✅ reset
                selectedBarIndex = null;        // ✅ reset
              }),
              onTapBar: (i) async {
                setState(() => selectedBarIndex = i);
                final p = points[i];

                await showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  builder: (_) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedMainCategory == "All"
                                ? "Spending"
                                : "$selectedMainCategory spending",
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${_fmt(p.start)} → ${_fmt(p.end)}",
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "\$${p.amount.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),


            const SizedBox(height: 16),


            // ------------------------
            // 2) Sub-category breakdown pie chart (filtered)
            // ------------------------
            _SubcategoryBreakdownCard(
              title: "SUB-CATEGORY BREAKDOWN",
              totalLabel: "TOTAL",
              totalValue: "\$${total.toStringAsFixed(2)}",
              subSlices: subSlices,
              selectedSubCategory: selectedSubCategory,
              onSelectSubCategory: (sub) => setState(() {
                selectedSubCategory = (selectedSubCategory == sub) ? null : sub; // tap again to clear
                selectedBarIndex = null;
              }),
            ),

            const SizedBox(height: 18),

            // Personalized Insights header
            Row(
              children: [
                Text(
                  "Personalized Insights",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "View All",
                    style: TextStyle(color: teal, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),


            const SizedBox(height: 8),

            // Insights list filtered by selected category
            ...filteredInsights.map(
              (x) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _InsightCard(data: x),
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  // --------- Labels helper based on rangeIndex ----------
  List<String> _xLabelsFor(int rangeIndex) {
    switch (rangeIndex) {
      case 0: // Daily
        return const ["1", "3", "5", "7", "9", "11"];
      case 1: // Weekly
        return const ["W1", "W2", "W3", "W4"];
      case 2: // Monthly
        return const ["OCT 1", "OCT 15", "OCT 31"];
      case 3: // Yearly
        return const ["Q1", "Q2", "Q3", "Q4"];
      default:
        return const ["1", "6", "12"];
    }
  }

  List<_InsightData> _filterInsights(
    List<_InsightData> src,
    String main,
    String? sub,
  ) {
    var out = src;

    if (main != "All") {
      out = out.where((x) {
        final t = (x.title + " " + x.subtitle).toLowerCase();
        final key = main.toLowerCase();
        if (key.contains("food")) return t.contains("coffee") || t.contains("dining") || t.contains("grocery");
        if (key.contains("bill") || key.contains("subscription")) return t.contains("subscription") || t.contains("netflix");
        if (key.contains("transport")) return t.contains("transit") || t.contains("ride");
        if (key.contains("shopping")) return t.contains("shopping") || t.contains("amazon");
        if (key.contains("fuel")) return t.contains("fuel") || t.contains("gas");
        return t.contains(key);
      }).toList();
    }

    if (sub != null) {
      final sk = sub.toLowerCase();
      out = out.where((x) => (x.title + " " + x.subtitle).toLowerCase().contains(sk)).toList();
    }

    return out;
  }

  // ---------- Calendar menu + pickers ----------

  Future<void> _openCalendarMenu() async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text(
                  "Select date range",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickDateRange();
                },
              ),
              ListTile(
                leading: const Icon(Icons.today),
                title: const Text(
                  "Select single date",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickSingleDate();
                },
              ),
              if (selectedRange != null || selectedSingleDate != null)
                ListTile(
                  leading: const Icon(Icons.clear),
                  title: const Text(
                    "Clear date filter",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      selectedRange = null;
                      selectedSingleDate = null;
                      filters["Dates"] = "Last 30d";
                    });
                  },
                ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final initial = selectedRange ??
        DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: now,
        );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: initial,
      helpText: "Select date range",
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
        selectedSingleDate = null;
        selectedBarIndex = null;
        filters["Dates"] = "${_fmt(picked.start)} - ${_fmt(picked.end)}";
      });
    }
  }

  Future<void> _pickSingleDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedSingleDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      helpText: "Select a date",
    );

    if (picked != null) {
      setState(() {
        selectedSingleDate = picked;
        selectedRange = null;
        selectedBarIndex = null;
        filters["Dates"] = _fmt(picked);
      });
    }
  }

  String _fmt(DateTime d) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return "${d.day} ${months[d.month - 1]}, ${d.year}";
  }

  DateTimeRange _effectiveRange() {
    final now = DateTime.now();

    if (selectedSingleDate != null) {
      final d = selectedSingleDate!;
      return DateTimeRange(
        start: DateTime(d.year, d.month, d.day),
        end: DateTime(d.year, d.month, d.day, 23, 59, 59),
      );
    }

    if (selectedRange != null) return selectedRange!;

    // defaults based on rangeIndex
    switch (rangeIndex) {
      case 0: // Daily -> last 7 days
        return DateTimeRange(start: now.subtract(const Duration(days: 6)), end: now);
      case 1: // Weekly -> last 4 weeks
        return DateTimeRange(start: now.subtract(const Duration(days: 27)), end: now);
      case 2: // Monthly -> last 30 days
        return DateTimeRange(start: now.subtract(const Duration(days: 29)), end: now);
      default: // Yearly -> last 12 months (approx)
        return DateTimeRange(start: DateTime(now.year - 1, now.month, now.day), end: now);
    }
  }

  // ---------- Filter picker ----------

  Future<void> _showQuickPick({
    required String title,
    required List<String> options,
    required void Function(String) onSelect,
  }) async {
    final chosen = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              for (final opt in options)
                ListTile(
                  title: Text(opt, style: const TextStyle(fontWeight: FontWeight.w700)),
                  onTap: () => Navigator.pop(context, opt),
                ),
            ],
          ),
        );
      },
    );

    if (chosen != null) onSelect(chosen);
  }
}

class _InteractiveBarChart extends StatelessWidget {
  final List<_TimePoint> points;
  final int? selectedIndex;
  final ValueChanged<int> onTapBar;

  const _InteractiveBarChart({
    required this.points,
    required this.selectedIndex,
    required this.onTapBar,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final muted = const Color(0xFF94A3B8);

    final maxV = points.isEmpty
        ? 1.0
        : points.map((p) => p.amount).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 190,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(points.length, (i) {
                  final p = points[i];
                  final sel = selectedIndex == i;
                  final h = (p.amount / (maxV == 0 ? 1 : maxV)).clamp(0.0, 1.0);

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTapBar(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          height: 160 * h,
                          decoration: BoxDecoration(
                            color: sel ? teal : teal.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: sel
                                ? [
                                    BoxShadow(
                                      color: teal.withOpacity(0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    )
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // X labels (show only a few to avoid clutter)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _sparseLabels(points.map((p) => p.label).toList())
                .map((t) => Text(
                      t,
                      style: TextStyle(color: muted, fontWeight: FontWeight.w800, fontSize: 12),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // show 3-4 labels max
  static List<String> _sparseLabels(List<String> full) {
    if (full.length <= 4) return full;
    return [full.first, full[full.length ~/ 2], full.last];
  }
}


class _TimePoint {
  final String label;   // e.g. "Oct 1" / "W2" / "15"
  final DateTime start; // start of bucket
  final DateTime end;   // end of bucket
  final double amount;  // spent
  const _TimePoint({
    required this.label,
    required this.start,
    required this.end,
    required this.amount,
  });
}

class _MainCategoryTrendsCard extends StatelessWidget {
  final String title;
  final List<String> categories;
  final String selectedCategory;

  // ✅ backend-friendly: pass points already bucketed by day/week/month/year
  final List<_TimePoint> points;

  final ValueChanged<String> onSelectCategory;
  final ValueChanged<int> onTapBar;
  final int? selectedBarIndex;

  const _MainCategoryTrendsCard({
    required this.title,
    required this.categories,
    required this.selectedCategory,
    required this.points,
    required this.onSelectCategory,
    required this.onTapBar,
    required this.selectedBarIndex,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    final maxV = points.isEmpty
        ? 1.0
        : points.map((p) => p.amount).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  selectedCategory,
                  style: TextStyle(color: muted, fontWeight: FontWeight.w800),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // category selector row (scrollable)
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final c = categories[i];
                  final sel = c == selectedCategory;

                  return InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => onSelectCategory(c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: sel ? teal : Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: sel ? teal : const Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        c,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: sel ? Colors.black : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // ✅ interactive bars
            SizedBox(
              height: 190,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(points.length, (i) {
                          final p = points[i];
                          final sel = selectedBarIndex == i;
                          final h = (p.amount / (maxV == 0 ? 1 : maxV)).clamp(0.0, 1.0);

                          return Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => onTapBar(i),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  curve: Curves.easeOut,
                                  height: 160 * h,
                                  decoration: BoxDecoration(
                                    color: sel ? teal : teal.withOpacity(0.22),
                                    borderRadius: BorderRadius.circular(999),
                                    boxShadow: sel
                                        ? [
                                            BoxShadow(
                                              color: teal.withOpacity(0.22),
                                              blurRadius: 10,
                                              offset: const Offset(0, 6),
                                            )
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // show 3 labels max (prevents overflow)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _sparseLabels(points.map((p) => p.label).toList())
                        .map((t) => Text(
                              t,
                              style: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<String> _sparseLabels(List<String> full) {
    if (full.length <= 4) return full;
    return [full.first, full[full.length ~/ 2], full.last];
  }
}


class _SubSlice {
  final String label;
  final double value;
  final Color color;

  const _SubSlice(this.label, this.value, this.color);
}

class _SubcategoryBreakdownCard extends StatelessWidget {
  final String title;
  final String totalLabel;
  final String totalValue;
  final List<_SubSlice> subSlices;
  final String? selectedSubCategory;
  final ValueChanged<String> onSelectSubCategory;

  const _SubcategoryBreakdownCard({
    required this.title,
    required this.totalLabel,
    required this.totalValue,
    required this.subSlices,
    this.selectedSubCategory,
    required this.onSelectSubCategory,
  });

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);

    // Convert to your existing PieSlice model
    final slices = subSlices.map((s) => _PieSlice(s.label, s.value, s.color)).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.info_outline, size: 18, color: Color(0xFF64748B)),
              ],
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _DonutChart(slices: slices),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        totalLabel,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        totalValue,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),

            // legend
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: subSlices.map((s) {
                final sel = selectedSubCategory == s.label;
                return InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => onSelectSubCategory(s.label),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: sel ? s.color.withOpacity(0.18) : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: sel ? s.color : const Color(0xFFE5E7EB)),
                    ),
                    child: Text(
                      s.label,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}



// ----------------- Insights search + card -----------------

class _InsightData {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _InsightData({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}

class _InsightCard extends StatelessWidget {
  final _InsightData data;
  const _InsightCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: data.iconBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(data.icon, color: data.iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "",
                    style: TextStyle(fontSize: 0),
                  ),
                  Text(
                    data.subtitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightSearchDelegate extends SearchDelegate<_InsightData?> {
  final List<_InsightData> items;
  _InsightSearchDelegate(this.items);

  @override
  String get searchFieldLabel => "Search insights...";

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => query = "",
          ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    final results = _filter();
    return ListView(
      children: results
          .map((x) => ListTile(
                title: Text(x.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(x.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => close(context, x),
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = _filter();
    return ListView(
      children: results
          .map((x) => ListTile(
                title: Text(x.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(x.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => close(context, x),
              ))
          .toList(),
    );
  }

  List<_InsightData> _filter() {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items
        .where((x) =>
            x.title.toLowerCase().contains(q) ||
            x.subtitle.toLowerCase().contains(q))
        .toList();
  }
}

// ----------------- UI helpers used by StatsScreen -----------------

class _RangeTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  const _RangeTabs({required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final muted = const Color(0xFF64748B);
    final labels = const ["Daily", "Weekly", "Monthly", "Yearly"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(labels.length, (i) {
        final selected = i == selectedIndex;
        return Expanded(
          child: InkWell(
            onTap: () => onChanged(i),
            child: Column(
              children: [
                Text(
                  labels[i],
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: selected ? teal : muted,
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 3,
                  width: 44,
                  decoration: BoxDecoration(
                    color: selected ? teal : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_alt_outlined, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _MiniComparisonBars extends StatelessWidget {
  const _MiniComparisonBars();
  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    return SizedBox(
      width: 86,
      height: 54,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _bar(0.6, const Color(0xFFE2E8F0)),
          _bar(0.85, const Color(0xFFE2E8F0)),
          _bar(0.7, teal),
          _bar(0.9, const Color(0xFFE2E8F0)),
          _bar(0.55, const Color(0xFFE2E8F0)),
        ],
      ),
    );
  }

  Widget _bar(double h, Color c) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Container(
          height: 54 * h,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

// Minimal donut chart using CustomPainter (no external package)
class _PieSlice {
  final String label;
  final double value;
  final Color color;
  const _PieSlice(this.label, this.value, this.color);
}

class _DonutChart extends StatelessWidget {
  final List<_PieSlice> slices;
  const _DonutChart({required this.slices});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(220, 220),
      painter: _DonutPainter(slices),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<_PieSlice> slices;
  _DonutPainter(this.slices);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 42
      ..strokeCap = StrokeCap.butt;

    // soft glow background
    final glow = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF29D6C7).withOpacity(0.08);
    canvas.drawCircle(center, radius, glow);

    double start = -1.5708; // -pi/2
    for (final s in slices) {
      final sweep = s.value * 6.28318; // 2pi
      paint.color = s.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 12),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => false;
}

class _LegendDot extends StatelessWidget {
  final String label;
  final Color color;
  const _LegendDot({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}


class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFEFF2F6);
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, color: const Color(0xFF334155)),
      ),
    );
  }
}

class _AccountChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _AccountChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final border = const Color(0xFFE5E7EB);

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? teal : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? teal : border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? Colors.black : Colors.black87),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: selected ? Colors.black : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String amount;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const Spacer(),
              Text(title, style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(
                amount,
                style: TextStyle(
                  color: textDark,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: const Color(0xFF334155)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        color: textDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      )),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              amount,
              style: TextStyle(
                color: textDark,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart();

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);

    // Simple fixed bars to match the screenshot vibe (no chart package)
    final bars = <double>[0.35, 0.55, 0.28, 0.62, 0.42, 0.58, 0.40, 0.70, 0.46, 0.78, 0.33, 0.60];

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < bars.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 150 * bars[i],
                  decoration: BoxDecoration(
                    color: i % 3 == 0 ? teal : teal.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AxisLabel extends StatelessWidget {
  final String text;
  const _AxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF94A3B8),
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}


class _ConfirmItem {
  final String merchant;
  final String amount;
  final String time;
  const _ConfirmItem({
    required this.merchant,
    required this.amount,
    required this.time,
  });
}


class _ConfirmTile extends StatelessWidget {
  final _ConfirmItem item;
  final VoidCallback onConfirm;

  const _ConfirmTile({required this.item, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF2F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.help_outline_rounded, color: Color(0xFF334155)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.merchant,
                  style: TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(item.time, style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item.amount, style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29D6C7),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text("Confirm", style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _ConfirmBottomSheet extends StatefulWidget {
  final String merchant;
  const _ConfirmBottomSheet({required this.merchant});

  @override
  State<_ConfirmBottomSheet> createState() => _ConfirmBottomSheetState();
}

class _ConfirmBottomSheetState extends State<_ConfirmBottomSheet> {
  String? selectedCategory;
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    // default name = merchant, user can edit
    _name = TextEditingController(text: widget.merchant);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final options = const [
      "Food / Coffee",
      "Groceries",
      "Transport / Fuel",
      "Shopping",
      "Bills / Subscription",
      "Other",
    ];

    final canSave = selectedCategory != null && _name.text.trim().isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Confirm transaction",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              "Edit the name and pick a category.",
              style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
            ),

            const SizedBox(height: 14),

            // Name input
            TextField(
              controller: _name,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: "Transaction name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),

            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((o) {
                final isSel = selectedCategory == o;
                return InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => setState(() => selectedCategory = o),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSel ? teal.withOpacity(0.18) : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: isSel ? teal : const Color(0xFFE5E7EB)),
                    ),
                    child: Text(o, style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: canSave
                    ? () {
                        Navigator.pop(
                          context,
                          "${_name.text.trim()}|||${selectedCategory!}",
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: teal,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Save", style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile section 
Future<void> showProfileSideSheet(BuildContext context) async {
  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Profile",
    barrierColor: Colors.black.withOpacity(0.25),
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, anim, __, ___) {
      final slide = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));

      return SlideTransition(
        position: slide,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.82,
                minWidth: 280,
              ),
              child: const _ProfileSideSheet(),
            ),
          ),
        ),
      );
    },
  );
}

class _ProfileSideSheet extends StatelessWidget {
  const _ProfileSideSheet();

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);
    final teal = const Color(0xFF29D6C7);

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.user;
        final userName = user?.name ?? "Guest User";
        final userEmail = user?.email ?? "";
        final lastSync = user?.lastLoginAt != null
            ? "Last sync: ${_formatDate(user!.lastLoginAt!)}"
            : "Not synced yet";

        // Linked accounts
        final accounts = context.watch<BankProvider>().accounts;

    return SafeArea(
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF7F8FA),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF2F6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(Icons.close, color: Color(0xFF334155)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text("Profile",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark)),
                ],
              ),
            ),

            // User block
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: teal.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.person, color: Color(0xFF0F172A), size: 30),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userName,
                                style: TextStyle(
                                    color: textDark, fontWeight: FontWeight.w900, fontSize: 16)),
                            if (userEmail.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(userEmail,
                                  style: TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 13)),
                            ],
                            const SizedBox(height: 4),
                            Text(lastSync,
                                style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Linked accounts list
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Row(
                children: [
                  Text("Linked bank accounts",
                      style: TextStyle(color: muted, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SelectAccountScreen()),
                      );
                    },
                    child: Text("Manage", style: TextStyle(color: teal, fontWeight: FontWeight.w900)),
                  )
                ],
              ),
            ),

            Expanded(
              child: accounts.isEmpty
                  ? Center(
                      child: Text(
                        "No accounts linked",
                        style: TextStyle(color: muted, fontWeight: FontWeight.w600),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      itemCount: accounts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final a = accounts[i];
                        final bankMeta = IndianBanks.getById(a.institutionId);
                        final bankColor = bankMeta != null ? Color(bankMeta.color) : const Color(0xFF334155);

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: bankColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(Icons.account_balance_rounded, color: bankColor),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(a.accountName,
                                          style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
                                      const SizedBox(height: 4),
                                      Text("${a.institutionName} • ${a.maskedNumber}", style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Optional: logout / settings shortcut
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Later: open Settings tab or logout flow
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: const Text("Go to Settings", style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
      }, // end Consumer builder
    ); // end Consumer
  }

  static String _formatDate(DateTime d) {
    const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    final hour = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final ampm = d.hour >= 12 ? "PM" : "AM";
    return "${d.day} ${months[d.month - 1]}, $hour:${d.minute.toString().padLeft(2, '0')} $ampm";
  }
}

// Adding Expenses Manually using plus buton 
Future<void> showNewTransactionSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: Colors.white,
    builder: (_) => const _NewTransactionSheet(),
  );
}

class _NewTransactionSheet extends StatefulWidget {
  const _NewTransactionSheet();

  @override
  State<_NewTransactionSheet> createState() => _NewTransactionSheetState();
}

class _NewTransactionSheetState extends State<_NewTransactionSheet> {
  final teal = const Color(0xFF29D6C7);
  final textDark = const Color(0xFF0F172A);
  final muted = const Color(0xFF64748B);

  String amountStr = "0.00";
  final TextEditingController merchant = TextEditingController();
  String? category;

  final categories = const [
    "Food",
    "Transport",
    "Utilities",
    "Health",
    "Shopping",
    "Subscriptions",
    "Other",
  ];

  @override
  void dispose() {
    merchant.dispose();
    super.dispose();
  }

  void _tapKey(String k) {
    setState(() {
      // Keep only digits + one dot, format to 2 decimals
      if (k == "<") {
        if (amountStr.isNotEmpty) {
          final raw = amountStr.replaceAll(".", "");
          final cut = raw.isNotEmpty ? raw.substring(0, raw.length - 1) : "";
          final padded = cut.padLeft(3, "0");
          final v = "${padded.substring(0, padded.length - 2)}.${padded.substring(padded.length - 2)}";
          amountStr = _trimLeading(v);
        }
        return;
      }

      if (k == ".") return; // we don’t need dot, keypad is cents-based

      final raw = amountStr.replaceAll(".", "");
      final nextRaw = (raw + k).replaceFirst(RegExp(r'^0+'), "");
      final padded = nextRaw.padLeft(3, "0");
      final v = "${padded.substring(0, padded.length - 2)}.${padded.substring(padded.length - 2)}";
      amountStr = _trimLeading(v);
    });
  }

  String _trimLeading(String v) {
    // keep at least "0.xx"
    final parts = v.split(".");
    var left = parts[0];
    if (left.length > 1) left = left.replaceFirst(RegExp(r'^0+'), "");
    if (left.isEmpty) left = "0";
    return "$left.${parts[1]}";
    }

  @override
  Widget build(BuildContext context) {
    final canSave = (amountStr != "0.00") && merchant.text.trim().isNotEmpty && category != null;

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: Column(
          children: [
            // Top bar: X, title, cancel
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(Icons.close, color: Color(0xFF334155)),
                    ),
                  ),
                  const Spacer(),
                  Text("New Transaction",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: textDark)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: TextStyle(color: teal, fontWeight: FontWeight.w900)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Amount block
            Text("AMOUNT",
                style: TextStyle(color: muted, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("\$",
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: teal)),
                Text(amountStr,
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: textDark)),
              ],
            ),

            const SizedBox(height: 16),

            // Merchant + Category fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.storefront_rounded, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: merchant,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Where did you spend?",
                            ),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.category_rounded, color: teal),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: category,
                              hint: const Text("Select category",
                                  style: TextStyle(fontWeight: FontWeight.w800)),
                              items: categories
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c, style: const TextStyle(fontWeight: FontWeight.w800)),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => category = v),
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Receipt / Voice / Split buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickCircleAction(
                    label: "Receipt",
                    icon: Icons.receipt_long_rounded,
                    onTap: () {
                      // TODO later: open camera + OCR
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Receipt capture (camera + OCR) — backend later.")),
                      );
                    },
                  ),
                  _QuickCircleAction(
                    label: "Voice",
                    icon: Icons.mic_rounded,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Voice input — backend later.")),
                      );
                    },
                  ),
                  _QuickCircleAction(
                    label: "Split",
                    icon: Icons.group_add_rounded,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Split transaction — backend later.")),
                      );
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Keypad
            _Keypad(onTap: _tapKey),

            // Save button
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: canSave
                      ? () {
                          // TODO later: persist transaction
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Saved: \$${amountStr} • ${merchant.text} • $category")),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: const Text("SAVE TRANSACTION", style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickCircleAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickCircleAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: teal.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  final void Function(String) onTap;
  const _Keypad({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final keys = const [
      "1","2","3",
      "4","5","6",
      "7","8","9",
      ".","0","<",
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 6, 32, 6),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.55,
        ),
        itemBuilder: (_, i) {
          final k = keys[i];
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onTap(k),
            child: Center(
              child: k == "<"
                  ? const Icon(Icons.backspace_outlined)
                  : Text(
                      k,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
            ),
          );
        },
      ),
    );
  }
}
