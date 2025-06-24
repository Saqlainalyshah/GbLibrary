import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/components/textfield.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});
  final TextEditingController controller=TextEditingController();
  final _selectedIndex=StateProvider.autoDispose<int>((ref)=>0);
  final List<String> _categoriesList = ["General", "Account", "Services","Safety"];
  final _isEmpty=StateProvider.autoDispose<bool>((ref)=>true);
  @override
  Widget build(BuildContext context) {
    print("build FAQ");
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppThemeClass.whiteText,
        appBar: AppBar(
          backgroundColor: AppThemeClass.whiteText,
          surfaceTintColor:AppThemeClass.whiteText,
          leading: buildCustomBackButton(context),
          centerTitle: true,
          title: Text( "FAQ",style:TextStyle(fontWeight: FontWeight.w900,)),
        ),
        body: Column(
          spacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer(
                builder:(context,ref,child)=> CustomTextField(
                  controller: controller,
                  onChanged: (value){
                    ref.read(faqProvider.notifier).search(value);
                  },
                  leadingIcon: Icons.search,
                  hintText: "Search",
                  trailingIcon: Icons.close,
                  trailingFn: (){
                   FocusScope.of(context).unfocus();
                    controller.clear();
                   ref.read(faqProvider.notifier).filterListByCategory(_categoriesList[ref.watch(_selectedIndex)]);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child:  ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: _categoriesList.length,
                itemBuilder: (context, index) {
                 // print(index);
                  return Consumer(
                    builder: (context, ref, _) {
                      

                      final isSelected=ref.watch(_selectedIndex.select((item)=>item==index));
                     // final isSelected=index==itemIndex;
                      print("build only single $index");
                      return OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: isSelected ? BorderSide.none : null,
                          backgroundColor: isSelected ? AppThemeClass.primary  : null,
                        ),
                        onPressed: () {
                          ref.read(_selectedIndex.notifier).state = index;
                          ref.read(faqProvider.notifier).filterListByCategory(_categoriesList[index]);
                        },
                        child: CustomText(
                          text: _categoriesList[index],
                          color: isSelected ? AppThemeClass.whiteText : Colors.black,
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (_, __) => SizedBox(width: 10),
              )
            ),
            Expanded(
              child: Consumer(
                builder:(context,ref,child){
                  final len= ref.watch(faqProvider.select((p)=>p.filteredItems));
                  final len2= ref.watch(faqProvider.select((p)=>p.searchedList));

                  final list=controller.text.isNotEmpty?
                  len2.length:
                  len.length;

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount:list,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                    itemBuilder: (context,index){
                      print("Nested Item $index rebuild");
                      return Consumer(builder: (context,ref,child){
                        print("rebuild $index");
                       // final isRead = ref.watch(readStatusProvider(index));
                        final item= ref.watch(faqProvider.select((itemVal)=>itemVal.filteredItems[index]));


                        return GestureDetector(
                          key: ValueKey(index),
                          onTap: (){
                            ref.read(faqProvider.notifier).toggleIsReadByFilteredIndex(item,index);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppThemeClass.whiteText,
                              //   borderRadius: BorderRadius.circular(10)
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                              border: Border.all(color: AppThemeClass.secondary, width: 1.0),
                            ),
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: CustomText(text: item.question,isBold: true,)),
                                    Icon(item.isRead? Icons.keyboard_arrow_down_outlined: Icons.keyboard_arrow_up,color: Colors.grey.shade700,)
                                  ],
                                ),
                                if(item.isRead)Divider(),
                                if(item.isRead)CustomText(text: item.answer,)
                              ],
                            ),
                          ),
                        );
                      });
                    }, separatorBuilder: (BuildContext context, int index) {
                    return Padding(padding: EdgeInsets.all(10));
                  },);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


// Model class
class FAQ {
  final String questionType;
  final String question;
  final String answer;
  final bool isRead;

  FAQ({
    required this.questionType,
    required this.question,
    required this.answer,
    required this.isRead,
  });

  FAQ copyWith({
    String? questionType,
    String? question,
    String? answer,
    bool? isRead,
  }) {
    return FAQ(
      questionType: questionType ?? this.questionType,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isRead: isRead ?? this.isRead,
    );
  }
}

// Filter list class
class FilterList {
  final List<FAQ> allItems;
  final List<FAQ> filteredItems;
  final List<FAQ> searchedList;
  final String search;

  FilterList({
    required this.allItems,
    required this.filteredItems,
    required this.searchedList,
    required this.search,
  });

  // Factory constructor for initial state with default filter
  factory FilterList.initial(List<FAQ> items) {
    final filtered = items.where((item) => item.questionType == "General").toList();
    return FilterList(
      allItems: items,
      filteredItems: filtered,
      searchedList: [],
      search: "General",
    );
  }

  FilterList copyWith({
    List<FAQ>? allItems,
    List<FAQ>? filteredItems,
    List<FAQ>? searchedList,
    String? search,
  }) {
    return FilterList(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      searchedList: searchedList??this.searchedList,
      search: search ?? this.search,
    );
  }
}

// Notifier class
class FAQNotifier extends StateNotifier<FilterList> {
  FAQNotifier() : super(FilterList.initial(_initialItems));

  static final List<FAQ> _initialItems = faqList;

  void search(String search){
    state=state.copyWith(searchedList: searchTemp(state.filteredItems, search,));
  }

  List<FAQ> searchTemp(List<FAQ> items,String search,){
    if (search.isEmpty){
      return items;
    }
    return items.where((item)=>item.question.toLowerCase().contains(search.toLowerCase())).toList();
  }

  void toggleIsReadByFilteredIndex(FAQ item, int index) {
    final modifiedItem=item.copyWith(isRead: !item.isRead);
    final updatedItem = item.copyWith(isRead: !item.isRead);
    final updatedList = [...state.filteredItems];
    updatedList[index] = updatedItem;
    state = state.copyWith(filteredItems: updatedList);
  }
 /* void toggleIsReadByFilteredIndex(int index) {
    final updatedList = List<FAQ>.from(state.filteredItems);
    final currentItem = updatedList[index];
    updatedList[index] = currentItem.copyWith(isRead: !currentItem.isRead);
    state = state.copyWith(filteredItems: updatedList);
  }*/

  void filterListByCategory(String type) {
    state = state.copyWith(
      search: type,
      filteredItems: _filterItems(state.allItems, type),
    );
  }

  List<FAQ> _filterItems(List<FAQ> list, String type) {
    return list.where((item) => item.questionType == type).toList();
  }
}

// Riverpod provider
final faqProvider = StateNotifierProvider<FAQNotifier, FilterList>((ref) {
  return FAQNotifier();
});

/*
final readStatusProvider = Provider.family<bool, int>((ref, index) {
  final filtered = ref.watch(faqProvider.select((s) => s.filteredItems));
  return filtered[index].isRead;
});
*/


List<FAQ> faqList=[
  FAQ(
    questionType: "General",
    question: "What is this app about?",
    answer: "This app is a community-driven platform designed to support students in Gilgit-Baltistan by enabling book exchanges, donations of clothes and uniforms, and peer-to-peer communication. The goal is to improve access to education and resources across the region.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    question: "Who can use this app?",
    answer: "Anyone living in Gilgit-Baltistan can use the app, including:\n- Students and their families\n- Teachers and schools\n- Donors who want to help\n- Volunteers who want to support the cause",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    question: "Is the app free to use?",
    answer: "Yes, the app is completely free to use. We believe education should be accessible to all, and this app is built to support that mission.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    question: "Which grades does the app support?",
    answer: "The app currently supports students from Class 1 to Class 12, offering book exchange and donation options for all levels.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    question: "Do I need internet access to use the app?",
    answer: "Some features of the app, like browsing or chatting, require internet access. However, we are working on offline support for basic functionalities like saving book requests or donation details.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    question: "Can I use the app outside of Gilgit-Baltistan?",
    answer: "The app is primarily designed for the Gilgit-Baltistan region. While technically accessible from anywhere, the services (like delivery, community chat, and resource exchange) are localized.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    question: "What languages does the app support?",
    answer: "The app currently supports English and Urdu. Future updates may include local languages like Shina, Burushaski, and Balti to improve accessibility.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    question: "How does the app help improve education in Gilgit-Baltistan?",
    answer: "By providing access to shared learning materials, facilitating donations, and connecting students, the app helps reduce the cost of education and strengthens student support systems.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    question: "Is the app supported by any government or NGO?",
    answer: "The app is currently an independent initiative. We are open to partnerships with government bodies or NGOs to expand our impact and services.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    question: "Can I suggest new features for the app?",
    answer: "Absolutely! We welcome feedback and ideas. You can use the 'Feedback' section in the app to send us your suggestions.",
    isRead: false,
  ),
  FAQ(
    questionType: "Services",
    question: "What services does this app provide?",
    answer: "The app provides three main services: book exchange for students from Class 1 to 12, donation of clothes and school uniforms, and a communication platform where users can chat, ask for help, or offer support. All services are built to promote community support and educational equality in Gilgit-Baltistan.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    question: "How does the book exchange work?",
    answer: "Students or parents can list books they want to give away or books they are looking for. Other users can browse these listings and directly contact the person offering or requesting the book. The exchange is done based on mutual agreement, either by meeting in person or using a delivery service if available.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    question: "Can I donate school uniforms or clothes?",
    answer: "Yes, users can donate school uniforms, winter clothes, or regular clothes that are clean and in good condition. The donation can be listed in the app with a photo and description, and other users in need can request them. It’s a simple way to support underprivileged students.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    question: "Is there a delivery or pickup service for donations?",
    answer: "Currently, the app does not offer a built-in delivery or pickup service. However, users can coordinate delivery through mutual discussion using the in-app chat feature. We are exploring partnerships with local courier services to make this process easier in future updates.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    question: "How does the chat feature work?",
    answer: "The in-app chat allows users to communicate with each other regarding book exchanges, donations, or educational questions. It is a simple, safe messaging system where you can see user profiles, message them directly, and even create group chats for schools or study topics.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    question: "Can schools or teachers use this platform?",
    answer: "Yes, schools and teachers can create accounts to request resources for their students, offer extra materials, or coordinate donation drives. It’s a great tool for educational institutions to directly engage with the community and help those in need.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    question: "Are there any limits on the number of books I can list or request?",
    answer: "There is no hard limit on the number of listings. However, to keep the platform useful and organized, we encourage users to update or remove listings when items are no longer available. This helps others find accurate and up-to-date information.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    question: "Can I post study notes or educational resources?",
    answer: "At the moment, the app focuses on physical resource sharing like books and uniforms. But we plan to include a feature in future updates where students and teachers can upload study notes, past exam papers, and learning videos to support peer-to-peer education.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    question: "What if I want to offer private tutoring through the app?",
    answer: "We are working on adding a tutoring feature where users can register as volunteer or paid tutors. For now, you can use the chat or profile description to let others know you are available to help with certain subjects or grades.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    question: "Do you plan to expand services beyond Gilgit-Baltistan?",
    answer: "Our current focus is Gilgit-Baltistan to ensure quality and local impact. However, if the platform proves successful, we aim to expand to other underserved regions in Pakistan to support education across the country.",
    isRead: false,
  ),
  FAQ(
    questionType: "Account",
    question: "How do I create an account?",
    answer: "You can create an account by signing up with your mobile number or email address. Once you verify your information through a code, you can set up your profile with your name, role (student, parent, teacher, donor), and location. This helps us connect you with the right community.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    question: "Do I need to verify my identity?",
    answer: "Yes, a basic verification using a phone number or email is required to ensure trust and security among users. We may introduce ID or school card verification in the future for added credibility, especially for tutors and teachers.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    question: "Can I use the same account on multiple devices?",
    answer: "Yes, you can log in to your account from multiple devices using the same credentials. However, for your security, we recommend logging out from shared or public devices after use.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    question: "How can I update my profile information?",
    answer: "Go to the profile section in the app, where you can update your name, profile photo, contact details, role, and address. Keeping your information accurate helps other users reach out to you easily for exchanges or donations.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    question: "What if I forget my password?",
    answer: "If you forget your password, just tap on 'Forgot Password' during login. You’ll receive a reset link or code via your registered phone number or email, allowing you to set a new password safely.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    question: "Can I delete my account?",
    answer: "Yes, you can request to delete your account at any time from the Settings section. All your personal data, listings, and chats will be permanently removed to respect your privacy.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    question: "Can I change my user role later (e.g., from student to teacher)?",
    answer: "Yes, you can change your user role by editing your profile. This helps us tailor your experience based on your needs—whether you're a student, teacher, donor, or volunteer.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    question: "Is my location visible to other users?",
    answer: "Only an approximate location (like your city or village) is shown to others, just to help with nearby exchanges or donations. Your exact address is always kept private unless you choose to share it during communication.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    question: "Can I report a problem with my account?",
    answer: "Yes, you can report any issue through the 'Help & Support' section in the app. Our support team will review your problem and respond as quickly as possible to assist you.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    question: "Can I use the app without creating an account?",
    answer: "You can browse public listings without logging in, but to contact users, post donations, or exchange books, you’ll need to sign up. This helps maintain a safe and reliable community.",
    isRead: false,
  ),
  FAQ(
    questionType: "Safety",
    question: "How is my personal data protected?",
    answer: "We use secure encryption and database protection methods to store your personal data safely. Your private details like phone number and address are never shared without your permission. Only limited profile information is shown publicly to support secure exchanges. We strictly follow data protection standards to ensure your privacy.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    question: "Is chatting with other users safe?",
    answer: "Yes, the chat system is monitored for abusive or suspicious behavior. We encourage respectful communication and provide reporting tools within every chat. If someone makes you uncomfortable, you can block and report them easily. Our team reviews reports to take immediate action when needed.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    question: "What should I do if someone is misusing the platform?",
    answer: "If you see any user behaving inappropriately or posting false information, report them through the app. Use the 'Report User' option on their profile or listings. We take every report seriously and investigate to maintain a safe space. Offenders may be warned, suspended, or banned permanently.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    question: "Are donations screened before being listed?",
    answer: "All donations are user-generated, so we rely on community trust and reporting. Users are encouraged to post clear, honest photos and descriptions. If a donation is misleading or unsafe, it can be reported and removed. We’re working on adding community review features in future versions.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    question: "Is it safe to meet someone for book or item exchange?",
    answer: "We recommend meeting in public places like schools, libraries, or community centers during the daytime. Always inform someone you trust before meeting another user. Avoid sharing your full address with strangers until you're sure of their intent. Safety is a shared responsibility.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    question: "Can children use the app safely?",
    answer: "Yes, but we encourage children under 16 to use the app under adult supervision. Parents or guardians should help manage accounts and exchanges. This ensures a safe environment for younger users while they benefit from the platform. Our goal is to support families together.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    question: "What happens to my data if I delete my account?",
    answer: "When you delete your account, all your personal data, chats, and listings are permanently removed from our servers. This helps protect your privacy and ensures your information isn't accessible to anyone else. We do not keep backup copies of deleted user data.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    question: "Are there moderators in the app?",
    answer: "Yes, we have a team of moderators who monitor flagged content, user reports, and suspicious activity. Their job is to keep the community safe, respectful, and helpful. We’re also working on AI-based moderation to quickly detect harmful or inappropriate content.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    question: "Can someone misuse my listings or photos?",
    answer: "Listings are public, so avoid sharing personal or sensitive photos. If you feel your images or descriptions are being misused, you can report it immediately. We review every report and take necessary action to remove content or ban repeat offenders. Your safety is our priority.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    question: "What measures are in place to prevent scams?",
    answer: "We verify accounts through phone or email and monitor activity for signs of scams. Users can report suspicious listings or messages at any time. Our moderation team investigates and removes scams quickly. We also educate users about safe communication and exchange practices.",
    isRead: false,
  ),

];