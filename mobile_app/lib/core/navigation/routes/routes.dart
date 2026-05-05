class Routes {
  // MARK: - Auth routes
  static const String auth = '/auth';

  // MARK: - Main app routes
  static const String home = '/';
  static const String accesses = '/accesses';
  static const String accounts = '/accounts';
  static const String userAccessKeys = '/access_keys';
  static const String administration = '/admin';

  // MARK: - App Bar routes
  static const String profile = '/profile';

  // MARK: - Subroutes (relative, used in GoRoute.path)
  static const String accountDetail = ':accountId';
  static const String addAccount = 'add';
  static const String addAccessKey = 'add-access-key';
  static const String editAccessKey = 'edit-access-key';
  static const String selectDevices = 'select-devices';

  // MARK: - Full paths (absolute, used with context.push/go)
  static String accountDetailPath(String accountId) => '$accounts/$accountId';
  static String addAccountPath() => '$accounts/$addAccount';
  static const String addAccessKeyPath = '$accesses/$addAccessKey';
  static String editAccessKeyPath(String id) => '$accesses/$editAccessKey/$id';
  static const String selectDevicesForAddPath =
      '$accesses/$addAccessKey/$selectDevices';
  static String selectDevicesForEditPath(String id) =>
      '$accesses/$editAccessKey/$id/$selectDevices';
}
