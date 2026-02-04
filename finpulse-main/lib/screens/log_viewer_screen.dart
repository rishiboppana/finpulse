import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/app_logger.dart';

/// Debug screen to view application logs
class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({super.key});

  @override
  State<LogViewerScreen> createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  String? _selectedCategory;
  List<LogEntry> _logs = [];
  bool _isLoading = true;

  final List<String?> _categories = [
    null, // All
    AppLogger.categoryDataCollection,
    AppLogger.categoryGemini,
    AppLogger.categoryStorage,
    AppLogger.categoryFeedback,
    AppLogger.categoryDataFlow,
    AppLogger.categoryError,
  ];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    setState(() {
      _logs = AppLogger.instance.getLogs(
        category: _selectedCategory,
        limit: 200,
      );
      _isLoading = false;
    });
  }

  Future<void> _exportLogs() async {
    final path = await AppLogger.instance.exportLogs();
    if (path != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logs exported to: $path')));
    }
  }

  Future<void> _copyLogs() async {
    final logsText = AppLogger.instance.getLogsAsString(
      category: _selectedCategory,
      limit: 100,
    );
    await Clipboard.setData(ClipboardData(text: logsText));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logs copied to clipboard')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = AppLogger.instance.getStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyLogs,
            tooltip: 'Copy logs',
          ),
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: _exportLogs,
            tooltip: 'Export logs',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogs,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats card
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _StatChip(label: 'Total', value: '${stats['totalLogs']}'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: (stats['byCategory'] as Map<String, int>)
                            .entries
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _StatChip(
                                  label: e.key.split('_').first,
                                  value: '${e.value}',
                                  color: _getCategoryColor(e.key),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat ?? 'All'),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                      _loadLogs();
                    },
                    selectedColor: _getCategoryColor(cat),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Logs list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _logs.isEmpty
                ? const Center(child: Text('No logs yet'))
                : ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log =
                          _logs[_logs.length - 1 - index]; // Reverse order
                      return _LogTile(log: log);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case AppLogger.categoryDataCollection:
        return Colors.blue.shade100;
      case AppLogger.categoryGemini:
        return Colors.purple.shade100;
      case AppLogger.categoryStorage:
        return Colors.green.shade100;
      case AppLogger.categoryFeedback:
        return Colors.orange.shade100;
      case AppLogger.categoryDataFlow:
        return Colors.teal.shade100;
      case AppLogger.categoryError:
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatChip({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  final LogEntry log;

  const _LogTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${log.timestamp.hour.toString().padLeft(2, '0')}:'
        '${log.timestamp.minute.toString().padLeft(2, '0')}:'
        '${log.timestamp.second.toString().padLeft(2, '0')}';

    return ExpansionTile(
      leading: _getLevelIcon(log.level),
      title: Text(
        log.message,
        style: const TextStyle(fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '$timeStr | ${log.category}',
        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
      ),
      children: log.data != null
          ? [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  log.data.toString(),
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ),
            ]
          : [],
    );
  }

  Widget _getLevelIcon(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return Icon(Icons.info_outline, color: Colors.blue.shade400, size: 20);
      case LogLevel.warning:
        return Icon(
          Icons.warning_amber,
          color: Colors.orange.shade400,
          size: 20,
        );
      case LogLevel.error:
        return Icon(Icons.error_outline, color: Colors.red.shade400, size: 20);
    }
  }
}
