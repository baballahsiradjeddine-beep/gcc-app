import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/exceptions/exception_data.dart';

class ExceptionMessages {
  static const String generalMessage = 'Une erreur est survenue.';

  static const Map<AppExceptionType, ExceptionData> _exceptionData = {
    AppExceptionType.network: ExceptionData(
      title: 'خطأ في الشبكة',
      message: 'تحقق من اتصالك بالإنترنت',
    ),
    AppExceptionType.server: ExceptionData(
      title: 'خطأ في الخادم',
      message: 'حاول مرة أخرى لاحقًا',
    ),
    AppExceptionType.wrongCredentials: ExceptionData(
      title: 'خطأ في المصادقة',
      message: 'تحقق من بريدك الإلكتروني وكلمة المرور',
    ),
    AppExceptionType.login: ExceptionData(
      title: 'خطأ في تسجيل الدخول',
      message: 'تحقق من بريدك الإلكتروني وكلمة المرور',
    ),
    AppExceptionType.register: ExceptionData(
      title: 'خطأ في التسجيل',
      message: 'حاول مرة أخرى لاحقًا',
    ),
    AppExceptionType.emailExists: ExceptionData(
      title: 'خطأ في البريد الإلكتروني',
      message: 'البريد الإلكتروني مستخدم بالفعل',
    ),
    AppExceptionType.phoneExists: ExceptionData(
      title: 'خطأ في رقم الهاتف',
      message: 'رقم الهاتف مستخدم بالفعل',
    ),
    AppExceptionType.emailNotExists: ExceptionData(
      title: 'خطأ في البريد الإلكتروني',
      message: 'البريد الإلكتروني غير موجود',
    ),
    AppExceptionType.cardNotValid: ExceptionData(
      title: 'خطأ في البطاقة',
      message: 'أعد المحاولة وتأكد من صحة الرمز',
    ),
    AppExceptionType.emailNotVerified: ExceptionData(
      title: 'البريد الإلكتروني غير مفعل',
      message: 'يرجى تفعيل بريدك الإلكتروني للمتابعة',
    ),
    AppExceptionType.alreadyPendingRequest: ExceptionData(
      title: 'طلب معلق',
      message: 'لديك طلب معلق قيد المعالجة',
    ),
    AppExceptionType.invalidPromoCode: ExceptionData(
      title: 'رمز ترويجي غير صالح',
      message: 'الرجاء التحقق من صحة الرمز الترويجي',
    ),
  };

  static ExceptionData getData(AppExceptionType type) {
    return _exceptionData[type] ??
        const ExceptionData(title: 'Erreur', message: generalMessage);
  }
}
