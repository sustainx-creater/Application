import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> loadAccommodationsFromCsv() async {
  try {
    final data = await Supabase.instance.client
        .from('accommodations')
        .select();
    return (data as List<dynamic>).cast<Map<String, dynamic>>();
  } catch (e) {
    print('Error loading accommodations: $e');
    return [];
  }
}