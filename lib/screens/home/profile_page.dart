import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/services/image_data.dart';
import 'package:movie_app/services/image_upload.dart';
import 'dart:typed_data';

class ProfileEdit extends StatefulWidget {
  final String id;
  const ProfileEdit({super.key, required this.id});


  @override
  State<ProfileEdit> createState() => _ProfileEditState(idPict: id);
}

class _ProfileEditState extends State<ProfileEdit> {
  final String idPict;
  _ProfileEditState({required this.idPict});

  Uint8List? _image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  

  @override
  Widget build(BuildContext context) {

    void saveProfile() async{

      String name = nameController.text;
      String bio = bioController.text;

      String resp = await StoreData().saveData(name: name, bio: bio, file: _image!, idPict: idPict,);

      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Edit Profil', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),),
        backgroundColor: Colors.red[800],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 24,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://png.pngitem.com/pimgs/s/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png'),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
               TextField(
                controller: nameController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: 'Masukkan Nama',
                  focusColor: Colors.red,
                  labelStyle: TextStyle(
                    color: Colors.white
                  ),
                  contentPadding: EdgeInsets.all(20),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.red) 
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
               TextField(
                controller: bioController,
                style: const TextStyle(
                    color: Colors.white,
                  ),
                decoration: const InputDecoration(
                  labelText: 'Masukkan Genre Yang Di Sukai',
                  focusColor: Colors.red,
                  labelStyle: TextStyle(
                      color: Colors.white
                    ),
                  contentPadding: EdgeInsets.all(20),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.red) 
                    ),
                  ),
                ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: 
                  saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: const Text('Simpan', style: TextStyle(
                  color: Colors.white
                ), ),
              )
            ],
          ),
        ),
      ),
    );
  }
}