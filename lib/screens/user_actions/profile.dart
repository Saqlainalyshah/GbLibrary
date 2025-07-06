import 'package:booksexchange/components/layout_components/alert_dialogue.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/button.dart';
import '../../components/layout_components/small_components.dart';
import '../../components/text_widget.dart';
import '../../components/textfield.dart';
import '../../controller/ads/interstitial_ad.dart';
import '../../controller/firebase_crud_operations/firestore_crud_operations.dart';
import '../../controller/providers/global_providers.dart';
import '../../utils/app_theme/theme.dart';

final isLoading=StateProvider.autoDispose<bool>((ref)=>false);
final isFacebookLogin=StateProvider.autoDispose<bool>((ref)=>false);
final _isReadOnly=StateProvider.autoDispose<bool>((ref)=>true);
final gender = StateProvider<String>((ref) {
  final temp=ref.watch(userProfileProvider);
  if(temp!=null){
    return temp.gender;
  }else{
    return '';
  }
});

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key,});
 // final UserProfile userProfile;

  @override
  ConsumerState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {

  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController whatsappNumber = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Added key
  late final UserProfile userProfile;

  final InterstitialAdManager adInstance=InterstitialAdManager();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adInstance.createInterstitialAd();
    userProfile= ref.read(userProfileProvider)!;
    name.text=userProfile.name;
    address.text=userProfile.address;
    whatsappNumber.text=userProfile.number;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    address.dispose();
    whatsappNumber.dispose();
    adInstance.disposeInterstitialAds();
  }

  @override
  Widget build(BuildContext context) {

    final nameField=Consumer(
      builder:(context,ref,child)=> CustomTextField(isRead: ref.watch(_isReadOnly),controller: name,hintText: name.text.isEmpty?"Saqlain Ali Shah":name.text, validator: (value) => value!.isEmpty ? "Name is required" : null, // Validation
      ),
    );
    final addressField=Consumer(builder:(context,ref,child)=> CustomTextField(isRead: ref.watch(_isReadOnly),controller: address,hintText: address.text.isEmpty?"Noor Colony Jutial":address.text,validator: (value) => value!.isEmpty ? "Address is required" : null,));
    final whatsappField=Consumer(
      builder:(context,ref,child)=> CustomTextField(isRead: ref.watch(_isReadOnly),maxLength: 11,textInputType: TextInputType.number,controller: whatsappNumber,counterText: "",hintText: "03134457244",
        validator: (value) {
          if (value!.isEmpty) return "Phone number is required";
          if (value.length < 11) return "Enter a valid 11-digit phone number";
          return null;
        },
      ),
    );
    print("rebuilds");
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppThemeClass.whiteText,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: buildCustomBackButton(context),
          title: CustomText(text: "Profile", isBold: true, fontSize: 20),
          actions: [
            Container(
              margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppThemeClass.primary
                ),
                child: Consumer(
                  builder:(context,ref,child)=> ref.watch(_isReadOnly)!? IconButton(onPressed: (){
                    ref.read(_isReadOnly.notifier).state=false;
                  }, icon: Icon(Icons.edit_rounded,color: AppThemeClass.whiteText,)):IconButton(onPressed: (){
                    ref.read(_isReadOnly.notifier).state=true;
                  }, icon: Icon(Icons.cancel,color: AppThemeClass.whiteText,)),
                ))],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey, // Assign form key
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 // CachedNetworkImage(height: 100,width: 100,imageUrl: userProfile.profilePicUrl.toString()),
                  Center(
                    child:   Consumer(
                      builder:(context,ref,child)=> CircleAvatar(
                        radius: 100,
                        backgroundColor: AppThemeClass.secondary,
                        backgroundImage: NetworkImage(userProfile.profilePicUrl.toString(),),
                      ),
                    ),
                  ),
                  CustomText(text: "Name", isGoogleFont: true),
                  nameField,
                  CustomText(text: "Gender", isGoogleFont: true),
                  Row(
                    children: List.generate(2, (index) {
                      final List<String> list = ["Male", "Female"];
                      final option = list[index];
                      return Expanded(
                        child: Consumer(
                          builder: (context, ref, child) {
                            return RadioListTile<String>(
                              activeColor: AppThemeClass.primary,
                              value: list[index],
                              groupValue: ref.watch(gender.select((index) => index)),
                              onChanged: (val) {
                              if (ref.watch(_isReadOnly)){
                                 }else{
                                   ref.read(gender.notifier).state = val!;
                                   }
                              },
                              title: CustomText(text: option),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                  CustomText(text: "Address", isGoogleFont: true),
                  addressField,
                  CustomText(text: "Phone Number", isGoogleFont: true),
                  whatsappField,
                  Consumer(
                    builder:(context,ref,child)=>ref.watch(_isReadOnly)!?SizedBox.shrink(): CustomButton(
                      isLoading: ref.watch(isLoading),
                      onPress: () async {
                        FirebaseFireStoreServices instance=FirebaseFireStoreServices();
                        ref.read(isLoading.notifier).state=true;
                        UserProfile user=UserProfile(
                          createdAt: userProfile.createdAt,
                          profilePicUrl: userProfile.profilePicUrl,
                          uid: userProfile.uid,
                          name:name.text.toString(),
                          gender: ref.watch(gender),
                          address: address.text.toString(),
                          number:  whatsappNumber.text.toString(),
                          email: userProfile.email,
                        );

                        //user.copyWith(n)
                        if (_formKey.currentState!.validate() ) {
                          UserProfile previousData=ref.read(userProfileProvider)!;
                          if(user==previousData){
                            ref.read(_isReadOnly.notifier).state=true;
                            return;
                          }else{
                             await instance.updateDocument('users',userProfile.uid.toString(), user.toJson());
                          /* if(result){
                           final count = ref.read(userActionsTracker.select((state)=>state.numberOfProfileUpdate))+1;
                             ref.read(userProfileProvider.notifier)
                                 .state = user;
                             ref.read(userActionsTracker.notifier).updateNumberOfProfileUpdate(count);

                             if(ref.watch(userActionsTracker.select((state)=>state.numberOfProfileUpdate))==5 ){
                               adInstance.showInterstitialAd((){
                                 ref.read(userActionsTracker.notifier).clearNumberOfProfileUpdate();
                               });
                             }else{
                               print("${ref.watch(userActionsTracker.select((state)=>state.numberOfProfileUpdate))}===================>");
                             }
                           }*/
                            ref.read(_isReadOnly.notifier).state=true;
                          }
                        } else {
                          UiEventHandler.snackBarWidget(context, "Please fill all the required fields");
                        }
                        ref.read(isLoading.notifier).state=false;
                      },
                      title: "Update",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

