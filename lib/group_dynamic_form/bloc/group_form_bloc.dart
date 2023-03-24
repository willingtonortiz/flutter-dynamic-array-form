import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blog/group_dynamic_form/inputs/models.dart';
import 'package:formz/formz.dart';
import 'package:uuid/uuid.dart';

part 'group_form_events.dart';
part 'group_form_state.dart';

class GroupFormBloc extends Bloc<GroupFormEvent, GroupFormState> {
  GroupFormBloc() : super(const GroupFormState()) {
    on<GroupNameChanged>(_onGroupNameChanged);
    on<GroupMemberFirstNameChanged>(_onGroupMemberFirstNameChanged);
    on<GroupMemberLastNameChanged>(_onGroupMemberLastNameChanged);
    on<GroupMemberEmailChanged>(_onGroupMemberEmailChanged);
    on<GroupMemberAdded>(_onGroupMemberAdded);
    on<GroupMemberRemoved>(_onGroupMemberRemoved);
    on<GroupFormSubmitted>(_onGroupFormSubmitted);
  }

  void _onGroupNameChanged(
    GroupNameChanged event,
    Emitter<GroupFormState> emit,
  ) {
    final groupName = GroupNameInput.dirty(event.groupName);
    final membersFields = _getAllMemberFields(members: state.members);

    emit(
      state.copyWith(
        groupName: groupName,
        status: Formz.validate([groupName, ...membersFields]),
      ),
    );
  }

  void _onGroupMemberFirstNameChanged(
    GroupMemberFirstNameChanged event,
    Emitter<GroupFormState> emit,
  ) {
    final firstName = FirstNameInput.dirty(event.firstName);
    final members = updateGroupMemberField(
      members: state.members,
      index: event.index,
      firstName: firstName,
    );

    final membersFields = _getAllMemberFields(members: state.members);

    emit(
      state.copyWith(
        members: members,
        status: Formz.validate([state.groupName, ...membersFields]),
      ),
    );
  }

  void _onGroupMemberLastNameChanged(
    GroupMemberLastNameChanged event,
    Emitter<GroupFormState> emit,
  ) {
    final lastName = LastNameInput.dirty(event.lastName);
    final members = updateGroupMemberField(
      members: state.members,
      index: event.index,
      lastName: lastName,
    );

    final membersFields = _getAllMemberFields(members: state.members);

    emit(
      state.copyWith(
        members: members,
        status: Formz.validate([state.groupName, ...membersFields]),
      ),
    );
  }

  void _onGroupMemberEmailChanged(
    GroupMemberEmailChanged event,
    Emitter<GroupFormState> emit,
  ) {
    final email = EmailInput.dirty(event.email);
    final members = updateGroupMemberField(
      members: state.members,
      index: event.index,
      email: email,
    );

    final membersFields = _getAllMemberFields(members: state.members);

    emit(
      state.copyWith(
        members: members,
        status: Formz.validate([state.groupName, ...membersFields]),
      ),
    );
  }

  void _onGroupMemberAdded(
    GroupMemberAdded event,
    Emitter<GroupFormState> emit,
  ) {
    final uuid = Uuid();
    final members = List<GroupMemberState>.from(state.members)
      ..add(GroupMemberState(id: uuid.v4()));

    final membersFields = _getAllMemberFields(members: state.members);

    emit(
      state.copyWith(
        members: members,
        status: Formz.validate([state.groupName, ...membersFields]),
      ),
    );
  }

  void _onGroupMemberRemoved(
    GroupMemberRemoved event,
    Emitter<GroupFormState> emit,
  ) {
    final groupName = GroupNameInput.dirty(state.groupName.value);
    final members = List<GroupMemberState>.from(state.members)
      ..removeAt(event.index);

    final membersFields = _getAllMemberFields(
      members: members,
      mapper: (member) => member.fieldsAsDirty,
    );

    emit(
      state.copyWith(
        groupName: groupName,
        members: members,
        status: Formz.validate([groupName, ...membersFields]),
      ),
    );
  }

  Future<void> _onGroupFormSubmitted(
    GroupFormSubmitted event,
    Emitter<GroupFormState> emit,
  ) async {
    final groupName = GroupNameInput.dirty(state.groupName.value);
    final members = List<GroupMemberState>.from(state.members)
        .map(
          (member) => member.copyWith(
            firstName: FirstNameInput.dirty(member.firstName.value),
            lastName: LastNameInput.dirty(member.lastName.value),
            email: EmailInput.dirty(member.email.value),
          ),
        )
        .toList();

    final membersFields = members
        .map((member) => member.fields)
        .expand((fields) => fields)
        .toList();

    emit(
      state.copyWith(
        groupName: groupName,
        members: members,
        status: Formz.validate([groupName, ...membersFields]),
      ),
    );

    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      await Future<void>.delayed(const Duration(seconds: 1));

      emit(state.copyWith(status: FormzStatus.submissionSuccess));

      print(state);
    }
  }

  List<GroupMemberState> updateGroupMemberField({
    required List<GroupMemberState> members,
    required int index,
    FirstNameInput? firstName,
    LastNameInput? lastName,
    EmailInput? email,
  }) {
    final updatedMembers = List<GroupMemberState>.from(members);
    final updatedMember = updatedMembers[index];

    updatedMembers[index] = updatedMember.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
    );

    return updatedMembers;
  }

  List<FormzInput<dynamic, dynamic>> _getAllMemberFields({
    required List<GroupMemberState> members,
    List<FormzInput<dynamic, dynamic>> Function(GroupMemberState)? mapper,
  }) {
    mapper ??= (GroupMemberState member) => member.fields;

    return members
        .map((member) => member.fields)
        .expand((fields) => fields)
        .toList();
  }
}
