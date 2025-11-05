import 'package:flutter_query/flutter_query.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 🔹 Shared cache for all queries across the app
final queryClientProvider = Provider<QueryClient>((ref) {
  return QueryClient();
});
