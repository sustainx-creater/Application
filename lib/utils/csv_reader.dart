import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

Future<List<Map<String, dynamic>>> loadAccommodationsFromCsv() async {
  try {
    final csvString = await rootBundle.loadString('lib/assets/reduced_columns_data.csv');
    final csvParser = CsvToListConverter(
      eol: '\n',
      fieldDelimiter: ',', // Ensure comma is the delimiter
      shouldParseNumbers: false, // Keep numbers as strings for consistency
    );
    final rows = csvParser.convert(csvString);

    if (rows.isEmpty) return [];

    final headers = rows.first.map((e) => e.toString().trim()).toList();
    return [
      for (final row in rows.skip(1))
        Map<String, dynamic>.fromIterables(
          headers,
          row.map((e) => e?.toString().trim() ?? ''),
        )
    ];
  } catch (e) {
    print('Error loading CSV: $e');
    return [];
  }
}