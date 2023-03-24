import 'package:formz/formz.dart';

enum FirstNameValidationError { empty }

class FirstNameInput extends FormzInput<String, FirstNameValidationError> {
  const FirstNameInput.pure([super.value = '']) : super.pure();
  const FirstNameInput.dirty([super.value = '']) : super.dirty();

  @override
  FirstNameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return FirstNameValidationError.empty;
    return null;
  }
}

class FullName {
  const FullName({
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;
}

enum FullNameValidationError { empty }

class FullNameInput extends FormzInput<FullName, FullNameValidationError> {
  const FullNameInput.pure([
    super.value = const FullName(firstName: '', lastName: ''),
  ]) : super.pure();

  const FullNameInput.dirty([
    super.value = const FullName(firstName: '', lastName: ''),
  ]) : super.dirty();

  @override
  FullNameValidationError? validator(FullName? value) {
    if (value == null) return FullNameValidationError.empty;
    return value.firstName.isNotEmpty && value.lastName.isNotEmpty
        ? null
        : FullNameValidationError.empty;
  }
}
