import 'package:formz/formz.dart';

enum GroupNameValidationError {
  empty,
  tooShort,
  tooLong,
}

class GroupNameInput extends FormzInput<String, GroupNameValidationError> {
  const GroupNameInput.pure([super.value = '']) : super.pure();
  const GroupNameInput.dirty([super.value = '']) : super.dirty();

  @override
  GroupNameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return GroupNameValidationError.empty;
    if (value.length < 3) return GroupNameValidationError.tooShort;
    if (value.length > 20) return GroupNameValidationError.tooLong;
    return null;
  }
}
