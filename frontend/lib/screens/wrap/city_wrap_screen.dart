import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/wrapped_service.dart';
import 'recent_scan_tile.dart';

class CityWrapScreen extends StatefulWidget {
  final String cityName;

  const CityWrapScreen({super.key, required this.cityName});

  @override
  State<CityWrapScreen> createState() => _CityWrapScreenState();
}

class _CityWrapScreenState extends State<CityWrapScreen> {
  final WrappedService _service = WrappedService();
  Future<List<Map<String, dynamic>>>? _future;

  static const Color _titleColor = Color(0xFF363E44);
  static const Color _muted = Color(0xFF9CA3AF);

  static const TextStyle _appBarTilt = TextStyle(
    color: _titleColor,
    fontFamily: 'Tilt Warp',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle _emptyStateComfortaa = TextStyle(
    color: _muted,
    fontFamily: 'Comfortaa',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  String get _normalizedCity => widget.cityName.trim();

  bool get _isUnknownCity {
    final c = _normalizedCity.toLowerCase();
    return c.isEmpty || c == 'unknown' || c == 'n/a' || c == 'null';
  }

  String _formatTime(dynamic ts) {
    if (ts == null) return '';
    final dt = DateTime.tryParse(ts.toString());
    final local = (dt ?? DateTime.now()).toLocal();

    int h = local.hour;
    final ampm = h >= 12 ? 'PM' : 'AM';
    h = h % 12 == 0 ? 12 : h % 12;
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m $ampm';
  }

  @override
  void initState() {
    super.initState();

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    // ✅ Nếu cityName là Unknown/rỗng -> không fetch, không show list
    if (_isUnknownCity) return;

    // ✅ Chỉ fetch 1 lần
    _future = _service.fetchCityScans(
      userId: user.id,
      city: _normalizedCity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('Please log in first.', style: _emptyStateComfortaa),
        ),
      );
    }

    // ✅ Nếu cityName là Unknown/rỗng -> show explanation screen
    if (_isUnknownCity) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: _titleColor),
          title: const Text('Unknown location', style: _appBarTilt),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'These scans don’t have city information yet.\n\n'
              'This usually happens when location (lat/lng) wasn’t saved or reverse-geocoding failed.',
              textAlign: TextAlign.center,
              style: _emptyStateComfortaa,
            ),
          ),
        ),
      );
    }

    // ✅ Nếu vì lý do nào đó _future chưa set (hiếm), set 1 lần
    _future ??= _service.fetchCityScans(userId: user.id, city: _normalizedCity);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _titleColor),
        title: Text(_normalizedCity, style: _appBarTilt),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text(
                'Error: ${snap.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final scans = snap.data ?? const [];
          if (scans.isEmpty) {
            return const Center(
              child: Text(
                'No scans in this city yet.',
                style: _emptyStateComfortaa,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scans.length,
            itemBuilder: (context, i) {
              final s = scans[i];
              final title = (s['landmark_name'] ?? 'Unknown').toString();
              final time = _formatTime(s['timestamp']);
              final thumb = s['image_url']?.toString();

              return RecentScanTile(
                title: title,
                subtitle: time, // ✅ time only
                thumbnailUrl: thumb,
                onTap: () {
                  // TODO: navigate to detail/result screen if you want
                },
              );
            },
          );
        },
      ),
    );
  }
}
