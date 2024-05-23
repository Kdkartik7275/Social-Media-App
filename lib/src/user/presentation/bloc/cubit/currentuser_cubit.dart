// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/domain/usecases/block_user.dart';
import 'package:social_x/src/user/domain/usecases/get_current_user_data.dart';
import 'package:social_x/src/user/domain/usecases/store_user_profile.dart';
import 'package:social_x/src/user/domain/usecases/update_single_field.dart';
import 'package:social_x/src/user/domain/usecases/user_token.dart';

part 'currentuser_state.dart';

class CurrentuserCubit extends Cubit<CurrentuserState> {
  final GetCurrentUserData currentUserData;
  final UpdateSingleField updateSingleField;
  final StoreUserProfile storeUserProfile;
  final BlockUser blockUser;
  final SetUserToken userToken;

  CurrentuserCubit(
      {required this.currentUserData,
      required this.storeUserProfile,
      required this.userToken,
      required this.blockUser,
      required this.updateSingleField})
      : super(CurrentuserInitial());

  void getCurrentUserData() async {
    emit(CurrentuserLoading());
    final user = await currentUserData.call();
    user.fold((l) {
      emit(CurrentuserFailure(error: l.message));
    }, (r) => emit(CurrentuserLoaded(user: r!)));
  }

  void updateOnlineStatus(bool isOnline) async {
    final update = await updateSingleField
        .call({'isOnline': isOnline, 'lastSeen': Timestamp.now()});
    update.fold((l) => emit(CurrentuserFailure(error: l.message)), (r) => null);
  }

  void updateUserData(
      {File? image, String? username, String? country, String? bio}) async {
    emit(OnProfileUpdating());
    if (image != null) {
      await storeUserProfile.call(
          StoreUserProfileParams(path: "Users/Images/Profile", image: image));
    }
    await updateSingleField.call({
      'username': username,
      'country': country,
      'bio': bio,
    });

    final user = await currentUserData.call();
    user.fold((l) => emit(CurrentuserFailure(error: l.message)),
        (r) => emit(CurrentuserLoaded(user: r!)));
  }

  void setUserToken({required String token, required String userId}) async {
    final data =
        await userToken.call(SetUserTokenParams(token: token, userId: userId));
    data.fold((l) => CurrentuserFailure(error: l.message), (r) => null);
  }

  updateUser(UserEntity user) {
    emit(OnProfileUpdating());
    emit(CurrentuserLoaded(user: user));
  }

  void block({required String userId, required String myUserId}) async {
    final user = await blockUser
        .call(BlockUserParams(userId: userId, myUserId: myUserId));
    user.fold((l) => emit(CurrentuserFailure(error: l.message)),
        (r) => updateUser(r));
  }

  @override
  void onChange(Change<CurrentuserState> change) {
    super.onChange(change);
    print(change);
  }
}
