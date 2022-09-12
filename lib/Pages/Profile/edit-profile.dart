import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sure_keep/All-Constants/all_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:sure_keep/Provider/auth-provider.dart';
import '../../Models/user-model.dart';
import 'image-profile-widget.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;

  const EditProfile({required this.user, Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FirebaseStorage storage = FirebaseStorage.instance;

  File? imageFile;

  String? fileName = "image.jpg";

  String? imageUrl;

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select a Photo From'),
            // content: TextField(
            //   controller: _textFieldController,
            //   textInputAction: TextInputAction.go,
            //   keyboardType: TextInputType.numberWithOptions(),
            //   decoration: InputDecoration(hintText: "Select a Photo From"),
            // ),
            actions: <Widget>[
              OutlinedButton(
                child: const Text('Gallery'),
                onPressed: () {
                  _upload('Gallery');
                  Navigator.pop(context);
                },
              ),
              OutlinedButton(
                child: const Text('Camera'),
                onPressed: () {
                  _upload('camera');
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    PickedFile? pickedImage;

    try {
      pickedImage = await picker.getImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

      setState(() {
        fileName = path.basename(pickedImage!.path);

        imageFile = File(pickedImage.path);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.logoColor;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildImage(),
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: buildEditIcon(color, context),
              ),
            ],
          ),
        ),

        OutlinedButton(onPressed: ()async {

          if (fileName == "image.jpg") {
            imageUrl = widget.user.imageUrl;
          } else {
            Reference ref = storage.ref().child(fileName!);

            UploadTask? uploadTask = ref.putFile(imageFile!);

            await uploadTask.whenComplete(() async {
              imageUrl = await ref.getDownloadURL();
            });
          }


          context.read<AuthProvider>().editProfile(
              widget.user.docID, imageUrl, context);

        }, child: Text('Save Changes')),
      ],
    ));
  }

  Widget buildImage() {
    final image = NetworkImage(widget.user.imageUrl.toString());

    return ClipOval(
      child: Material(
        color: Colors.transparent,

        child: imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                  height: 128.0,
                  width: 128.0,
                ),
              )
            : CachedNetworkImage(
                imageUrl: widget.user.imageUrl.toString(),
                width: 128.0,
                height: 128.0,
                fit: BoxFit.cover,
              ),
        // child: Ink.image(
        //   image: image,
        //   fit: BoxFit.cover,
        //   width: 128,
        //   height: 128,
        //
        // ),
      ),
    );
  }

  Widget buildEditIcon(Color color, BuildContext context) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: InkWell(
              onTap: () {
                _displayDialog(context);
              },
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 20,
              )),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
