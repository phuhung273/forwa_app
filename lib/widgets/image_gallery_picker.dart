import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:badges/badges.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

const BOX_WIDTH = 150.0;
const METHOD_GALLERY = 'gallery';
const METHOD_CAMERA = 'camera';

class ImageGalleryPicker extends StatefulWidget {
  final Function(File)? onPick;
  final Function(int)? onDelete;
  const ImageGalleryPicker({
    Key? key,
    this.onPick,
    this.onDelete,
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
                  widget.onDelete?.call(i);
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
        final result = await showModalActionSheet<String>(
          context: context,
          actions: [
            const SheetAction(
              icon: Icons.photo_camera,
              label: 'Chụp hình',
              key: METHOD_CAMERA,
            ),
            const SheetAction(
              icon: Icons.collections,
              label: 'Chọn từ thư viện',
              key: METHOD_GALLERY,
              isDefaultAction: true,
            ),
          ],
        );

        XFile? image;
        if(result == METHOD_GALLERY){
          image = await _picker.pickImage(source: ImageSource.gallery);
        } else if (result == METHOD_CAMERA){
          image = await _picker.pickImage(source: ImageSource.camera);
        }

        _cropAndAdd(image);
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

  Future _cropAndAdd(XFile? image) async{
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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Badge(
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
      ),
    );
  }
}