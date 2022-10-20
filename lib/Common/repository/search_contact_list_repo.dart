import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contact_repository.dart';

final filteredListStateProvider = StateNotifierProvider<
    FilteredListStateNotifier, FilteredListState>(
  (ref, context) {
    // log('1');
    // return ref.watch(selectContactRepositoryFutureProvider).when(
    //   data: (data) {
    //     log('2');
    //     return FilteredListStateNotifier(
    //       contactList: data,
    //       state: EmptyFilteredListState(data),
    //     );
    //   },
    //   error: (error, stackTrace) {
    //     return FilteredListStateNotifier(
    //       contactList: [],
    //       state: ErrorFilteredListState(error.toString()),
    //     );
    //   },
    //   loading: () {
    //     return FilteredListStateNotifier(
    //       contactList: [],
    //       state: const LoadingFilteredListState(),
    //     );
    //   },
    // );
    var list = ref
        .watch(selectContactRepositoryFutureProvider)
        .whenData((value) => value);
    List<Contact> contactList = list.value!;
    return FilteredListStateNotifier(contactList: contactList);
  },
);

@immutable
abstract class FilteredListState {
  const FilteredListState();
}

class InitialFilteredListState extends FilteredListState {}

class EmptyFilteredListState extends FilteredListState {
  const EmptyFilteredListState(this.contactList);

  final List<Contact> contactList;
}

class SearchedFilteredListState extends FilteredListState {
  const SearchedFilteredListState(this.searchedQueryList);

  final List<Contact> searchedQueryList;
}

class ErrorFilteredListState extends FilteredListState {
  const ErrorFilteredListState(this.errorMessage);

  final String errorMessage;
}

class LoadingFilteredListState extends FilteredListState {
  const LoadingFilteredListState();
}

class FilteredListStateNotifier extends StateNotifier<FilteredListState> {
  FilteredListStateNotifier({
    required this.contactList,
    // required FilteredListState state,
  }) : super(InitialFilteredListState());

  final List<Contact> contactList;

  void getSearchQueryList(String query) async {
    log('Query bro $query');
    if (query.isEmpty) {
      log('if empty');
      final list = contactList;
      state = EmptyFilteredListState(list);
    } else {
      List<Contact> filteredList = (contactList)
          .where((contact) =>
              contact.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      log(filteredList.toString());

      state = SearchedFilteredListState(filteredList);
      log(state.toString());
    }
  }
}
