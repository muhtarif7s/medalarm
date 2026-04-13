// Project imports:
import 'package:myapp/src/features/profile/models/profile.dart';

// For this example, we'll use a mock repository that stores the profile in memory.
// In a real application, this would interact with a database or a remote server.
class ProfileRepository {
  Profile _profile = Profile(name: 'John Doe', email: 'john.doe@example.com');

  Future<Profile> getProfile() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _profile;
  }

  Future<void> updateProfile(Profile profile) async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _profile = profile;
  }
}
