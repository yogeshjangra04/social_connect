import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clonee/common/common.dart';
import 'package:twitter_clonee/features/explore/controller/explore_controller.dart';
import 'package:twitter_clonee/features/explore/widgets/search_tile.dart';
import 'package:twitter_clonee/theme/theme.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final _searchController = TextEditingController();
  bool _searchUsers = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: _searchController,
            onSubmitted: (value) {
              setState(() {
                _searchUsers = true;
              });
            },
            decoration: InputDecoration(
              fillColor: Pallete.searchBarColor,
              filled: true,
              hintText: 'Search users',
              contentPadding: const EdgeInsets.all(20).copyWith(left: 10),
              enabledBorder: searchFieldBorder,
              focusedBorder: searchFieldBorder,
            ),
          ),
        ),
      ),
      body: _searchUsers
          ? ref.watch(searchUserProvider(_searchController.text)).when(
                data: (users) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      final user = users[index];
                      return SearchTile(user: user);
                    },
                    itemCount: users.length,
                  );
                },
                error: (error, st) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              )
          : const SizedBox(),
    );
  }
}
