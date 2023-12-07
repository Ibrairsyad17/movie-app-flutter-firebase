import 'package:flutter/material.dart';
import 'package:movie_app/services/auth.dart';
import 'package:movie_app/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function togglePage;
  const SignIn({super.key, required this.togglePage});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool load = false;

  String email = '';
  String pass = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return load ? Loading() : Scaffold(
      resizeToAvoidBottomInset: false, 
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        elevation: 0.0,
        centerTitle: true,
        title: Text('Masuk'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Selamat Datang!',
                style: TextStyle(
                  color: Colors.red[800],
                  fontSize: 23.0,
                ),
              ),
              Container(
                width: 160.5,
                height: 156,
                child: const Image(
                  image: NetworkImage('https://drive.google.com/uc?export=view&id=1ndUuA3PYwESxbBIsJDCis51dsnyJR63p')
                ),
              ),
              Text('Masuk dengan e-mail', style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.w600, fontSize: 18.0),),
              Container(
                width: 310,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextFormField(
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return "E-mail tidak boleh kosong!";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val){
                        setState(() => email = val);
                      },
                      cursorColor: Colors.red[800],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(width: 2, color: Colors.red) 
                        ),
                        labelText: 'Masukkan E-mail',
                        labelStyle: TextStyle(
                          color: Colors.red[800],
                          fontSize: 15.0
                        )
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      validator: (value) => value!.length < 6 ? "Kata sandi harus lebih dari 6 karakter" : null,
                      onChanged: (val){
                        setState(() => pass = val);
                      },
                      obscureText: true,
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(width: 2, color: Colors.red) 
                        ),
                        labelText: 'Masukkan Kata Sandi',
                        labelStyle: TextStyle(
                          color: Colors.red[800],
                          fontSize: 15.0
                        )
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Container(
                        width: 310,
                        child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => load = true);
                            dynamic result = await _auth.signInEAP(email, pass);
                            if (result == null) {
                              setState(() { 
                                error = 'Terjadi kesalahan di e-mail atau kata sandi';
                                load = false;
                              });
                            }
                          }

                          
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(18.0),
                          elevation: 2.0,
                          shape: StadiumBorder(),
                          backgroundColor: Colors.red[800]
                        ),
                        child: const Text('Masuk Sekarang', style: TextStyle(fontSize: 15.0),)
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                        width: 310,
                        child: ElevatedButton(
                        onPressed: () async {
                          widget.togglePage();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(18.0),
                          elevation: 2.0,
                          shape: StadiumBorder(),
                          backgroundColor: Colors.amber[800]
                        ),
                        child: const Text('Atau Daftar', style: TextStyle(fontSize: 15.0),)
                      ),
                    )
                  ],
                ),
              ),
              Text(error, style: TextStyle(color: Colors.red[800]),),
              Text('©️Copyright 2023, sMovie.com', style: TextStyle(color: Colors.red[800]),)
            ],
          ),
        ),
      )
    );
  }
}