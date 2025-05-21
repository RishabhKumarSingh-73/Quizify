import 'package:client/features/auth/models/usermodel.dart';
import 'package:client/features/auth/repository/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
part 'user_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late UserRepository _userRepository;
  @override
  AsyncValue<UserModel>? build() {
    _userRepository = ref.watch(userRepositoryProvider);
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res = await _userRepository.signUp(
      email: email,
      password: password,
      name: name,
    );

    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res = await _userRepository.signIn(email: email, password: password);

    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }

  Future<void> checkSignedIn() async {
    state = AsyncValue.loading();
    final res = await _userRepository.isSignedIn();

    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
  }
}
