import 'dart:async';

import 'package:access_control/core/access_control.dart';
import 'package:access_control/core/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(
    fileName: '.env',
  );

  final useCloudflare =
      dotenv.get('USE_CLOUDFLARE', fallback: 'false').trim().toLowerCase() ==
          'true';
  final supabaseUrl =
      dotenv.get(useCloudflare ? 'CLOUDFLARE_WORKER_URL' : 'SUPABASE_URL');
  final supabaseAnonKey = dotenv.get('SUPABASE_ANON');

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(
      localStorage: SecureStorageService(),
    ),
  );

  runApp(
    const ProviderScope(
      child: AccessControl(),
    ),
  );
}
