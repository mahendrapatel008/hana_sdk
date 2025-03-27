

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:hana_sdk/core/comman_bloc/app_bloc/api_data_event.dart';
import 'package:hana_sdk/core/comman_bloc/app_bloc/api_data_state.dart';
import 'package:hana_sdk/core/comman_bloc/app_bloc/model/dynamic_form.dart';
import 'package:hana_sdk/core/elements/dynamic_appbar/dynamic_appbar_model.dart';
import 'package:hana_sdk/core/repo/common_repo.dart';
import 'package:hana_sdk/core/utils/constants.dart';
import 'package:hana_sdk/network/api_result_handler.dart';

class FormBloc extends Bloc<FormEvent, ApiFormState> {
  FormBloc() : super(FormInitialState()) {
    // on<LoadFormEvent>(_onLoadForm);
    on<LoadFormEvent>(_getData);
  }

  final CommonRepository _repo = CommonRepository();

  // Handle form loading
  // Future<void> _onLoadForm(
  //     LoadFormEvent event, Emitter<ApiFormState> emit) async {
  //   emit(FormLoadingState());
  //   try {
  //     String? formJson = await repository.getFormJsonString(
  //       apiToken: event.token,
  //       formCode: event.formCode,
  //     );

  //     if (formJson != null) {
  //       Map<String, dynamic> formJsonData =
  //           formJson.isNotEmpty ? jsonDecode(formJson) : {};
  //       emit(FormLoadedState(formJson: formJsonData, formData: const {}));
  //     } else {
  //       emit(const FormErrorState(errorMessage: 'Error loading form'));
  //     }
  //   } catch (e) {
  //     emit(FormErrorState(errorMessage: e.toString()));
  //   }
  // }

  Future<void> _getData(
    LoadFormEvent event,
    Emitter<ApiFormState> emit,
  ) async {
    emit(FormLoadingState());
    print('TokenViaEvent${event.token}');
    print('FormCodeViaEvent${event.formCode}');

    Either<ApiFailure, Map<String, dynamic>> mainDataResponse =
        await _repo.getData(
      collectionName: dynamic_app,
      query: {"_id": event.formCode},
      projection: {},
      limit: 100,
    );

    await mainDataResponse.fold(
      (failure) async => emit(FormErrorState(errorMessage: failure.message)),
      (responseData) async {
        DynamicForm formJsonData;
        if (responseData.isNotEmpty) {
          // Await the asynchronous fromJson method
          formJsonData = await DynamicForm.fromJson(responseData, true);
        } else {
          // Create an empty DynamicForm object if the response is empty
          formJsonData = DynamicForm(
            name: '',
            form: [],
            dynamicAppbar: DynamicAppbarModel(),
          );
        }
        emit(FormLoadedState(formJson: formJsonData, formData: const {}));
      },
    );
  }
}
