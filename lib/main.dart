import 'package:flutter/material.dart';

void main() => runApp(const FinPulseApp());

class FinPulseApp extends StatelessWidget {
  const FinPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF29D6C7); // teal like screenshot
    return MaterialApp(
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
      home: const MainShell(),
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
  Widget build(BuildContext context) {
    final pages = const [
      DashboardScreen(),
      StatsScreen(),
      PlaceholderScreen(title: "Wallet"),
      SettingsScreen(),
    ];

    return Scaffold(
      body: pages[index],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: "Wallet",
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedAccountChip = 0;
  bool showAllConfirm = false;

  // UI-only data (replace with backend later)
  final List<_ConfirmItem> confirmItems = const [
    _ConfirmItem(merchant: "Starbucks Coffee", amount: "-\$5.50", time: "Today, 09:45 AM"),
    _ConfirmItem(merchant: "Shell Gas Station", amount: "-\$42.10", time: "Today, 07:30 AM"),
    _ConfirmItem(merchant: "Amazon", amount: "-\$29.99", time: "Yesterday, 08:12 PM"),
    _ConfirmItem(merchant: "Target", amount: "-\$64.20", time: "Yesterday, 05:40 PM"),
    _ConfirmItem(merchant: "Apple.com/Bill", amount: "-\$9.99", time: "24 Oct, 2023"),
  ];
  List<_ConfirmItem> _visibleConfirmItems() {
  if (showAllConfirm) return confirmItems;
  return confirmItems.take(3).toList();
}

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar: avatar, title, bell
            Row(
              children: [
                _RoundIcon(
                  icon: Icons.person,
                  onTap: () {},
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
                _RoundIcon(
                  icon: Icons.notifications_none_rounded,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Center spending hero
            Center(
              child: Column(
                children: [
                  Text(
                    "Spent this month",
                    style: TextStyle(
                      fontSize: 16,
                      color: muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "\$3,240.50",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: teal.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.trending_down_rounded,
                            size: 18, color: teal),
                        const SizedBox(width: 6),
                        Text(
                          "-5% from last month",
                          style: TextStyle(
                            color: teal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Account chips row
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _AccountChip(
                    label: "All Accounts",
                    icon: Icons.account_balance_wallet_outlined,
                    selected: selectedAccountChip == 0,
                    onTap: () => setState(() => selectedAccountChip = 0),
                  ),
                  const SizedBox(width: 12),
                  _AccountChip(
                    label: "Savings",
                    icon: Icons.account_balance_outlined,
                    selected: selectedAccountChip == 1,
                    onTap: () => setState(() => selectedAccountChip = 1),
                  ),
                  const SizedBox(width: 12),
                  _AccountChip(
                    label: "Credit",
                    icon: Icons.credit_card_outlined,
                    selected: selectedAccountChip == 2,
                    onTap: () => setState(() => selectedAccountChip = 2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Category Breakdown header
            Row(
              children: [
                Text(
                  "Category Breakdown",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "View Stats",
                    style: TextStyle(
                      color: teal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 10),

            // Category cards row
            SizedBox(
              height: 128,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CategoryCard(
                    icon: Icons.restaurant_rounded,
                    iconBg: Color(0xFFFFF1E7),
                    iconColor: Color(0xFFF97316),
                    title: "Food",
                    amount: "\$840.00",
                  ),
                  SizedBox(width: 14),
                  CategoryCard(
                    icon: Icons.directions_car_rounded,
                    iconBg: Color(0xFFE8F0FF),
                    iconColor: Color(0xFF3B82F6),
                    title: "Transport",
                    amount: "\$320.50",
                  ),
                  SizedBox(width: 14),
                  CategoryCard(
                    icon: Icons.shopping_bag_rounded,
                    iconBg: Color(0xFFF3E8FF),
                    iconColor: Color(0xFF8B5CF6),
                    title: "Shopping",
                    amount: "\$1,120.00",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Spending Trend card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Spending Trend",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(Icons.calendar_month_outlined,
                                size: 16, color: teal),
                            const SizedBox(width: 6),
                            Text(
                              "30 Days",
                              style: TextStyle(
                                color: teal,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Daily average \$108.00",
                      style: TextStyle(color: muted, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 14),
                    const _MiniBarChart(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _AxisLabel("1 OCT"),
                        _AxisLabel("10 OCT"),
                        _AxisLabel("20 OCT"),
                        _AxisLabel("31 OCT"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),
            const SizedBox(height: 22),

            // Confirm Purchases header
            Row(
              children: [
                Text(
                  "Confirm Purchases",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() => showAllConfirm = !showAllConfirm),
                  child: Text(
                    showAllConfirm ? "Show Less" : "See All",
                    style: TextStyle(
                      color: teal,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ..._visibleConfirmItems().map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ConfirmTile(
                          item: item,
                          onConfirm: () async {
                            final result = await showModalBottomSheet<String>(
                              context: context,
                              showDragHandle: true,
                              builder: (_) => _ConfirmBottomSheet(merchant: item.merchant),
                            );

                            if (result != null && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Saved: ${item.merchant} → $result")),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    if (!showAllConfirm && confirmItems.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => setState(() => showAllConfirm = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: teal.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              "Show ${confirmItems.length - 3} more",
                              style: TextStyle(color: teal, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Recent Transactions header
            Row(
              children: [
                Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "See All",
                    style: TextStyle(color: teal, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Recent transactions list
            const TransactionTile(
              icon: Icons.coffee_rounded,
              title: "Starbucks Coffee",
              subtitle: "Today, 09:45 AM",
              amount: "-\$5.50",
            ),
            const SizedBox(height: 12),
            const TransactionTile(
              icon: Icons.shopping_cart_rounded,
              title: "Whole Foods Market",
              subtitle: "Yesterday, 06:20 PM",
              amount: "-\$84.20",
            ),
            const SizedBox(height: 12),
            const TransactionTile(
              icon: Icons.play_circle_fill_rounded,
              title: "Netflix Premium",
              subtitle: "24 Oct, 2023",
              amount: "-\$15.99",
            ),
            const SizedBox(height: 90), // space above bottom nav + FAB
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

            const SizedBox(height: 22),

            // Logout button
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logout action later (backend).")),
                  );
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
  // UI-only mock data (backend later)
  int selectedIndex = 0;

  final List<_AccountItem> accounts = const [
    _AccountItem(
      title: "All Accounts",
      subtitle: "Aggregated balance from 4 links",
      amount: "\$15,050.00",
      icon: Icons.account_balance_wallet_rounded,
      isSummary: true,
    ),
    _AccountItem(
      title: "Main Checking",
      subtitle: "Chase •••• 1234",
      amount: "\$4,250.00",
      icon: Icons.account_balance_rounded,
    ),
    _AccountItem(
      title: "Emergency Fund",
      subtitle: "Ally •••• 5678",
      amount: "\$12,000.00",
      icon: Icons.savings_rounded,
    ),
    _AccountItem(
      title: "Travel Visa",
      subtitle: "Amex •••• 9012",
      amount: "-\$1,200.00",
      icon: Icons.credit_card_rounded,
    ),
    _AccountItem(
      title: "Personal Wallet",
      subtitle: "MetaMask • ETH",
      amount: "0.00 ETH",
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

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
          child: Column(
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

              _AccountCard(
                item: accounts[0],
                selected: selectedIndex == 0,
                teal: teal,
                onTap: () => setState(() => selectedIndex = 0),
              ),

              const SizedBox(height: 18),

              Text("CONNECTED ACCOUNTS", style: TextStyle(color: muted, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
              const SizedBox(height: 10),

              Expanded(
                child: ListView.separated(
                  itemCount: accounts.length - 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final idx = i + 1;
                    return _AccountCard(
                      item: accounts[idx],
                      selected: selectedIndex == idx,
                      teal: teal,
                      onTap: () => setState(() => selectedIndex = idx),
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
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Link account flow later (backend).")),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountItem {
  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final bool isSummary;

  const _AccountItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    this.isSummary = false,
  });
}

class _AccountCard extends StatelessWidget {
  final _AccountItem item;
  final bool selected;
  final Color teal;
  final VoidCallback onTap;

  const _AccountCard({
    required this.item,
    required this.selected,
    required this.teal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? teal : Colors.transparent,
              width: selected ? 2 : 1,
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
                child: Icon(item.icon, color: const Color(0xFF334155)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(item.subtitle, style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(item.amount, style: TextStyle(color: textDark, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  if (selected)
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

  DateTimeRange? selectedRange;
  DateTime? selectedSingleDate;

  // Filters (UI only for now)
  final Map<String, String> filters = {
    "Accounts": "All",
    "Category": "All",
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

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF29D6C7);
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    // Fake stats data (later replace from backend)
    final totalSpent = 3240.50;
    final pie = [
      _PieSlice("Housing", 0.45, const Color(0xFF29D6C7)),
      _PieSlice("Food", 0.25, const Color(0xFF1F2937)),
      _PieSlice("Transport", 0.15, const Color(0xFF334155)),
      _PieSlice("Entertainment", 0.15, const Color(0xFF111827)),
    ];

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
                      delegate: _InsightSearchDelegate(insightsData),
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
              onChanged: (i) => setState(() => rangeIndex = i),
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
                  label: "Category: ${filters["Category"]}",
                  onTap: () => _showQuickPick(
                    title: "Category",
                    options: const ["All", "Food", "Transport", "Housing"],
                    onSelect: (v) => setState(() => filters["Category"] = v),
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

            // Pie / Donut card
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 240,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _DonutChart(slices: pie),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Total Spent",
                                style: TextStyle(
                                  color: muted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "\$${totalSpent.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: textDark,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 16,
                      runSpacing: 10,
                      children: const [
                        _LegendDot(label: "Housing (45%)", color: Color(0xFF29D6C7)),
                        _LegendDot(label: "Food (25%)", color: Color(0xFF1F2937)),
                        _LegendDot(label: "Transport (15%)", color: Color(0xFF334155)),
                        _LegendDot(label: "Entertainment (15%)", color: Color(0xFF111827)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Comparison card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "COMPARISON",
                            style: TextStyle(
                              color: textDark,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Spent vs. last month",
                            style: TextStyle(
                              color: muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                "\$284.15",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: teal.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_downward_rounded, size: 16, color: teal),
                                    const SizedBox(width: 6),
                                    Text(
                                      "8.2%",
                                      style: TextStyle(color: teal, fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    const _MiniComparisonBars(),
                  ],
                ),
              ),
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

            // Insights list (from insightsData so search matches)
            ...insightsData.map(
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
  String? selected;

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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What was this purchase for?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              widget.merchant,
              style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((o) {
                final isSel = selected == o;
                return InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => setState(() => selected = o),
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
                onPressed: selected == null ? null : () => Navigator.pop(context, selected),
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
