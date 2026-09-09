import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState.initial());

  Future<void> onVideoInitialized() async {
    emit(state.copyWith(status: SplashStatus.playing));
  }

  Future<void> onVideoCompleted() async {
    emit(state.copyWith(status: SplashStatus.completed));
  }

  Future<void> reset() async {
    emit(const SplashState.initial());
  }
}
