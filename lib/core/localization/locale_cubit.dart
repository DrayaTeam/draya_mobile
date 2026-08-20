import "package:draya_mobile/core/helpers/app_shared_pref_helper.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(Locale(AppSharedPrefHelper.getLanguage()));

  // void loadSavedLanguage() {
  //   final language = AppSharedPrefHelper.getLanguage();
  //   emit(Locale(language));
  // }

  Future<void> toggleLanguage() async {
    final language = await AppSharedPrefHelper.toggleLanguage();
    emit(Locale(language));
  }
}
