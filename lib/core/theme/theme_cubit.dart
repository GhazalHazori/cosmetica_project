import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}

/// Simple theme cubit controlling light/dark/system mode.
///
/// Persistence can be added later via a data source, but the Cubit interface
/// must remain UI-agnostic.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light));

  void setLight() {
    emit(state.copyWith(themeMode: ThemeMode.light));
  }

  void setDark() {
    emit(state.copyWith(themeMode: ThemeMode.dark));
  }

  void setSystem() {
    emit(state.copyWith(themeMode: ThemeMode.system));
  }

  void toggle() {
    if (state.themeMode == ThemeMode.dark) {
      setLight();
    } else {
      setDark();
    }
  }
}

