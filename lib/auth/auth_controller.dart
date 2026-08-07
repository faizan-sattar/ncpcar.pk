import 'package:flutter/foundation.dart';

enum UserRole { user, admin }

class Account {
  final String email;
  final UserRole role;
  final bool banned;
  final DateTime joined;
  final bool isDealer;
  final String? dealerBusinessName;
  final String? dealerCity;
  final String? dealerPhone;

  const Account({
    required this.email,
    required this.role,
    this.banned = false,
    required this.joined,
    this.isDealer = false,
    this.dealerBusinessName,
    this.dealerCity,
    this.dealerPhone,
  });

  Account copyWith({
    bool? banned,
    bool? isDealer,
    String? dealerBusinessName,
    String? dealerCity,
    String? dealerPhone,
  }) =>
      Account(
        email: email,
        role: role,
        banned: banned ?? this.banned,
        joined: joined,
        isDealer: isDealer ?? this.isDealer,
        dealerBusinessName: dealerBusinessName ?? this.dealerBusinessName,
        dealerCity: dealerCity ?? this.dealerCity,
        dealerPhone: dealerPhone ?? this.dealerPhone,
      );
}

/// Holds the signed-in user's email and every account created this session
/// (there's no real backend, so nothing persists past an app restart).
/// Every regular account can both buy and sell — the only distinct role is
/// `admin`, which is never self-registered and signs in separately with a
/// fixed credential.
class AuthController extends ValueNotifier<String?> {
  static const adminEmail = 'admin@ncpcar.pk';
  static const adminPassword = 'admin123';

  AuthController() : super(null) {
    _accounts[adminEmail] = Account(email: adminEmail, role: UserRole.admin, joined: DateTime(2026, 1, 1));
  }

  final Map<String, Account> _accounts = {};

  bool get isSignedIn => value != null;
  UserRole? get currentRole => value != null ? _accounts[value]?.role : null;
  bool get isAdmin => currentRole == UserRole.admin;
  Account? get currentAccount => value != null ? _accounts[value] : null;

  List<Account> get allAccounts => _accounts.values.where((a) => a.role == UserRole.user).toList()
    ..sort((a, b) => b.joined.compareTo(a.joined));

  bool hasAccount(String email) => _accounts.containsKey(_normalize(email));

  /// Registers a new buyer/seller account. Returns false if one already exists.
  bool register(String email) {
    final normalized = _normalize(email);
    if (_accounts.containsKey(normalized)) return false;
    _accounts[normalized] = Account(email: normalized, role: UserRole.user, joined: DateTime.now());
    value = normalized;
    return true;
  }

  /// Signs in an existing buyer/seller account. Returns a [SignInResult]
  /// describing why it failed when it does.
  SignInResult signIn(String email) {
    final normalized = _normalize(email);
    final account = _accounts[normalized];
    if (account == null || account.role == UserRole.admin) return SignInResult.noAccount;
    if (account.banned) return SignInResult.banned;
    value = normalized;
    return SignInResult.success;
  }

  /// Signs in with the fixed admin credential. Returns false if either the
  /// email or password don't match.
  bool signInAdmin(String email, String password) {
    if (_normalize(email) != adminEmail || password != adminPassword) return false;
    value = adminEmail;
    return true;
  }

  /// Marks the signed-in user as a dealer with the given storefront details.
  void registerDealer({required String businessName, required String city, required String phone}) {
    final email = value;
    if (email == null) return;
    final account = _accounts[email];
    if (account == null) return;
    _accounts[email] = account.copyWith(
      isDealer: true,
      dealerBusinessName: businessName,
      dealerCity: city,
      dealerPhone: phone,
    );
    notifyListeners();
  }

  void setBanned(String email, bool banned) {
    final normalized = _normalize(email);
    final account = _accounts[normalized];
    if (account == null || account.role == UserRole.admin) return;
    _accounts[normalized] = account.copyWith(banned: banned);
    notifyListeners();
  }

  void signOut() {
    value = null;
  }

  String _normalize(String email) => email.trim().toLowerCase();
}

enum SignInResult { success, noAccount, banned }

final authController = AuthController();
