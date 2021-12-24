import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/mixins/image_pick.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/input_field.dart';
import 'package:forwa_app/widgets/keyboard_friendly_body.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import 'profile_edit_screen_controller.dart';

class ProfileEditScreen extends GetView<ProfileEditScreenController> {

  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cập nhập thông tin'),
        ),
        body: KeyboardFriendlyBody(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: defaultPadding),
          child: Column(
            children: [
              ProfilePic(),
              const Divider(),
              InputField(
                hintText: 'Họ tên',
                icon: Icons.person,
                controller: controller.nameController,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
              ),
              AppLevelActionContainer(
                child: ElevatedButton(
                  onPressed: controller.submit,
                  child: const Text(
                    'Cập nhật',
                  ),
                )
              )
            ],
          ),
        ),
      )
    );
  }
}

const IMAGE_SIZE = 115.0;

class ProfilePic extends GetView<ProfileEditScreenController> with ImagePick {
  ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: _updateAvatar,
      child: SizedBox(
        height: IMAGE_SIZE,
        width: IMAGE_SIZE,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            Obx(
              () {
                if(controller.useFileAvatar.isFalse){
                  if(controller.imageUrl.isEmpty){

                    final List<String> words = controller.nameController.text.split(' ');
                    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

                    return CircleAvatar(
                      radius: IMAGE_SIZE,
                      child: Text(
                        shortWords.map((e) => e[0]).join(),
                        style: theme.textTheme.headline6!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.secondary,
                    );
                  }

                  return ExtendedImage.network(
                    controller.imageUrl.value,
                    fit: BoxFit.cover,
                    shape: BoxShape.circle,
                  );
                } else {
                  return ExtendedImage.file(
                    controller.avatar!,
                    fit: BoxFit.cover,
                    shape: BoxShape.circle,
                  );
                }
              },
            ),
            Positioned(
              right: -16,
              bottom: 0,
              child: Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle
                ),
                child: const Icon(
                  Icons.photo_camera,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Future _updateAvatar() async {
    final image = await pickAndCrop();
    if(image == null) return;

    controller.setFileAvatar(image);
  }
}