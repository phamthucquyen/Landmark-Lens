import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/wrapped_service.dart';

class WrappedScreen extends StatefulWidget {
  const WrappedScreen({super.key});

  @override
  State<WrappedScreen> createState() => _WrappedScreenState();
}

class _WrappedScreenState extends State<WrappedScreen> {
  final WrappedService _service = WrappedService();

  bool _loading = true;
  String? _error;

  int _scansCount = 0;
  int _uniqueLandmarks = 0;
  List<ScanItem> _scans = const [];

  // TODO: replace with real auth user id later
  final String _userId = 'test-user-123';

  @override
  void initState() {
    super.initState();
    _loadWrapped();
  }

  Future<void> _loadWrapped() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final data = await _service.fetchWrapped(userId: _userId);

      final totalScans = (data['total_scans'] as num?)?.toInt() ?? 0;
      final uniqueLandmarks = (data['unique_landmarks'] as num?)?.toInt() ?? 0;

      final items = (data['items'] as List<dynamic>? ?? [])
          .map((e) => e as Map<String, dynamic>)
          .map((m) => ScanItem.fromApi(m))
          .toList();

      setState(() {
        _scansCount = totalScans;
        _uniqueLandmarks = uniqueLandmarks;
        _scans = items;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFAF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Your Journey',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: _loadWrapped,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : (_error != null)
                  ? _ErrorState(message: _error!, onRetry: _loadWrapped)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats tiles
                        Row(
                          children: [
                            Expanded(
                              child: _StatTile(
                                value: _scansCount.toString(),
                                label: 'SCANS',
                                background: const Color(0xFFBFEFE6),
                                foreground: Colors.black,
                                shadow: false,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _StatTile(
                                value: _uniqueLandmarks.toString(),
                                label: 'LANDMARKS',
                                background: const Color(0xFF0B0B0B),
                                foreground: Colors.white,
                                shadow: true,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'RECENT SCANS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: Color(0xFF6B7C78),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child: _scans.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No scans yet.\nGo to Scan tab and try one!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF6B7C78),
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: _scans.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (context, i) {
                                    final s = _scans[i];
                                    return _ScanRow(
                                      title: s.title,
                                      subtitleLeft:
                                          '${s.timeLabel} \u00B7 ${s.category}',
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Open details for: ${s.title}')),
                                        );
                                      },
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

/// Data model for UI
class ScanItem {
  final String title;
  final String timeLabel;
  final String category;

  const ScanItem({
    required this.title,
    required this.timeLabel,
    required this.category,
  });

  factory ScanItem.fromApi(Map<String, dynamic> m) {
    final name = (m['landmark_name'] as String?)?.trim();
    final tags = (m['tags'] as List<dynamic>?) ?? [];
    final ts = m['timestamp'] as String?;

    final category = tags.isNotEmpty ? tags.first.toString() : 'Scan';
    final timeLabel = _formatTime(ts);

    return ScanItem(
      title: (name == null || name.isEmpty) ? 'Unknown' : name,
      timeLabel: timeLabel,
      category: category,
    );
  }

  static String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('h:mm a').format(dt);
    } catch (_) {
      return '—';
    }
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 40),
            const SizedBox(height: 10),
            const Text(
              'Failed to load journey',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7C78)),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color background;
  final Color foreground;
  final bool shadow;

  const _StatTile({
    required this.value,
    required this.label,
    required this.background,
    required this.foreground,
    required this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                )
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: foreground,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: foreground.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanRow extends StatelessWidget {
  final String title;
  final String subtitleLeft;
  final VoidCallback onTap;

  const _ScanRow({
    required this.title,
    required this.subtitleLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFE9F3F1),
                child: Icon(Icons.image, color: Color(0xFF6B7C78)),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 92,
                child: Text(
                  subtitleLeft,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.2,
                    color: Color(0xFF90A4A0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, color: Color(0xFF9AA9A5)),
            ],
          ),
        ),
      ),
    );
  }
}
