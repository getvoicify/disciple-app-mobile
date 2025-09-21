import 'package:auto_route/auto_route.dart';
import 'package:disciple/features/authentication/services/keycloak_service.dart';

class AuthGuard implements AutoRouteGuard {
  AuthGuard(this.keycloakService);

  final KeycloakService keycloakService;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    if (keycloakService.isAuthenticated) {
      resolver.next();
    } else {
      /// TODO: fix this to redirect the user to the login section
      // await router.replace(const HomeboardingRoute());
    }
  }
}
