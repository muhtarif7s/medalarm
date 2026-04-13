import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/services/database_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return SqfliteDatabaseService();
});
