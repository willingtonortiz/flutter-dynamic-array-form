part of 'group_form_bloc.dart';

abstract class GroupFormEvent extends Equatable {
  const GroupFormEvent();

  @override
  List<Object?> get props => [];
}

class GroupNameChanged extends GroupFormEvent {
  const GroupNameChanged(this.groupName);

  final String groupName;

  @override
  List<Object?> get props => [groupName];
}

class GroupMemberFirstNameChanged extends GroupFormEvent {
  const GroupMemberFirstNameChanged(this.index, this.firstName);

  final int index;
  final String firstName;

  @override
  List<Object?> get props => [index, firstName];
}

class GroupMemberLastNameChanged extends GroupFormEvent {
  const GroupMemberLastNameChanged(this.index, this.lastName);

  final int index;
  final String lastName;

  @override
  List<Object?> get props => [index, lastName];
}

class GroupMemberEmailChanged extends GroupFormEvent {
  const GroupMemberEmailChanged(this.index, this.email);

  final int index;
  final String email;

  @override
  List<Object?> get props => [index, email];
}

class GroupMemberAdded extends GroupFormEvent {
  const GroupMemberAdded();

  @override
  List<Object?> get props => [];
}

class GroupMemberRemoved extends GroupFormEvent {
  const GroupMemberRemoved(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class GroupFormSubmitted extends GroupFormEvent {
  const GroupFormSubmitted();

  @override
  List<Object?> get props => [];
}
