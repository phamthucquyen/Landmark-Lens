import 'package:supabase_flutter/supabase_flutter.dart';

class WrappedService {
  final SupabaseClient _sb = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchWrapped({
    required String userId,
    int limit = 50,
  }) async {
    // Need scans.city in DB
    final rows = await _sb
        .from('scans')
        .select('landmark_name, timestamp, image_url, city')
        .eq('user_id', userId)
        .order('timestamp', ascending: false)
        .limit(limit);

    final scans = List<Map<String, dynamic>>.from(rows);

    // 1) Recent scans (name + time only)
    final recentScans = scans.map((s) {
      return {
        'landmark_name': s['landmark_name'],
        'timestamp': s['timestamp'],
        'image_url': s['image_url'],
        'city': s['city'],
      };
    }).toList();

    // 2) City buckets
    final Map<String, int> buckets = {};
    for (final s in scans) {
      final cityRaw = s['city'];
      final city = (cityRaw == null || cityRaw.toString().trim().isEmpty)
          ? 'Unknown'
          : cityRaw.toString().trim();
      buckets[city] = (buckets[city] ?? 0) + 1;
    }

    final sorted = buckets.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    const colors = [
      '#7ADBCF',
      '#F05B55',
      '#1F8A70',
      '#B8F3EA',
      '#F4B7B2',
    ];

    final cities = <Map<String, dynamic>>[];
    for (var i = 0; i < sorted.length && i < 12; i++) {
      cities.add({
        'name': sorted[i].key,       // ✅ only city name
        'count': sorted[i].value,
        'color_hex': colors[i % colors.length],
      });
    }

    return {
      'cities': cities,
      'recent_scans': recentScans,
    };
  }

  Future<List<Map<String, dynamic>>> fetchCityScans({
    required String userId,
    required String city,
    int limit = 200,
  }) async {
    final rows = await _sb
        .from('scans')
        .select('id, landmark_name, timestamp, image_url, city')
        .eq('user_id', userId)
        .eq('city', city)
        .order('timestamp', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(rows);
  }
}
