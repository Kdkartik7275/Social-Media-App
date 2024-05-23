// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/borders/borders.dart';
import 'package:social_x/core/utils/helper_functions/helper_functions.dart';
import 'package:social_x/src/authentication/presentation/widgets/text_form_builder.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';

class EditProfile extends StatefulWidget {
  final UserEntity user;
  const EditProfile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;

  final bio = TextEditingController();
  final username = TextEditingController();
  final country = TextEditingController();

  pickImage({bool camera = false}) async {
    final userImage = await THelperFunctions.pickImage(camera: camera);
    if (userImage != null) {
      setState(() {
        image = userImage;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    bio.text = widget.user.bio!;
    country.text = widget.user.country!;
    username.text = widget.user.username!;
  }

  @override
  void dispose() {
    bio.dispose();
    username.dispose();
    country.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentuserCubit, CurrentuserState>(
        listener: (context, state) {},
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state is OnProfileUpdating,
            progressIndicator: circularProgress(context),
            child: Scaffold(
              appBar: TAppBar(
                showBackArrow: true,
                leadingIconColor: Colors.black,
                title: const Text("Edit Profile"),
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: GestureDetector(
                        onTap: () {
                          context.read<CurrentuserCubit>().updateUserData(
                              bio: bio.text,
                              country: country.text,
                              image: image,
                              username: username.text);
                        },
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15.0,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: ListView(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () => pickImage(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: image == null
                            ? widget.user.photoUrl!.isEmpty
                                ? CircleAvatar(
                                    radius: 65.0,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    child: Center(
                                      child: Text(
                                        widget.user.username![0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: CircleAvatar(
                                      radius: 65.0,
                                      backgroundImage:
                                          NetworkImage(widget.user.photoUrl!),
                                    ),
                                  )
                            : Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: CircleAvatar(
                                  radius: 65.0,
                                  backgroundImage: FileImage(image!),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  buildForm(context, widget.user)
                ],
              ),
            ),
          );
        });
  }

  buildForm(BuildContext context, UserEntity user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        // key: viewModel.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormBuilder(
              controller: username,
              prefix: Ionicons.person_outline,
              hintText: "Username",
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10.0),
            TextFormBuilder(
              controller: country,
              prefix: Ionicons.pin_outline,
              hintText: "Country",
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Bio",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: bio,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: border(context),
                enabledBorder: border(context),
                focusedBorder: focusBorder(context),
              ),
              maxLines: null,
              validator: (String? value) {
                if (value!.length > 1000) {
                  return 'Bio must be short';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
