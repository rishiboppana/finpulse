import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Permission Onboarding Screen - First thing users see
/// Explains what data is collected and requests permissions step-by-step
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Permission states
  bool _smsPermissionGranted = false;
  bool _notificationPermissionGranted = false;
  bool _accessibilityEnabled = false;

  static const platform = MethodChannel('com.finpulse/permissions');

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Welcome to FinPulse',
      subtitle: 'Your AI-Powered Finance Companion',
      description: 'Track expenses automatically, get smart insights, and take control of your money — all in seconds.',
      color: Color(0xFF6366F1),
      iconColor: Colors.white,
    ),
    OnboardingPage(
      icon: Icons.sms_rounded,
      title: 'SMS Access',
      subtitle: 'Automatic Transaction Detection',
      description: 'We read bank SMS messages to detect transactions instantly. Your data stays on your device and is never shared.',
      color: Color(0xFF10B981),
      iconColor: Colors.white,
      permissionType: PermissionType.sms,
    ),
    OnboardingPage(
      icon: Icons.notifications_active_rounded,
      title: 'Notification Access',
      subtitle: 'Real-time UPI Alerts',
      description: 'Get notified about transactions from GPay, PhonePe, and other UPI apps. Categorize spending in the 10-second golden window!',
      color: Color(0xFFF59E0B),
      iconColor: Colors.white,
      permissionType: PermissionType.notification,
    ),
    OnboardingPage(
      icon: Icons.accessibility_new_rounded,
      title: 'Accessibility Service',
      subtitle: 'Screen-Level Detection',
      description: 'This optional feature reads payment screens for instant capture. All processing happens locally on your device.',
      color: Color(0xFFEC4899),
      iconColor: Colors.white,
      permissionType: PermissionType.accessibility,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _requestPermission(PermissionType type) async {
    try {
      switch (type) {
        case PermissionType.sms:
          final result = await platform.invokeMethod('requestSmsPermission');
          setState(() => _smsPermissionGranted = result == true);
          break;
        case PermissionType.notification:
          final result = await platform.invokeMethod('requestNotificationPermission');
          setState(() => _notificationPermissionGranted = result == true);
          break;
        case PermissionType.accessibility:
          await platform.invokeMethod('openAccessibilitySettings');
          // Check after a delay (user might enable it)
          await Future.delayed(const Duration(seconds: 2));
          final enabled = await platform.invokeMethod('isAccessibilityEnabled');
          setState(() => _accessibilityEnabled = enabled == true);
          break;
      }
    } on PlatformException catch (e) {
      debugPrint('Permission error: $e');
    }
  }

  bool _isPermissionGranted(PermissionType? type) {
    if (type == null) return true;
    switch (type) {
      case PermissionType.sms:
        return _smsPermissionGranted;
      case PermissionType.notification:
        return _notificationPermissionGranted;
      case PermissionType.accessibility:
        return _accessibilityEnabled;
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _pages[_currentPage].color.withOpacity(0.1),
              Colors.white,
              _pages[_currentPage].color.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      _currentPage == _pages.length - 1 ? '' : 'Skip',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              
              // Page indicators
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 32 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? _pages[_currentPage].color
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Action buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: _buildActionButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    final isGranted = _isPermissionGranted(page.permissionType);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        page.color,
                        page.color.withOpacity(0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: page.color.withOpacity(0.4),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        page.icon,
                        size: 64,
                        color: page.iconColor,
                      ),
                      if (page.permissionType != null && isGranted)
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green[600],
                              size: 28,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 48),
          
          // Title
          Text(
            page.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            page.subtitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: page.color,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Privacy badge
          if (page.permissionType != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 18, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Data stays on your device',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final currentPageData = _pages[_currentPage];
    final hasPermission = currentPageData.permissionType != null;
    final isGranted = _isPermissionGranted(currentPageData.permissionType);
    final isLastPage = _currentPage == _pages.length - 1;
    
    if (hasPermission && !isGranted) {
      // Show "Grant Permission" button
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _requestPermission(currentPageData.permissionType!),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentPageData.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getPermissionIcon(currentPageData.permissionType!)),
                  const SizedBox(width: 8),
                  Text(
                    _getPermissionButtonText(currentPageData.permissionType!),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _nextPage,
            child: Text(
              isLastPage ? 'Skip & Start' : 'Skip for now',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    }
    
    // Show "Next" or "Get Started" button
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: currentPageData.color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastPage ? 'Get Started' : 'Next',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(isLastPage ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded),
          ],
        ),
      ),
    );
  }

  IconData _getPermissionIcon(PermissionType type) {
    switch (type) {
      case PermissionType.sms:
        return Icons.sms_rounded;
      case PermissionType.notification:
        return Icons.notifications_active_rounded;
      case PermissionType.accessibility:
        return Icons.accessibility_new_rounded;
    }
  }

  String _getPermissionButtonText(PermissionType type) {
    switch (type) {
      case PermissionType.sms:
        return 'Allow SMS Access';
      case PermissionType.notification:
        return 'Enable Notifications';
      case PermissionType.accessibility:
        return 'Open Settings';
    }
  }
}

enum PermissionType { sms, notification, accessibility }

class OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final Color iconColor;
  final PermissionType? permissionType;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.iconColor,
    this.permissionType,
  });
}
