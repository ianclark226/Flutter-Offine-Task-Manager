import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/repo/auth_remote_repo.dart';
import 'package:frontend/models/user_model.dart';

part 'auth_state.dart';
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthUserInitial());
  final authRemoteRepo = AuthRemoteRepo();

  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      await authRemoteRepo.signUp(name: name, email: email, password: password);
      emit(AuthSignUp());
    } catch(error) {
      emit(AuthError(error.toString()));
    }
  }

  void login({
    required String email,
    required String password,

  }) async {
    try {
      emit(AuthLoading());
      final UserModel = await authRemoteRepo.login(email: email, password: password);
      emit(AuthLoggedIn(UserModel));
    } catch(error) {
      emit(AuthError(error.toString()));
    }
  }
}