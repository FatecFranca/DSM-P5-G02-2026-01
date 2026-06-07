import 'package:go_router/go_router.dart';
import '../../pages/login_page.dart';
import '../../pages/register_page.dart';
import '../../pages/exame_page.dart';
import '../../pages/sugestoes_page.dart';
import '../../pages/rating_page.dart';
import '../../pages/rating_history_page.dart';
import '../../pages/user_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String exames = '/exames';
  static const String sugestoes = '/sugestoes';
  static const String rating = '/rating';
  static const String ratingHistory = '/rating-history';
  static const String user = '/user';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: exames,
        name: 'exames',
        builder: (context, state) => const ExamePage(),
      ),
      GoRoute(
        path: sugestoes,
        name: 'sugestoes',
        builder: (context, state) => const SugestoesPage(),
      ),
      GoRoute(
        path: rating,
        name: 'rating',
        builder: (context, state) => const RatingPage(),
      ),
      GoRoute(
        path: ratingHistory,
        name: 'ratingHistory',
        builder: (context, state) => const RatingHistoryPage(),
      ),
      GoRoute(
        path: user,
        name: 'user',
        builder: (context, state) => const UserPage(),
      ),
    ],
  );
}
