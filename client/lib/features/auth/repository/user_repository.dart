import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/models/usermodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';
part 'user_repository.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepository();
}

class UserRepository {
  final supabaseClient = Supabase.instance.client;

  Future<Either<AppFailure, UserModel>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final AuthResponse res = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      User? user = res.user;
      if (user != null) {
        return Right(
          UserModel(
            email: user.email.toString(),
            name: user.userMetadata?['name'],
            uid: user.id,
          ),
        );
      }
      return Left(AppFailure("signup error"));
    } on AuthException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  Future<Either<AppFailure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse res = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      User? user = res.user;
      if (user != null) {
        return Right(
          UserModel(
            email: user.email.toString(),
            name: user.userMetadata?['name'],
            uid: user.id,
          ),
        );
      }
      return Left(AppFailure("signin error"));
    } on AuthException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  Future<Either<AppFailure, UserModel>> isSignedIn() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      final user = session?.user;
      if (user != null) {
        return Right(
          UserModel(
            email: user.email.toString(),
            name: user.userMetadata?['name'],
            uid: user.id,
          ),
        );
      }
      return Left(AppFailure("signin error"));
    } on AuthException catch (e) {
      return Left(AppFailure(e.message));
    }
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
