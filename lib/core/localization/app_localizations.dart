import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/constants/storage_keys.dart';

// ─── Locale Provider ──────────────────────────────────────────

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('fr')) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(StorageKeys.locale);
    if (saved != null) state = Locale(saved);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.locale, locale.languageCode);
  }
}

// ─── Localizations Config ─────────────────────────────────────

class AppLocalizations {
  AppLocalizations._();

  static const List<Locale> supportedLocales = [
    Locale('fr'),
    Locale('en'),
    Locale('ar'),
  ];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static bool isRTL(Locale locale) => locale.languageCode == 'ar';
}

// ─── Translations ─────────────────────────────────────────────

class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _translations = {
    'fr': {
      // Auth
      'login': 'Connexion',
      'register': "S'inscrire",
      'logout': 'Déconnexion',
      'email': 'Email',
      'password': 'Mot de passe',
      'confirm_password': 'Confirmer le mot de passe',
      'forgot_password': 'Mot de passe oublié ?',
      'first_name': 'Prénom',
      'last_name': 'Nom',
      'phone': 'Téléphone',
      'sign_in_google': 'Continuer avec Google',
      'no_account': "Pas de compte ? S'inscrire",
      'have_account': 'Déjà un compte ? Se connecter',

      // Roles
      'client': 'Client',
      'provider': 'Prestataire',
      'company': 'Entreprise',
      'admin': 'Administrateur',
      'choose_role': 'Choisissez votre rôle',

      // Navigation
      'home': 'Accueil',
      'search': 'Rechercher',
      'messages': 'Messages',
      'profile': 'Profil',
      'notifications': 'Notifications',

      // Jobs
      'jobs': 'Offres d\'emploi',
      'post_job': 'Publier une offre',
      'apply': 'Postuler',
      'applications': 'Candidatures',
      'job_title': 'Titre du poste',
      'description': 'Description',
      'location': 'Localisation',
      'salary': 'Salaire',
      'category': 'Catégorie',

      // Profile
      'edit_profile': 'Modifier le profil',
      'skills': 'Compétences',
      'portfolio': 'Portfolio',
      'reviews': 'Avis',
      'verified': 'Vérifié',
      'premium': 'Premium',
      'availability': 'Disponibilité',
      'rate': 'Tarif',

      // General
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'confirm': 'Confirmer',
      'delete': 'Supprimer',
      'edit': 'Modifier',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'success': 'Succès',
      'retry': 'Réessayer',
      'no_results': 'Aucun résultat',
      'see_all': 'Voir tout',
      'send': 'Envoyer',
      'report': 'Signaler',
      'block': 'Bloquer',
      'share': 'Partager',
      'favorites': 'Favoris',
      'settings': 'Paramètres',
      'language': 'Langue',
      'theme': 'Thème',
      'dark_mode': 'Mode sombre',
      'light_mode': 'Mode clair',

      // Onboarding
      'onboarding_1_title': 'Trouvez le bon talent',
      'onboarding_1_desc': 'Accédez à des milliers de prestataires qualifiés au Tchad.',
      'onboarding_2_title': 'Recrutement simplifié',
      'onboarding_2_desc': 'Publiez vos offres et recevez des candidatures rapidement.',
      'onboarding_3_title': 'Connecté en temps réel',
      'onboarding_3_desc': 'Chattez directement avec les prestataires et clients.',
      'get_started': 'Commencer',
      'next': 'Suivant',
      'skip': 'Passer',

      // Additional keys
      'my_posted_jobs': 'Mes offres publiées',
      'received_applications': 'Candidatures reçues',
      'my_applications': 'Mes candidatures',
      'my_reviews': 'Mes avis reçus',
      'help_support': 'Aide et support',
      'available': 'Disponible',
      'unavailable': 'Indisponible',
      'welcome_message': 'Bienvenue sur TchadOpportunité',
      'email_required': 'Email requis',
      'email_invalid': 'Email invalide',
      'password_required': 'Mot de passe requis',
      'password_min_length': 'Minimum 6 caractères',
      'or': 'ou',
      'no_account_signup': "Pas de compte ? ",
      'have_account_login': "Déjà un compte ? ",
      'registering_as': "Vous vous inscrivez en tant que : ",
      'required': 'Requis',
      'phone_optional': 'Téléphone (optionnel)',
      'continue': 'Continuer',
      'what_is_your_role': 'Quel est votre rôle ?',
      'choose_role_desc': 'Choisissez comment vous souhaitez utiliser TchadOpportunité.',
      'role_client_desc': 'Je cherche des prestataires ou des services',
      'role_provider_desc': 'Je propose mes compétences et services',
      'role_company_desc': 'Je recrute des talents et publie des offres',
    },
    'en': {
      // Auth
      'login': 'Login',
      'register': 'Sign Up',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot password?',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'phone': 'Phone',
      'sign_in_google': 'Continue with Google',
      'no_account': "No account? Sign Up",
      'have_account': 'Already have an account? Login',

      // Roles
      'client': 'Client',
      'provider': 'Provider',
      'company': 'Company',
      'admin': 'Administrator',
      'choose_role': 'Choose your role',

      // Navigation
      'home': 'Home',
      'search': 'Search',
      'messages': 'Messages',
      'profile': 'Profile',
      'notifications': 'Notifications',

      // Jobs
      'jobs': 'Job Offers',
      'post_job': 'Post a Job',
      'apply': 'Apply',
      'applications': 'Applications',
      'job_title': 'Job Title',
      'description': 'Description',
      'location': 'Location',
      'salary': 'Salary',
      'category': 'Category',

      // Profile
      'edit_profile': 'Edit Profile',
      'skills': 'Skills',
      'portfolio': 'Portfolio',
      'reviews': 'Reviews',
      'verified': 'Verified',
      'premium': 'Premium',
      'availability': 'Availability',
      'rate': 'Rate',

      // General
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'delete': 'Delete',
      'edit': 'Edit',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'retry': 'Retry',
      'no_results': 'No results',
      'see_all': 'See all',
      'send': 'Send',
      'report': 'Report',
      'block': 'Block',
      'share': 'Share',
      'favorites': 'Favorites',
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',

      // Onboarding
      'onboarding_1_title': 'Find the Right Talent',
      'onboarding_1_desc': 'Access thousands of qualified providers in Chad.',
      'onboarding_2_title': 'Simplified Recruitment',
      'onboarding_2_desc': 'Post your offers and receive applications quickly.',
      'onboarding_3_title': 'Connected in Real Time',
      'onboarding_3_desc': 'Chat directly with providers and clients.',
      'get_started': 'Get Started',
      'next': 'Next',
      'skip': 'Skip',

      // Additional keys
      'my_posted_jobs': 'My posted jobs',
      'received_applications': 'Received applications',
      'my_applications': 'My applications',
      'my_reviews': 'My reviews',
      'help_support': 'Help and support',
      'available': 'Available',
      'unavailable': 'Unavailable',
      'welcome_message': 'Welcome to TchadOpportunité',
      'email_required': 'Email required',
      'email_invalid': 'Invalid email',
      'password_required': 'Password required',
      'password_min_length': 'Minimum 6 characters',
      'or': 'or',
      'no_account_signup': "Don't have an account? ",
      'have_account_login': "Already have an account? ",
      'registering_as': "You're signing up as: ",
      'required': 'Required',
      'phone_optional': 'Phone (optional)',
      'continue': 'Continue',
      'what_is_your_role': 'What is your role?',
      'choose_role_desc': 'Choose how you want to use TchadOpportunité.',
      'role_client_desc': 'I am looking for providers or services',
      'role_provider_desc': 'I offer my skills and services',
      'role_company_desc': 'I recruit talent and post job offers',
    },
    'ar': {
      // Auth
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب',
      'logout': 'تسجيل الخروج',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'first_name': 'الاسم الأول',
      'last_name': 'اسم العائلة',
      'phone': 'الهاتف',
      'sign_in_google': 'المتابعة مع Google',
      'no_account': 'ليس لديك حساب؟ سجّل',
      'have_account': 'لديك حساب؟ سجّل دخولك',

      // Roles
      'client': 'عميل',
      'provider': 'مزود خدمة',
      'company': 'شركة',
      'admin': 'مدير',
      'choose_role': 'اختر دورك',

      // Navigation
      'home': 'الرئيسية',
      'search': 'بحث',
      'messages': 'الرسائل',
      'profile': 'الملف الشخصي',
      'notifications': 'الإشعارات',

      // Jobs
      'jobs': 'عروض العمل',
      'post_job': 'نشر وظيفة',
      'apply': 'تقدم',
      'applications': 'الطلبات',
      'job_title': 'المسمى الوظيفي',
      'description': 'الوصف',
      'location': 'الموقع',
      'salary': 'الراتب',
      'category': 'الفئة',

      // Profile
      'edit_profile': 'تعديل الملف',
      'skills': 'المهارات',
      'portfolio': 'المعرض',
      'reviews': 'التقييمات',
      'verified': 'موثق',
      'premium': 'مميز',
      'availability': 'التوفر',
      'rate': 'السعر',

      // General
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'delete': 'حذف',
      'edit': 'تعديل',
      'loading': 'جار التحميل...',
      'error': 'خطأ',
      'success': 'نجاح',
      'retry': 'إعادة المحاولة',
      'no_results': 'لا توجد نتائج',
      'see_all': 'عرض الكل',
      'send': 'إرسال',
      'report': 'إبلاغ',
      'block': 'حظر',
      'share': 'مشاركة',
      'favorites': 'المفضلة',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'theme': 'المظهر',
      'dark_mode': 'الوضع الداكن',
      'light_mode': 'الوضع الفاتح',

      // Onboarding
      'onboarding_1_title': 'اعثر على المهارة المناسبة',
      'onboarding_1_desc': 'الوصول إلى آلاف مزودي الخدمات المؤهلين في تشاد.',
      'onboarding_2_title': 'توظيف مبسط',
      'onboarding_2_desc': 'انشر عروضك واستقبل الطلبات بسرعة.',
      'onboarding_3_title': 'متصل في الوقت الفعلي',
      'onboarding_3_desc': 'تواصل مباشرة مع مزودي الخدمات والعملاء.',
      'get_started': 'ابدأ الآن',
      'next': 'التالي',
      'skip': 'تخطي',

      // Additional keys
      'my_posted_jobs': 'وظائفي المنشورة',
      'received_applications': 'الطلبات المستلمة',
      'my_applications': 'طلباتي',
      'my_reviews': 'تقييماتي',
      'help_support': 'المساعدة والدعم',
      'available': 'متاح',
      'unavailable': 'غير متاح',
      'welcome_message': 'مرحباً بك في تشاد أوبورتونيتيه',
      'email_required': 'البريد الإلكتروني مطلوب',
      'email_invalid': 'بريد إلكتروني غير صالح',
      'password_required': 'كلمة المرور مطلوبة',
      'password_min_length': 'الحد الأدنى 6 أحرف',
      'or': 'أو',
      'no_account_signup': 'ليس لديك حساب؟ ',
      'have_account_login': 'لديك حساب؟ ',
      'registering_as': 'أنت تسجل بصفة: ',
      'required': 'مطلوب',
      'phone_optional': 'الهاتف (اختياري)',
      'continue': 'متابعة',
      'what_is_your_role': 'ما هو دورك؟',
      'choose_role_desc': 'اختر كيف تريد استخدام تشاد أوبورتونيتيه.',
      'role_client_desc': 'أبحث عن مزودي خدمات',
      'role_provider_desc': 'أقدم مهاراتي وخدماتي',
      'role_company_desc': 'أبحث عن المواهب وأنشر عروض العمل',
    },
  };

  static String translate(String key, Locale locale) {
    return _translations[locale.languageCode]?[key] ??
        _translations['fr']?[key] ??
        key;
  }
}

// ─── Extension for easy access ────────────────────────────────

extension LocaleExtension on BuildContext {
  String tr(String key) {
    final locale = Localizations.localeOf(this);
    return AppStrings.translate(key, locale);
  }

  bool get isRTL {
    final locale = Localizations.localeOf(this);
    return locale.languageCode == 'ar';
  }
}