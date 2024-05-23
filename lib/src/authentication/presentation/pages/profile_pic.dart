import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:social_x/core/common/widgets/images/custom_image.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/constants/colors.dart';
import 'package:social_x/core/utils/helper_functions/helper_functions.dart';
import 'package:social_x/core/utils/popups/snackbars.dart';
import 'package:social_x/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:social_x/src/user/domain/usecases/store_user_profile.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? mediaUrl;
  String? imgLink;

  pickImage({bool camera = false}) async {
    final image = await THelperFunctions.pickImage(camera: camera);
    if (image != null) {
      setState(() {
        mediaUrl = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //  PostsViewModel viewModel = Provider.of<PostsViewModel>(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          TSnackBar.showErrorSnackBar(context: context, message: state.error);
        }
        if (state is Authenticated) {
          TSnackBar.showSuccessSnackBar(
              context: context, message: "Account Created");
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          progressIndicator: circularProgress(context),
          isLoading: state is AuthLoading,
          child: Scaffold(
            //  key: viewModel.scaffoldKey,
            appBar: AppBar(
              title: const Text('Add a profile picture'),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              children: [
                InkWell(
                  onTap: () {
                    showImageChoices(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(3.0),
                      ),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: imgLink != null
                        ? CustomImage(
                            imageUrl: imgLink,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width - 30,
                            fit: BoxFit.cover,
                          )
                        : mediaUrl == null
                            ? Center(
                                child: Text(
                                  'Tap to add your profile picture',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              )
                            : Image.file(
                                mediaUrl!,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width - 30,
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.secondary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'done'.toUpperCase(),
                          style: TextStyle(color: TColors.lightPrimary),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (mediaUrl != null) {
                        context.read<AuthBloc>().add(OnUploadUserProfile(
                            params: StoreUserProfileParams(
                                path: "Users/Images/Profile",
                                image: mediaUrl!)));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showImageChoices(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Select from'.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Ionicons.camera_outline),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(camera: true);
                  // viewModel.pickImage(camera: true);
                },
              ),
              ListTile(
                leading: const Icon(Ionicons.image),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage();

                  // viewModel.pickImage();
                  // viewModel.pickProfilePicture();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
