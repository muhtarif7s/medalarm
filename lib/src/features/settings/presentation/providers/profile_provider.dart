import 'package:flutter/material.dart';
import 'package:myapp/src/features/settings/data/models/profile_model.dart';
import 'package:myapp/src/features/settings/data/repositories/profile_repository.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository _profileRepository;

  Profile? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProfileProvider(this._profileRepository);

  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _profile = await _profileRepository.getProfile();
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile(Profile profile) async {
    try {
      await _profileRepository.saveProfile(profile);
      _profile = profile;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to save profile: $e';
      notifyListeners();
    }
  }
}
