import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/sample_entity.dart';
import '../../domain/usecases/get_samples_use_case.dart';

part 'sample_state.dart';

class SampleCubit extends Cubit<SampleState> {
  SampleCubit({required GetSamplesUseCase getSamplesUseCase})
      : _getSamplesUseCase = getSamplesUseCase,
        super(const SampleState.initial());

  final GetSamplesUseCase _getSamplesUseCase;

  Future<void> loadSamples() async {
    emit(state.copyWith(status: SampleStatus.loading));

    final result = await _getSamplesUseCase();

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SampleStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: SampleStatus.success,
          items: items,
        ),
      ),
    );
  }
}


