
import 'package:badges/badges.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/mixins/image_pick.dart';

const BOX_WIDTH = 150.0;
const METHOD_GALLERY = 'gallery';
const METHOD_CAMERA = 'camera';

class ImageGalleryPicker extends StatefulWidget {
  final Function(File)? onPick;
  final Function(int)? onDeleteFile;
  final Function(int)? onDeleteUrl;
  final List<String>? initialImageUrlList;
  const ImageGalleryPicker({
    Key? key,
    this.onPick,
    this.onDeleteFile,
    this.onDeleteUrl,
    this.initialImageUrlList,
  }) : super(key: key);

  @override
  _ImageGalleryPickerState createState() => _ImageGalleryPickerState();
}

class _ImageGalleryPickerState extends State<ImageGalleryPicker> with ImagePick {
  final List<File> _files = [];

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildAddMoreBtn(),
          for(var i = 0; i < _files.length; i++)
            FileImageBox(
              file: _files[i],
              onDelete: () {
                setState(() {
                  _files.removeAt(i);
                  widget.onDeleteFile?.call(i);
                });
              },
            ),
          if(widget.initialImageUrlList != null)
            for(var i = 0; i < widget.initialImageUrlList!.length; i++)
              UrlImageBox(
                url: widget.initialImageUrlList![i],
                onDelete: () {
                  setState(() {
                    widget.initialImageUrlList!.removeAt(i);
                    widget.onDeleteUrl?.call(i);
                  });
                },
              ),
        ],
      ),
    );
  }

  Widget _buildAddMoreBtn(){
    return InkWell(
      onTap: _addFile,
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

  Future _addFile() async{
    final image = await pickAndCrop();
    if(image == null) return;

    setState(() {
      _files.add(image);
    });
    widget.onPick?.call(image);
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
  final Widget child;
  final VoidCallback onDelete;
  const ImageBox({
    Key? key,
    required this.child,
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
          child: child
        ),
      ),
    );
  }
}

class FileImageBox extends StatelessWidget {
  final File file;
  final VoidCallback onDelete;

  const FileImageBox({
    Key? key,
    required this.file,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageBox(
      onDelete: onDelete,
      child: ExtendedImage.file(
        file,
        fit: BoxFit.fill,
      ),
    );
  }
}

class UrlImageBox extends StatelessWidget {
  final String url;
  final VoidCallback onDelete;

  const UrlImageBox({
    Key? key,
    required this.url,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageBox(
      onDelete: onDelete,
      child: ExtendedImage.network(
        url,
        fit: BoxFit.fill,
      ),
    );
  }
}
