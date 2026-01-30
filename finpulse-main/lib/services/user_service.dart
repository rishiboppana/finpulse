import '../models/user.dart';
import 'auth_service.dart';
import 'storage_service.dart';

/// User profile service for managing user data.
/// Separate from auth to follow single responsibility principle.
/// 
/// Future: Migrate to Firestore for user profile storage.
abstract class UserServiceBase {
  Future<User?> getProfile();
  Future<User> updateProfile({String? name, String? avatarUrl});
  Future<void> deleteAccount();
}

/// Mock implementation that works with MockAuthService
class MockUserService implements UserServiceBase {
  final MockAuthService _authService;
  final StorageService _storage;

  MockUserService({
    required MockAuthService authService,
    StorageService? storage,
  })  : _authService = authService,
        _storage = storage ?? StorageService();

  @override
  Future<User?> getProfile() async {
    return _authService.getCurrentUser();
  }

  @override
  Future<User> updateProfile({String? name, String? avatarUrl}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    final currentUser = await _authService.getCurrentUser();
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final updatedUser = currentUser.copyWith(
      name: name ?? currentUser.name,
      avatarUrl: avatarUrl ?? currentUser.avatarUrl,
    );

    // Update via auth service to keep data in sync
    return _authService.updateUser(updatedUser);
  }

  @override
  Future<void> deleteAccount() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // In production, this would:
    // 1. Delete user from Firebase Auth
    // 2. Delete user data from Firestore
    // 3. Delete any associated storage files

    await _authService.signOut();
  }
}

/// Factory to create the appropriate user service
UserServiceBase createUserService({
  required MockAuthService authService,
  StorageService? storage,
}) {
  return MockUserService(authService: authService, storage: storage);
}
