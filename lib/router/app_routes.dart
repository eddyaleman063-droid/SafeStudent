import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/screens/splash_screen.dart';
import '../ui/screens/welcome_screen.dart';

part 'app_routes.g.dart';

@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData {
  const SplashRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashScreen();
}

@TypedGoRoute<WelcomeRoute>(path: '/welcome')
class WelcomeRoute extends GoRouteData {
  const WelcomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const WelcomeScreen();
}
