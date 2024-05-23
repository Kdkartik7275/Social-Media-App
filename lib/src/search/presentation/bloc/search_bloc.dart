import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_x/src/search/domain/usecases/search_user.dart';
import 'package:social_x/src/user/domain/entity/user.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUser searchUser;
  SearchBloc({required this.searchUser}) : super(SearchInitial()) {
    on<OnSearchEvent>(_searchUser);
    on<ClearUsers>(clearUsers);
  }

  FutureOr<void> _searchUser(
      OnSearchEvent event, Emitter<SearchState> emit) async {
    if (event.query != "") {
      emit(SearchUserLoading());

      final users = await searchUser.call(event.query);
      users.fold((l) => emit(SearchUserFailure(error: l.message)),
          (r) => emit(SearchUserLoaded(users: r)));
    }
  }

  FutureOr<void> clearUsers(ClearUsers event, Emitter<SearchState> emit) {
    emit(SearchUserLoading());
    emit(const SearchUserLoaded(users: []));
  }
}
