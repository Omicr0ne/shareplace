abstract final class AppRoutes {
  static const welcome = '/welcome';
  static const deals = '/deals';
  static const createDeal = '/deals/create';
  static const myDeals = '/deals/mine';
  static const dealHistory = '/deals/history';
  static const legalNotices = '/legal-notices';
  static const notifications = '/notifications';
  static const createReport = '/reports/create';
  static const profile = '/profile';
  static const studentVerification = '/profile/student-verification';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';

  static String dealDetails(String id) => '/deals/$id';
}
