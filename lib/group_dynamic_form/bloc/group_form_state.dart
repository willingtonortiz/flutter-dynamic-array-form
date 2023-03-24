part of 'group_form_bloc.dart';

class GroupFormState extends Equatable {
  const GroupFormState({
    this.groupName = const GroupNameInput.pure(),
    this.members = const [],
    this.status = FormzStatus.pure,
  });

  final GroupNameInput groupName;
  final List<GroupMemberState> members;
  final FormzStatus status;

  GroupFormState copyWith({
    GroupNameInput? groupName,
    List<GroupMemberState>? members,
    FormzStatus? status,
  }) {
    return GroupFormState(
      groupName: groupName ?? this.groupName,
      members: members ?? this.members,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        groupName,
        members,
        status,
      ];
}

class GroupMemberState extends Equatable {
  const GroupMemberState({
    required this.id,
    this.firstName = const FirstNameInput.pure(),
    this.lastName = const LastNameInput.pure(),
    this.email = const EmailInput.pure(),
  });

  final String id;
  final FirstNameInput firstName;
  final LastNameInput lastName;
  final EmailInput email;

  GroupMemberState copyWith({
    String? id,
    FirstNameInput? firstName,
    LastNameInput? lastName,
    EmailInput? email,
  }) {
    return GroupMemberState(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }

  List<FormzInput<dynamic, dynamic>> get fields => [
        firstName,
        lastName,
        email,
      ];

  List<FormzInput<dynamic, dynamic>> get fieldsAsDirty => [
        FirstNameInput.dirty(firstName.value),
        LastNameInput.dirty(lastName.value),
        EmailInput.dirty(email.value),
      ];

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
      ];
}
