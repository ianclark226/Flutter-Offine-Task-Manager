import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/features/auth/repo/auth_local_repo.dart';
import 'package:frontend/features/auth/repo/auth_remote_repo.dart';
import 'package:frontend/models/user_model.dart';

part 'auth_state.dart';
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthUserInitial());
  final authRemoteRepo = AuthRemoteRepo();
  final authLocalRepo = AuthLocalRepo();
  final spService = SpService();

  void getUserData() async {
    try {
      emit(AuthLoading());
      final userModel = await authRemoteRepo.getUserData();
      if(userModel != null) {
        await authLocalRepo.insertUser(userModel);
        emit(AuthLoggedIn(userModel));
        
      } else {
        emit(AuthUserInitial());
      }

      
    } catch(error) {
      emit(AuthUserInitial());
    }
  }

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
      final userModel = await authRemoteRepo.login(email: email, password: password);

      if(userModel.token.isNotEmpty) {
        await spService.setToken(userModel.token);
      }

      await authLocalRepo.insertUser(userModel);
 
      emit(AuthLoggedIn(userModel));
    } catch(error) {
      emit(AuthError(error.toString()));
    }
  }
}