// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:myapp/src/features/profile/data/repositories/profile_repository.dart';
import 'package:myapp/src/features/profile/models/profile.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository _profileRepository;

  ProfileProvider(this._profileRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Profile _profile = Profile(name: '', email: '');
  Profile get profile => _profile;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();
    _profile = await _profileRepository.getProfile();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile({required String name, required String email}) async {
    _isLoading = true;
    notifyListeners();
    final updatedProfile = _profile.copyWith(name: name, email: email);
    await _profileRepository.updateProfile(updatedProfile);
    _profile = updatedProfile;
    _isLoading = false;
    notifyListeners();
  }
}
