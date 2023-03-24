import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog/group_dynamic_form/bloc/group_form_bloc.dart';
import 'package:formz/formz.dart';

class GroupFormPage extends StatelessWidget {
  const GroupFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic form')),
      body: BlocProvider(
        create: (_) => GroupFormBloc(),
        child: const GroupFormView(),
      ),
    );
  }
}

class GroupFormView extends StatelessWidget {
  const GroupFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupFormBloc, GroupFormState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Success')));
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: const [
              GroupNameInputField(),
              GroupMemberListForm(),
              AddGroupMemberButton(),
              SizedBox(height: 16),
              GroupFormSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupNameInputField extends StatelessWidget {
  const GroupNameInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupFormBloc, GroupFormState>(
      buildWhen: (previous, current) =>
          hasInputValueChanged(previous.groupName, current.groupName),
      builder: (context, state) {
        return TextFormField(
          initialValue: state.groupName.value,
          onChanged: (groupName) =>
              context.read<GroupFormBloc>().add(GroupNameChanged(groupName)),
          decoration: InputDecoration(
            labelText: 'Group name',
            helperText: '',
            errorText: state.groupName.invalid ? 'Invalid group name' : null,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        );
      },
    );
  }
}

class GroupMemberListForm extends StatelessWidget {
  const GroupMemberListForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupFormBloc, GroupFormState>(
      buildWhen: (previous, current) =>
          previous.members.length != current.members.length,
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: state.members.length,
          separatorBuilder: (context, index) => const SizedBox(height: 32),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Member ${index + 1}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.delete),
                        onPressed: () => context
                            .read<GroupFormBloc>()
                            .add(GroupMemberRemoved(index)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      GroupMemberFirstNameField(index: index),
                      GroupMemberLastNameField(index: index),
                      GroupMemberEmailField(index: index),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class GroupMemberFirstNameField extends StatelessWidget {
  const GroupMemberFirstNameField({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupFormBloc, GroupFormState>(
      buildWhen: hasInputChanged(
        index,
        getFirstNameField,
        hasInputValueOrStatusChanged,
      ),
      builder: (context, state) {
        return TextFormField(
          key: ValueKey('${state.members[index].id}-firstName'),
          initialValue: state.members[index].firstName.value,
          onChanged: (firstName) => context
              .read<GroupFormBloc>()
              .add(GroupMemberFirstNameChanged(index, firstName)),
          decoration: InputDecoration(
            labelText: 'First name',
            helperText: '',
            errorText: state.members[index].firstName.invalid
                ? 'Invalid first name'
                : null,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        );
      },
    );
  }
}

class GroupMemberLastNameField extends StatelessWidget {
  const GroupMemberLastNameField({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupFormBloc, GroupFormState>(
      buildWhen: hasInputChanged(
        index,
        getLastNameField,
        hasInputValueOrStatusChanged,
      ),
      builder: (context, state) {
        return TextFormField(
          key: ValueKey('${state.members[index].id}-lastName'),
          initialValue: state.members[index].lastName.value,
          onChanged: (lastName) => context
              .read<GroupFormBloc>()
              .add(GroupMemberLastNameChanged(index, lastName)),
          decoration: InputDecoration(
            labelText: 'Last name',
            helperText: '',
            errorText: state.members[index].lastName.invalid
                ? 'Invalid last name'
                : null,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        );
      },
    );
  }
}

class GroupMemberEmailField extends StatelessWidget {
  const GroupMemberEmailField({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupFormBloc, GroupFormState>(
      buildWhen: hasInputChanged(
        index,
        getEmailField,
        hasInputValueOrStatusChanged,
      ),
      builder: (context, state) {
        return TextFormField(
          key: ValueKey('${state.members[index].id}-email'),
          initialValue: state.members[index].email.value,
          onChanged: (email) => context
              .read<GroupFormBloc>()
              .add(GroupMemberEmailChanged(index, email)),
          decoration: InputDecoration(
            labelText: 'Email',
            helperText: '',
            errorText:
                state.members[index].email.invalid ? 'Invalid email' : null,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        );
      },
    );
  }
}

class AddGroupMemberButton extends StatelessWidget {
  const AddGroupMemberButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupFormBloc, GroupFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: !state.status.isSubmissionInProgress
              ? () =>
                  context.read<GroupFormBloc>().add(const GroupMemberAdded())
              : null,
          child: const Text('Add Member'),
        );
      },
    );
  }
}

class GroupFormSubmitButton extends StatelessWidget {
  const GroupFormSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupFormBloc, GroupFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: state.status.isValidated
                    ? () => context
                        .read<GroupFormBloc>()
                        .add(const GroupFormSubmitted())
                    : null,
                child: const Text('Submit'),
              );
      },
    );
  }
}

bool hasInputValueChanged(
  FormzInput<dynamic, dynamic> previous,
  FormzInput<dynamic, dynamic> current,
) =>
    previous.value != current.value;

bool hasInputStatusChanged(
  FormzInput<dynamic, dynamic> previous,
  FormzInput<dynamic, dynamic> current,
) =>
    previous.status != current.status;

bool hasInputValueOrStatusChanged(
  FormzInput<dynamic, dynamic> previous,
  FormzInput<dynamic, dynamic> current,
) =>
    hasInputValueChanged(previous, current) ||
    hasInputStatusChanged(previous, current);

FormzInput<dynamic, dynamic> getFirstNameField(GroupMemberState state) =>
    state.firstName;

FormzInput<dynamic, dynamic> getLastNameField(GroupMemberState state) =>
    state.lastName;

FormzInput<dynamic, dynamic> getEmailField(GroupMemberState state) =>
    state.email;

bool Function(
  GroupFormState,
  GroupFormState,
) hasInputChanged(
  int index,
  FormzInput<dynamic, dynamic> Function(GroupMemberState state) fieldGetter,
  bool Function(
    FormzInput<dynamic, dynamic> previous,
    FormzInput<dynamic, dynamic> current,
  )
      valueComparator,
) =>
    (
      GroupFormState previous,
      GroupFormState current,
    ) {
      if (!isIndexValid(previous, current, index)) {
        return false;
      }

      return valueComparator(
        fieldGetter(previous.members[index]),
        fieldGetter(current.members[index]),
      );
    };

bool isIndexValid(
  GroupFormState previous,
  GroupFormState current,
  int index,
) {
  final previousMembers = previous.members;
  final currentMembers = current.members;

  return !(index + 1 > previousMembers.length ||
      index + 1 > currentMembers.length);
}
