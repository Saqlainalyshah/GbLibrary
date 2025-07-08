import 'package:booksexchange/account/subscreens/privacy_policy.dart';
import 'package:booksexchange/account/subscreens/terms_services.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:flutter/material.dart';

import 'contact_support.dart';
import 'faq.dart';
class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> list=[
      "FAQ","Contact Support","Privacy Policy","Terms of Service",
    ];
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Help and Support",isBold: true,),

      ),
      body: Padding(padding: EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context,index){
              return ListTile(
                splashColor: Colors.transparent,
                onTap: (){
                  if(index==0){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>FAQScreen()));
                  }
                  else if(index==1){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>ContactSupport()));
                  }
                  else if(index==2){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>PrivacyPolicy()));
                  }
                  else if(index==3){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>TermsServices()));
                  }
                },
                title: CustomText(text: list[index],isBold: true,),
                trailing: Icon(Icons.arrow_forward_ios,size: 18,color: Colors.grey.shade800,),
              );
            }),
      ),
    );
  }
}
