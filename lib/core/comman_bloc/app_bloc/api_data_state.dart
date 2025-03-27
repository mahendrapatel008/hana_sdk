import 'package:hana_sdk/core/comman_bloc/app_bloc/model/dynamic_form.dart';

abstract class ApiFormState{
  const ApiFormState();

}

// Initial state when the form is first loaded
class FormInitialState extends ApiFormState {
}

// State when the form is loading
class FormLoadingState extends ApiFormState {}

// State when the form is successfully loaded
class FormLoadedState extends ApiFormState {
  final DynamicForm formJson;
  final Map<String, dynamic> formData;

  const FormLoadedState({required this.formJson, required this.formData});

}

// State when there is an error in any process (loading, submitting, etc.)
class FormErrorState extends ApiFormState {
  final String errorMessage;

  const FormErrorState({required this.errorMessage});

}
