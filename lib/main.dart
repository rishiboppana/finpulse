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
      PlaceholderScreen(title: "Stats"),
      PlaceholderScreen(title: "Wallet"),
      PlaceholderScreen(title: "Settings"),
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
