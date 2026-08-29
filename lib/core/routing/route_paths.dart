class RoutePaths {
  static const login = '/';
  static const signup = '/signup';
  static const onboarding = '/onboarding';
  static const dashboard = '/home/dashboard';
  static const transactions = '/home/transactions';
  static const insights = '/home/insights';
  static const profile = '/home/profile';
  static const editProfile = '/edit_profile';
  static const changePassword = '/change_password';
  static const categories = '/categories';
  static const addCategory = '/categories/add';
  static String editCategory(String id) => '/categories/edit/$id';
  static const addExpense = '/expenses/add';
  static const addIncome = '/income/add';
  static const notifications = '/notifications';
  static const budget = '/budget';
  static const transactionDetail = '/transactions/:id';
}
