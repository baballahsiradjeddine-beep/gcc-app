class Validators {
  const Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!value.contains('@')) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    } else if (value.length < 6) {
      return 'يجب أن تكون كلمة المرور مكونة من 6 أحرف على الأقل';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'العمر مطلوب';
    }
    if (int.tryParse(value) == null) {
      return 'يجب أن يحتوي العمر على أرقام فقط';
    }
    if (int.parse(value) < 1 || int.parse(value) > 70) {
      return 'يجب أن يكون العمر بين 1 و 70';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? passwordValue) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != passwordValue) {
      return 'كلمتي السر مختلفتين عن بعض';
    }
    return null;
  }

  static String? nonEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? pinCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    if (value.length < 6) {
      return 'يجب أن يحتوي الرمز على 6 أرقام';
    }

    if (int.tryParse(value) == null) {
      return 'يجب أن يحتوي الرمز على أرقام فقط';
    }
    return null;
  }

  static String? phone(String? value) {
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    if (!phoneRegex.hasMatch(value)) {
      return 'رقم الهاتف غير صالح';
    }

    return null;
  }
}
