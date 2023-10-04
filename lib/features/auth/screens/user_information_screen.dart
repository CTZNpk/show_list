import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/profile_page/controller/profile_controller.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/loading.dart';
import 'package:show_list/shared/utils/utils.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  File? image;
  bool loading = false;

  void toggleLoadingScreen() {
    setState(() {
      loading = !loading;
    });
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  Future storeUserData() async {
    String name = nameController.text.trim();
    String about = aboutController.text.trim();

    if (name.isNotEmpty) {
      toggleLoadingScreen();
      await ref.read(profileControllerProvider).savingData(
        context,
        name,
        image,
        about,
        [],
        [],
        [],
        [],
        [],
      );


      if (context.mounted) {
        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } else {
      showSnackBar(context: context, content: 'Provide User Name');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myTheme = Theme.of(context);
    return loading
        ? const LoadingScreen()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    const VerticalSpacing(30),
                    _ShowImageAndIcon(
                      image: image,
                      selectImage: selectImage,
                    ),
                    Container(
                      width: size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: nameController,
                        maxLength: 25,
                        style: TextStyle(
                          color: myTheme.colorScheme.onSurface,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: aboutController,
                        style: TextStyle(
                          color: myTheme.colorScheme.onSurface,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'About',
                        ),
                      ),
                    ),
                    const VerticalSpacing(50),
                    MyElevatedButton(
                      label: 'Submit',
                      labelIcon: Icons.done,
                      imageUrl: null,
                      backgroundColor: Colors.indigo[900]!,
                      onPressed: storeUserData,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class _ShowImageAndIcon extends StatelessWidget {
  final File? image;
  final VoidCallback selectImage;
  const _ShowImageAndIcon({
    required this.image,
    required this.selectImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _ShowImageOrDefault(image: image),
        Positioned(
          bottom: -10,
          left: 80,
          child: IconButton(
            onPressed: selectImage,
            icon: const Icon(Icons.add_a_photo),
          ),
        ),
      ],
    );
  }
}

class _ShowImageOrDefault extends StatelessWidget {
  final File? image;
  const _ShowImageOrDefault({required this.image});

  @override
  Widget build(BuildContext context) {
    return image == null
        ?  const _DefaultAvatar()
        : _AvatarFromImage(image: image);
  }
}

class _AvatarFromImage extends StatelessWidget {
  const _AvatarFromImage({
    required this.image,
  });

  final File? image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: FileImage(
        image!,
      ),
      radius: 64,
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundImage: NetworkImage(
        'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
      ),
      radius: 64,
    );
  }
}
