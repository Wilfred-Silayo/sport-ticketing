import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sport_ticketing/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:uuid/uuid.dart';

final storageAPIProvider = Provider((ref) {
  final supabase = Supabase.instance.client;
  final currentUser = ref.watch(currentUserAccountProvider).value;
  return StorageAPI(supabase: supabase, user: currentUser);
});

class StorageAPI {
  final SupabaseClient _supabase;
  final fb.User? _currentUser;
  final _uuid = const Uuid();

  StorageAPI({
    required SupabaseClient supabase,
    fb.User? user,
  })  : _supabase = supabase,
        _currentUser = user;

  Future<List<String>> uploadImage(String bucketName, List<File> files) async {
    List<String> imageLinks = [];

    for (final file in files) {
      final fileExtension = file.path.split('.').last;
      final fileName = '${_uuid.v4()}.$fileExtension';
      final filePath = '${_currentUser!.uid}/$fileName';

      await _supabase.storage.from('profiles').upload(filePath, file);
      final publicUrl =
          _supabase.storage.from(bucketName).getPublicUrl(filePath);
      imageLinks.add(publicUrl);
    }

    return imageLinks;
  }
}
