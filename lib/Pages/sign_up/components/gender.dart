import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/auth-provider.dart';
import '../../../Widgets/neumorphic_text_field_container.dart';
import 'animated-signup-textfield.dart';

class Gender extends StatefulWidget {
  const Gender({Key? key}) : super(key: key);

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  String? genderValue;
  bool isGenderMan = false;
  bool isGenderWoman = false;

  @override
  Widget build(BuildContext context) {

    bool isWoman =  context.watch<AuthProvider>().getGenderWoman;
    bool isMan =  context.watch<AuthProvider>().getGenderMan;
    return  Row(

      children: [
        Text('Are you a   '),
        SizedBox(
          width: 100,
          child: NeumorphicTextFieldContainer(
              child: TextButton(onPressed: () {

                isGenderMan = !isGenderMan;
                genderValue = "Man";

                context.read<AuthProvider>().setGenderMan(isGenderMan);
                context.read<AuthProvider>().setGenderWoman(false);
                context.read<AuthProvider>().setGenderValue(genderValue!);


                print(isGenderMan);
              }, child: Row(
                children: [
                  Icon(Icons.man,color: Colors.black,),
                  Text("Man  "),

                  Visibility(
                    child: Icon(Icons.check, color: Colors.green,size: 15,),
                    visible:   isMan,
                  ),
                ],
              ),)
          ),
        ),
        Text('    Or    '),
        SizedBox(
          width: 120,
          child: NeumorphicTextFieldContainer(
              child: TextButton(onPressed: () {
                genderValue = "Woman";
                isGenderWoman = !isGenderWoman;

                context.read<AuthProvider>().setGenderWoman(isGenderWoman);
                context.read<AuthProvider>().setGenderMan(false);
                context.read<AuthProvider>().setGenderValue(genderValue!);

                print( genderValue);
              }, child: Row(
                children: [
                  Icon(Icons.woman,color: Colors.black,),
                  Text("Woman  "),

                  Visibility(
                    child: Icon(Icons.check, color: Colors.green,size: 15,),
                    visible:   isWoman
                  ),
                ],
              ),)
          ),
        ),
      ],
    );
  }
}
