part of product_management_app;

enum AuthStatus { checking, unauthenticated, authenticated }

class AuthState {
  const AuthState({required this.status, this.user, this.error, this.isLoading = false});
  final AuthStatus status;
  final User? user;
  final String? error;
  final bool isLoading;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.api) : super(const AuthState(status: AuthStatus.checking));
  final ApiClient api;

  Future<void> checkAuth() async {
    await api.restoreToken();
    if (api.token == null) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }
    try {
      final response = await api.get('/auth/me');
      emit(AuthState(
        status: AuthStatus.authenticated,
        user: User.fromJson(response['data']['user'] as Map<String, dynamic>),
      ));
    } catch (_) {
      await api.clearToken();
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthState(status: state.status, user: state.user, isLoading: true));
    try {
      final response = await api.post('/auth/login', {'email': email, 'password': password});
      await api.saveToken(response['data']['token'].toString());
      emit(AuthState(
        status: AuthStatus.authenticated,
        user: User.fromJson(response['data']['user'] as Map<String, dynamic>),
      ));
    } catch (error) {
      emit(AuthState(status: AuthStatus.unauthenticated, error: error.toString()));
    }
  }

  Future<void> logout() async {
    await api.clearToken();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
