import 'package:booksexchange/components/layout_components/alert_dialogue.dart';
import 'package:booksexchange/controller/authentication/auth_providers.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/button.dart';
import '../../components/layout_components/small_components.dart';
import '../../components/text_widget.dart';
import '../../components/textfield.dart';
import '../../controller/firebase_crud_operations/user_profile_crud.dart';
import '../../utils/fontsize/app_theme/theme.dart';

final isLoading=StateProvider.autoDispose<bool>((ref)=>false);

final gender = StateProvider.autoDispose<String>((ref) => '');
class Profile extends ConsumerStatefulWidget {
  const Profile({super.key,required this.userProfile});
  final UserProfile userProfile;

  @override
  ConsumerState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {

  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController whatsappNumber = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Added key

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text=widget.userProfile.name;
    address.text=widget.userProfile.address;
    whatsappNumber.text=widget.userProfile.number;
   // ref.read(_gender.notifier).state=widget.userProfile.gender;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    address.dispose();
    whatsappNumber.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final nameField=CustomTextField(controller: name,hintText: name.text.isEmpty?"Saqlain Ali Shah":name.text, validator: (value) => value!.isEmpty ? "Name is required" : null, // Validation
    );
    final addressField=CustomTextField(controller: address,hintText: address.text.isEmpty?"Noor Colony Jutial":address.text,validator: (value) => value!.isEmpty ? "Address is required" : null,);
    final whatsappField=CustomTextField(maxLength: 11,textInputType: TextInputType.number,controller: whatsappNumber,counterText: "",hintText: "03134457244",
      validator: (value) {
        if (value!.isEmpty) return "Phone number is required";
        if (value.length < 11) return "Enter a valid 11-digit phone number";
        return null;
      },
    );
    print(widget.userProfile.profilePicUrl);
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
                /*  Center(
                    child: CachedNetworkImage(
                      imageUrl: widget.userProfile.profilePicUrl.toString(),
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Text(widget.userProfile.name.toString()[0]),
                    ),
                  ),*/
                  Center(
                    child:   Consumer(
                      builder:(context,ref,child)=> CircleAvatar(
                        radius: 100,
                        backgroundColor: AppThemeClass.secondary,
                        backgroundImage: NetworkImage(widget.userProfile.profilePicUrl.toString(),),
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
                                ref.read(gender.notifier).state = val!;
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
                    builder:(context,ref,child)=> CustomButton(
                      isLoading: ref.watch(isLoading),
                      onPress: () async {
                        ref.read(isLoading.notifier).state=true;
                        UserProfile user=UserProfile(
                          profilePicUrl: ref.watch(userUIDProvider)?.photoURL??'',
                          name: ref.watch(userUIDProvider)?.displayName??name.text.toString(),
                          gender: ref.watch(gender),
                          address: address.text.toString(),
                          number: ref.watch(userUIDProvider)?.phoneNumber?? whatsappNumber.text.toString(),
                          email: ref.watch(userUIDProvider)?.email??'',
                        );
                        // print(user);
                        if (_formKey.currentState!.validate() ) {
                          await ref.read(firebaseCRUDProvider).updateDocument('users', ref.watch(userUIDProvider)!.uid, user.toJson());
                          // Proceed with updating user data
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

/*
class Profile extends StatelessWidget {
  Profile({super.key,required this.userProfile});
final UserProfile userProfile;
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController whatsappNumber = TextEditingController();
  final _gender = StateProvider.autoDispose<String>((ref) => "Male");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Added key


  @override
  Widget build(BuildContext context) {


    final nameField=CustomTextField(controller: name,hintText: name.text.isEmpty?"Saqlain Ali Shah":name.text, validator: (value) => value!.isEmpty ? "Name is required" : null, // Validation
    );
    final addressField=CustomTextField(controller: address,hintText: address.text.isEmpty?"Noor Colony Jutial":address.text,validator: (value) => value!.isEmpty ? "Address is required" : null,);
    final whatsappField=CustomTextField(maxLength: 11,textInputType: TextInputType.number,controller: whatsappNumber,counterText: "",hintText: "03134457244",
      validator: (value) {
        if (value!.isEmpty) return "Phone number is required";
        if (value.length < 11) return "Enter a valid 11-digit phone number";
        return null;
      },
    );
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
                  Center(
                      child:   Consumer(
                        builder:(context,ref,child)=> CircleAvatar(
                          radius: 100,
                          backgroundColor: AppThemeClass.secondary,
                          backgroundImage: NetworkImage(ref.watch(userUIDProvider)!.photoURL.toString(),),
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
                              groupValue: ref.watch(_gender.select((index) => index)),
                              onChanged: (val) {
                                ref.read(_gender.notifier).state = val!;
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
                    builder:(context,ref,child)=> CustomButton(
                      isLoading: ref.watch(isLoading),
                      onPress: () async {
                        ref.read(isLoading.notifier).state=true;
                        UserProfile user=UserProfile(
                            profilePicUrl: ref.watch(userUIDProvider)?.photoURL??'',
                            name: ref.watch(userUIDProvider)?.displayName??name.text.toString(),
                            gender: ref.watch(_gender),
                            address: address.text.toString(),
                            number: ref.watch(userUIDProvider)?.phoneNumber?? whatsappNumber.text.toString(),
                          email: ref.watch(userUIDProvider)?.email??'',
                        );
                       // print(user);
                        if (_formKey.currentState!.validate() ) {
                          await ref.read(firebaseCRUDProvider).updateDocument('users', ref.watch(userUIDProvider)!.uid, user.toJson());
                          // Proceed with updating user data
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
*/
