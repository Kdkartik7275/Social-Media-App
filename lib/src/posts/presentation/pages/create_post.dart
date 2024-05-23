import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:social_x/core/common/widgets/images/custom_image.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/helper_functions/helper_functions.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/core/utils/popups/snackbars.dart';
import 'package:social_x/src/posts/domain/usecases/new_post.dart';
import 'package:social_x/src/posts/presentation/bloc/new_post/new_post_bloc.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File? mediaUrl;
  String? imgLink;

  final description = TextEditingController();

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
    final user =
        (BlocProvider.of<CurrentuserCubit>(context).state as CurrentuserLoaded)
            .user;
    return BlocConsumer<NewPostBloc, NewPostState>(
      listener: (context, state) {
        if (state is NewPostFailure) {
          return TSnackBar.showErrorSnackBar(
              context: context, message: state.error);
        }
        if (state is NewPostUploadedSuccess) {
          TNavigators.navigatePop(context);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          progressIndicator: circularProgress(context),
          isLoading: state is NewPostUploading,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Ionicons.close_outline),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('WOOBLE'.toUpperCase()),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () async {
                    if (description.text.isEmpty) {
                      TSnackBar.showErrorSnackBar(
                          context: context,
                          message: "Description cant be null");
                    }
                    if (mediaUrl == null) {
                      TSnackBar.showErrorSnackBar(
                          context: context, message: "Please select an image");
                    } else {
                      context.read<NewPostBloc>().add(OnUploadPost(
                          params: NewPostParams(
                              description: description.text,
                              media: mediaUrl!,
                              ownerId: user.id!)));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Post'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              children: [
                const SizedBox(height: 15.0),
                ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(user.photoUrl!),
                  ),
                  title: Text(
                    user.username!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    user.email!,
                  ),
                ),
                InkWell(
                  onTap: () => showImageChoices(context),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5.0),
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
                                  'Upload a Photo',
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
                const SizedBox(height: 20.0),
                Text(
                  'Post Caption'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextFormField(
                  controller: description,
                  decoration: const InputDecoration(
                    hintText: 'Eg. This is very beautiful place!',
                    focusedBorder: UnderlineInputBorder(),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 20.0),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Select Image',
                  style: TextStyle(
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
                },
              ),
              ListTile(
                leading: const Icon(Ionicons.image),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
