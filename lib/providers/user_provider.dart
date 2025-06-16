import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_ticketing/apis/storage_api.dart';
import 'package:sport_ticketing/apis/user_api.dart';
import 'package:sport_ticketing/models/user_model.dart';
import 'package:sport_ticketing/utils/utils.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});


class UserProfileController extends StateNotifier<bool> {
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  UserProfileController({
    required StorageAPI storageAPI,
    required UserAPI userAPI,
  }) : 
  _storageAPI=storageAPI,
  _userAPI=userAPI,
  super(false);

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? profileFile,
  }) async {
    state = true;

    UserModel updatedUserModel =
        userModel.copyWith(); 

    if (profileFile != null) {
      final profileUrl =
          await _storageAPI.uploadImage('profile', [profileFile]);
      updatedUserModel = updatedUserModel.copyWith(profilePic: profileUrl[0]);
    }

    final res = await _userAPI.updateUserData(updatedUserModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }
  
}
