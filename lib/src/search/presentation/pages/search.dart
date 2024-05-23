import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/popups/snackbars.dart';
import 'package:social_x/src/search/presentation/bloc/search_bloc.dart';
import 'package:social_x/src/search/presentation/widgets/search_field.dart';
import 'package:social_x/src/search/presentation/widgets/user_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text("WaveConnect"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SeachTextField(
              onChanged: (value) {
                if (value != "") {
                  context.read<SearchBloc>().add(OnSearchEvent(query: value));
                } else {
                  context.read<SearchBloc>().add(ClearUsers());
                }
              },
            ),
            Expanded(
                child: BlocConsumer<SearchBloc, SearchState>(
              listener: (context, state) {
                if (state is SearchUserFailure) {
                  return TSnackBar.showErrorSnackBar(
                      context: context, message: state.error);
                }
              },
              builder: (context, state) {
                if (state is SearchUserLoading) {
                  return circularProgress(context);
                } else if (state is SearchUserLoaded) {
                  final users = state.users;
                  return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return SearchUserTile(user: user);
                      });
                }
                return const SizedBox();
              },
            ))
          ],
        ),
      ),
    );
  }
}
