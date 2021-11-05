import 'dart:io';

import 'package:badges/badges.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

const BOX_WIDTH = 150.0;

class ImageGalleryPicker extends StatefulWidget {
  final Function(File)? onPick;
  const ImageGalleryPicker({
    Key? key,
    this.onPick,
  }) : super(key: key);

  @override
  _ImageGalleryPickerState createState() => _ImageGalleryPickerState();
}

class _ImageGalleryPickerState extends State<ImageGalleryPicker> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _files = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildAddMoreBtn(),
          for(var i = 0; i < _files.length; i++)
            ImageBox(
              file: _files[i],
              onDelete: () {
                setState(() {
                  _files.removeAt(i);
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAddMoreBtn(){
    return InkWell(
      onTap: () async {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if(image == null) return;

        final croppedFile = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
            androidUiSettings: const AndroidUiSettings(
              toolbarTitle: 'Cắt ảnh',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              hideBottomControls: true,
            ),
            iosUiSettings: const IOSUiSettings(
              minimumAspectRatio: 1.0,
              aspectRatioLockDimensionSwapEnabled: true,
              aspectRatioPickerButtonHidden: true,
              rotateButtonsHidden: true,
              rotateClockwiseButtonHidden: true,
            )
        );

        if(croppedFile == null) return;
        setState(() {
          _files.add(croppedFile);
        });
        widget.onPick?.call(croppedFile);
      },
      child: ItemBox(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ItemBox extends StatelessWidget {
  final Widget child;
  const ItemBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: BOX_WIDTH,
      width: BOX_WIDTH,
      child: child
    );
  }
}

class ImageBox extends StatelessWidget {
  final File file;
  final VoidCallback onDelete;
  const ImageBox({
    Key? key,
    required this.file,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Badge(
      badgeColor: theme.colorScheme.surface,
      toAnimate: false,
      badgeContent: InkWell(
        onTap: onDelete,
        child: const Icon(
          Icons.close
        ),
      ),
      child: ItemBox(
        child: ExtendedImage.file(
          file,
          fit: BoxFit.fill,
        )
      ),
    );
  }
}