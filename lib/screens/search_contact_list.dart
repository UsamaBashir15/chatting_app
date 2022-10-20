import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Common/repository/search_contact_list_repo.dart';
import '../Common/widgets/loading_widget.dart';

class SelectContactScreen extends ConsumerStatefulWidget {
  const SelectContactScreen({Key? key}) : super(key: key);
  static String pageName = 'SelectContactScreen';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactScreenState();
}

class _SelectContactScreenState extends ConsumerState<SelectContactScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    ref
        .read(filteredListStateProvider(context).notifier)
        .getSearchQueryList('');

    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            ref
                .read(filteredListStateProvider(context).notifier)
                .getSearchQueryList('');
          },
          icon: Icon(Icons.home),
        ),
        IconButton(
          onPressed: () {
            ref
                .read(filteredListStateProvider(context).notifier)
                .getSearchQueryList('');
          },
          icon: Icon(Icons.add),
        ),
      ],
      iconTheme: Theme.of(context).iconTheme.copyWith(
            color: Colors.amber,
          ),
      title: Text(
        'Select Contact',
        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
              color: Colors.blue,
              fontSize: 18.0,
            ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchNoteTF(),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              FilteredListState state =
                  ref.watch(filteredListStateProvider);
              log('message im in builder of filter 1');
              if (state is LoadingFilteredListState) {
                return const LoadingWidget();
              } else if (state is EmptyFilteredListState) {
                return ContactsList(contactsList: state.contactList);
              } else if (state is SearchedFilteredListState) {
                log('message im in builder of filter 2');
                return ContactsList(contactsList: state.searchedQueryList);
              } else if (state is ErrorFilteredListState) {
                return Text(state.errorMessage);
              } else {
                return const Center(
                  child: Text('Error'),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchNoteTF() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: TextField(
        controller: _searchController,
        cursorColor: Colors.black,
        onChanged: _onChangedText,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: size.width * 0.04,
            ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabled: true,
          suffixIcon: _searchController.text.isEmpty
              ? const Icon(
                  Icons.search,
                  color: Colors.blue,
                )
              : IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          hintText: 'search by name',
          hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Colors.grey,
                fontSize: size.width * 0.04,
              ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _onChangedText(String value) {
    log(value);
    ref
        .read(filteredListStateProvider(context).notifier)
        .getSearchQueryList(value);
  }
}

class ContactsList extends StatelessWidget {
  const ContactsList({
    super.key,
    required this.contactsList,
  });

  final List<Contact> contactsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contactsList.length,
      itemBuilder: (context, index) => getListItem(
        contactsList[index],
      ),
    );
  }

  Widget getListItem(Contact contact) {
    String name = contact.displayName;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(name),
          leading: contact.photo == null
              ? null
              : CircleAvatar(
                  backgroundImage: MemoryImage(contact.photo!),
                ),
        ),
        const Divider(
          indent: 50.0,
          endIndent: 50.0,
          height: 1.0,
        ),
      ],
    );
  }
}
