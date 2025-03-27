import 'dart:io';

abstract class FormEvent{
  const FormEvent();
}

// Event to load the form data
class LoadFormEvent extends FormEvent {
  final String token;
  final String formCode;

  const LoadFormEvent(this.token, this.formCode);

}

// Event to update a form field
class UpdateFormFieldEvent extends FormEvent {
  final String fieldName;
  final dynamic value;

  const UpdateFormFieldEvent(this.fieldName, this.value);

}

// Event to upload a file
class UploadFileEvent extends FormEvent {
  final String fieldName;
  final File file;

  const UploadFileEvent(this.fieldName, this.file);

}

// Event to submit the form
class SubmitFormEvent extends FormEvent {
  final Map<String, dynamic> formData;

  const SubmitFormEvent(this.formData);


}
