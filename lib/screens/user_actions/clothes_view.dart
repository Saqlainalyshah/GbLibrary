import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/cards/post_card.dart';
import '../home/view_uniform.dart';

class UniformClothes extends StatefulWidget {
  const UniformClothes({super.key});

  @override
  State<UniformClothes> createState() => _UniformClothesState();
}

class _UniformClothesState extends State<UniformClothes> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          body: ListView.builder(itemCount: 5,itemBuilder: (context,index){

            return PostCard(
              title: 'Donated Clothes',
              category: '',
               grade: '',
              board: 'School Uniform',
             time: '3 minutes ago',
              description: 'Flutter is a free and open-source framework developed by Google that lets you build',
              location: 'Gilgit Baltistan',
                type: '',
              imageUrl: '',
             function:(){},
             // function: ()=>Navigator.push(context, MaterialPageRoute(builder: (builder)=>SchoolUniformScreen(clothesModel: ,))),
            );
          }),

        ));
  }
}
