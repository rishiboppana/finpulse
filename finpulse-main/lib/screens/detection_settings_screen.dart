import 'package:flutter/material.dart';

import '../services/native_detection_service.dart';

/// Settings screen for managing detection permissions
class DetectionSettingsScreen extends StatefulWidget {
  const DetectionSettingsScreen({super.key});

  @override
  State<DetectionSettingsScreen> createState() => _DetectionSettingsScreenState();
}

class _DetectionSettingsScreenState extends State<DetectionSettingsScreen> {
  bool _notificationListenerEnabled = false;
  bool _accessibilityEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    setState(() => _isLoading = true);
    
    final status = await NativeDetectionService.instance.getServiceStatus();
    
    if (mounted) {
      setState(() {
        _notificationListenerEnabled = status['notificationListener'] ?? false;
        _accessibilityEnabled = status['accessibility'] ?? false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF29D6C7);
    const textDark = Color(0xFF0F172A);
    const muted = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Detection Settings',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: teal.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: teal, size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Real-Time Detection',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Enable these permissions for instant transaction capture from UPI apps.',
                                style: TextStyle(color: muted, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Notification Listener
                  _PermissionCard(
                    icon: Icons.notifications_active_rounded,
                    iconColor: const Color(0xFF6366F1),
                    title: 'Notification Access',
                    subtitle: 'Capture payment notifications from PhonePe, GPay, Paytm',
                    isEnabled: _notificationListenerEnabled,
                    onTap: () async {
                      await NativeDetectionService.instance.openNotificationListenerSettings();
                      // Refresh status after returning
                      await Future.delayed(const Duration(seconds: 1));
                      _loadStatus();
                    },
                  ),

                  const SizedBox(height: 16),

                  // Accessibility Service
                  _PermissionCard(
                    icon: Icons.accessibility_new_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Accessibility Service',
                    subtitle: 'Instant detection on payment success screens',
                    isEnabled: _accessibilityEnabled,
                    privacyNote: 'Only monitors PhonePe & GPay. No keystrokes logged.',
                    onTap: () async {
                      await NativeDetectionService.instance.openAccessibilitySettings();
                      // Refresh status after returning
                      await Future.delayed(const Duration(seconds: 1));
                      _loadStatus();
                    },
                  ),

                  const SizedBox(height: 32),

                  // Privacy section
                  const Text(
                    'PRIVACY',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: muted,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PrivacyRow(
                          icon: Icons.shield_rounded,
                          text: 'Only monitors specific UPI apps',
                        ),
                        SizedBox(height: 12),
                        _PrivacyRow(
                          icon: Icons.visibility_off_rounded,
                          text: 'No keystroke or password logging',
                        ),
                        SizedBox(height: 12),
                        _PrivacyRow(
                          icon: Icons.phone_android_rounded,
                          text: 'All data stays on your device',
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

class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isEnabled;
  final String? privacyNote;
  final VoidCallback onTap;

  const _PermissionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
    this.privacyNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const textDark = Color(0xFF0F172A);
    const muted = Color(0xFF64748B);
    const green = Color(0xFF10B981);
    const red = Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isEnabled ? green.withOpacity(0.1) : red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isEnabled ? Icons.check_circle : Icons.cancel,
                      size: 14,
                      color: isEnabled ? green : red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isEnabled ? 'ON' : 'OFF',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        color: isEnabled ? green : red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (privacyNote != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.privacy_tip_rounded, size: 16, color: Color(0xFFD97706)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      privacyNote!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled ? muted.withOpacity(0.1) : iconColor,
                foregroundColor: isEnabled ? muted : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isEnabled ? 'Manage Settings' : 'Enable Now',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PrivacyRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    const muted = Color(0xFF64748B);
    const green = Color(0xFF10B981);

    return Row(
      children: [
        Icon(icon, size: 20, color: green),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: muted, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
