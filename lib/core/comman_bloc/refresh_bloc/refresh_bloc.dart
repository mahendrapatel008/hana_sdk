import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hana_sdk/core/comman_bloc/refresh_bloc/refresh_event.dart';
import 'package:hana_sdk/core/comman_bloc/refresh_bloc/refresh_state.dart';

class RefreshBloc extends Bloc<RefreshEvent, RefreshState> {
  RefreshBloc() : super(RefreshInitialState()) {
    on<RefreshFormEvent>(_getData);
  }

  FutureOr<void> _getData(RefreshFormEvent event, Emitter<RefreshState> emit) {
    emit(RefreshLoadedState(check: ''));
  }
}
