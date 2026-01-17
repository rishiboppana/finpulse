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





// Below is the code for stats screen

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // Time range tabs like the reference
  int rangeIndex = 2; // 0 Daily, 1 Weekly, 2 Monthly, 3 Yearly

  // Filters (UI only for now)
  final Map<String, String> filters = {
    "Accounts": "All",
    "Category": "All",
    "Dates": "Last 30d",
    "Type": "All",
  };

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
                _RoundIcon(icon: Icons.calendar_month_outlined, onTap: () {}),
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
                _RoundIcon(icon: Icons.search, onTap: () {}),
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
                  onTap: () => _showQuickPick(
                    title: "Dates",
                    options: const ["Last 7d", "Last 30d", "This Month", "Custom"],
                    onSelect: (v) => setState(() => filters["Dates"] = v),
                  ),
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

            // Pie / Donut card (like the reference)
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
                    const SizedBox(height  : 6),
                    // Legend (2 columns like the reference)
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

            // Insights list (like reference)
            const InsightTile(
              icon: Icons.coffee_rounded,
              iconBg: Color(0xFFFFF1E7),
              iconColor: Color(0xFFF97316),
              titleBold: "You spent ",
              highlight: "15% more",
              titleRest: " on Coffee this week than your average.",
              subtitle: "That’s about \$12.50 extra.",
            ),
            const SizedBox(height: 12),
            const InsightTile(
              icon: Icons.check_circle_rounded,
              iconBg: Color(0xFFE9FFF9),
              iconColor: Color(0xFF10B981),
              titleBold: "Great job! You are ",
              highlight: "\$200 under",
              titleRest: " your dining budget this month.",
              subtitle: "Keep it up to reach your savings goal.",
            ),
            const SizedBox(height: 12),
            const InsightTile(
              icon: Icons.notifications_active_rounded,
              iconBg: Color(0xFFE8F0FF),
              iconColor: Color(0xFF3B82F6),
              titleBold: "Subscription Alert: ",
              highlight: "Netflix",
              titleRest: " increased by \$2.00 starting next cycle.",
              subtitle: "Detected in your recurring payments.",
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

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

// ---------- Helper widgets for Stats screen ----------

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

class InsightTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String titleBold;
  final String highlight;
  final String titleRest;
  final String subtitle;

  const InsightTile({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.titleBold,
    required this.highlight,
    required this.titleRest,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: textDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        height: 1.25,
                      ),
                      children: [
                        TextSpan(text: titleBold),
                        TextSpan(
                          text: highlight,
                          style: const TextStyle(
                            color: Color(0xFF29D6C7),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: titleRest),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(subtitle,
                      style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
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
