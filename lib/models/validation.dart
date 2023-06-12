import '../data/dbHelper.dart';

class ValidationMixin {
  final dbHelper = DbHelper();

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen Kullanıcı adınızı girin';
    }
  }
}

String? validatePasswordd(String? value) {
  if (value == null || value.isEmpty) {
    return 'Lütfen bir şifre girin';
  }

  return null;
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Lütfen Adınızı girin';
  }
  if (value.length < 3) {
    return 'En az 3 karakter olmalıdır';
  }

  return null;
}

String? validateLastName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Lütfen Soyadınızı girin';
  }
  if (value.length < 3) {
    return 'En az 3 karakter olmalıdır';
  }

  return null;
}

String? validateAddress(String? value) {
  if (value == null || value.isEmpty) {
    return 'Lütfen Adresinizi girin';
  }

  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Telefon numarası boş olamaz';
  }
  if (value.length < 13) {
    return 'Lütfen geçerli bir telefon numarası girin';
  }

  return null;
}



String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Lütfen bir şifre girin';
  }
  if (value.length < 5 || value.length > 10) {
    return 'Şifreniz en az 5 en fazla 10 karakter olmalıdır';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Şifreniz en az bir büyük harf içermelidir';
  }
  if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Şifreniz en az bir küçük harf içermelidir';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Şifreniz en az bir rakam içermelidir';
  }
  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Şifreniz en az bir noktalama işareti içermelidir';
  }
  return null;
}

String? validateForgetPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Lütfen bir e-posta adresi girin';
  }
  if (!value.contains('@')) {
    return 'Lütfen geçerli bir e-posta adresi girin';
  }
  return null;
}

String? validateLetterName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Bu alan boş geçilemez';
  }
  if (value.length < 2) {
    return 'Harf adı en az 2 karakter olmalıdır';
  }
  return null;
}

String? validateLetterAciklama(String? value) {
  if (value == null || value.isEmpty) {
    return 'Bu alan boş geçilemez';
  }
}
