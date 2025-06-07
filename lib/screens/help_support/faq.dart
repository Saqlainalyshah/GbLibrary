import 'package:booksexchange/components/layout_components/small_components.dart';
import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/components/textfield.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FAQScreen extends ConsumerWidget {
  FAQScreen({super.key});
  final TextEditingController controller=TextEditingController();
  final selectedIndex=StateProvider.autoDispose<int>((ref)=>0);
  @override
  Widget build(BuildContext context,WidgetRef ref) {
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
              child: CustomTextField(controller: controller,
                onChanged: (value){
                  ref.read(faqProvider.notifier).search(value);
                },
                leadingIcon: Icons.search,
                hintText: "Search",
              ),
            ),
            SizedBox(
              height: 40,
              child: Consumer(
                builder: (context, ref, _) {
                  print("build inside list");
                  final selected = ref.watch(selectedIndex); // only watch once here
                  List<String> l = ["General", "Account", "Services","Safety"];

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: l.length,
                    itemBuilder: (context, index) {
                      final isSelected = selected == index;
                      return OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: isSelected ? BorderSide.none : null,
                          backgroundColor: isSelected ? AppThemeClass.primary  : null,
                        ),
                        onPressed: () {
                          ref.read(selectedIndex.notifier).state = index;
                          ref.read(faqProvider.notifier).filterList(l[index]);
                        },
                        child: CustomText(
                          text: l[index],
                          color: isSelected ? AppThemeClass.whiteText : Colors.black,
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(width: 10),
                  );
                },
              ),
            ),
            Expanded(
              child: Consumer(
                builder:(context,ref,child){
                  print("build inside list");
                  final faqList=ref.watch(faqProvider);

                  return  ListView.separated(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: faqList.filteredItems.length,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                    itemBuilder: (context,index){
                      final item= faqList.filteredItems[index];
                      return GestureDetector(
                        onTap: (){
                          ref.read(faqProvider.notifier).toggleIsReadByFilteredIndex(index);
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
                                  Flexible(child: CustomText(text: item.title,isBold: true,)),
                                  Icon(item.isRead? Icons.keyboard_arrow_down_outlined: Icons.keyboard_arrow_up,color: Colors.grey.shade700,)

                                ],
                              ),
                              if(item.isRead==true)Divider(),
                              if(item.isRead==true)CustomText(text: item.subTitle,)
                            ],
                          ),
                        ),
                      );
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
  final String title;
  final String subTitle;
  final bool isRead;

  FAQ({
    required this.questionType,
    required this.title,
    required this.subTitle,
    required this.isRead,
  });

  FAQ copyWith({
    String? questionType,
    String? title,
    String? subTitle,
    bool? isRead,
  }) {
    return FAQ(
      questionType: questionType ?? this.questionType,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      isRead: isRead ?? this.isRead,
    );
  }
}

// Filter list class
class FilterList {
  final List<FAQ> allItems;
  final List<FAQ> filteredItems;
  final String search;

  FilterList({
    required this.allItems,
    required this.filteredItems,
    required this.search,
  });

  // Factory constructor for initial state with default filter
  factory FilterList.initial(List<FAQ> items) {
    final filtered = items.where((item) => item.questionType == "General").toList();
    return FilterList(
      allItems: items,
      filteredItems: filtered,
      search: "General",
    );
  }

  FilterList copyWith({
    List<FAQ>? allItems,
    List<FAQ>? filteredItems,
    String? search,
  }) {
    return FilterList(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      search: search ?? this.search,
    );
  }
}

// Notifier class
class FAQNotifier extends StateNotifier<FilterList> {
  FAQNotifier() : super(FilterList.initial(_initialItems));

  static final List<FAQ> _initialItems = faqList;

  void addItem(FAQ item) {
    final updatedList = [...state.allItems, item];
    state = state.copyWith(
      allItems: updatedList,
      filteredItems: _filterItems(updatedList, state.search),
    );
  }
  void search(String search){
    state=state.copyWith(filteredItems: searchTemp(state.allItems, search));
  }

  List<FAQ> searchTemp(List<FAQ> items,String search){
    if (search.isEmpty){
      return items;
    }
    return items.where((item)=>item.title.toLowerCase().contains(search.toLowerCase())).toList();
  }

  void toggleIsReadByFilteredIndex(int index) {
    final filteredItem = state.filteredItems[index];

    // Update the item in allItems by finding the matching one
    final updatedAll = state.allItems.map((faq) {
      if (faq.title == filteredItem.title && faq.questionType == filteredItem.questionType) {
        return faq.copyWith(isRead: !faq.isRead); // toggle isRead
      }
      return faq;
    }).toList();

    // Refresh filtered list with updated items
    final updatedFiltered = _filterItems(updatedAll, state.search);

    // Update the state
    state = state.copyWith(
      allItems: updatedAll,
      filteredItems: updatedFiltered,
    );
  }

  void filterList(String type) {
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



List<FAQ> faqList=[
  FAQ(
    questionType: "General",
    title: "What is this app about?",
    subTitle: "This app is a community-driven platform designed to support students in Gilgit-Baltistan by enabling book exchanges, donations of clothes and uniforms, and peer-to-peer communication. The goal is to improve access to education and resources across the region.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    title: "Who can use this app?",
    subTitle: "Anyone living in Gilgit-Baltistan can use the app, including:\n- Students and their families\n- Teachers and schools\n- Donors who want to help\n- Volunteers who want to support the cause",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    title: "Is the app free to use?",
    subTitle: "Yes, the app is completely free to use. We believe education should be accessible to all, and this app is built to support that mission.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    title: "Which grades does the app support?",
    subTitle: "The app currently supports students from Class 1 to Class 12, offering book exchange and donation options for all levels.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    title: "Do I need internet access to use the app?",
    subTitle: "Some features of the app, like browsing or chatting, require internet access. However, we are working on offline support for basic functionalities like saving book requests or donation details.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    title: "Can I use the app outside of Gilgit-Baltistan?",
    subTitle: "The app is primarily designed for the Gilgit-Baltistan region. While technically accessible from anywhere, the services (like delivery, community chat, and resource exchange) are localized.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    title: "What languages does the app support?",
    subTitle: "The app currently supports English and Urdu. Future updates may include local languages like Shina, Burushaski, and Balti to improve accessibility.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    title: "How does the app help improve education in Gilgit-Baltistan?",
    subTitle: "By providing access to shared learning materials, facilitating donations, and connecting students, the app helps reduce the cost of education and strengthens student support systems.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    title: "Is the app supported by any government or NGO?",
    subTitle: "The app is currently an independent initiative. We are open to partnerships with government bodies or NGOs to expand our impact and services.",
    isRead: false,
  ),

  FAQ(
    questionType: "General",
    title: "Can I suggest new features for the app?",
    subTitle: "Absolutely! We welcome feedback and ideas. You can use the 'Feedback' section in the app to send us your suggestions.",
    isRead: false,
  ),
  FAQ(
    questionType: "Services",
    title: "What services does this app provide?",
    subTitle: "The app provides three main services: book exchange for students from Class 1 to 12, donation of clothes and school uniforms, and a communication platform where users can chat, ask for help, or offer support. All services are built to promote community support and educational equality in Gilgit-Baltistan.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    title: "How does the book exchange work?",
    subTitle: "Students or parents can list books they want to give away or books they are looking for. Other users can browse these listings and directly contact the person offering or requesting the book. The exchange is done based on mutual agreement, either by meeting in person or using a delivery service if available.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    title: "Can I donate school uniforms or clothes?",
    subTitle: "Yes, users can donate school uniforms, winter clothes, or regular clothes that are clean and in good condition. The donation can be listed in the app with a photo and description, and other users in need can request them. It’s a simple way to support underprivileged students.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    title: "Is there a delivery or pickup service for donations?",
    subTitle: "Currently, the app does not offer a built-in delivery or pickup service. However, users can coordinate delivery through mutual discussion using the in-app chat feature. We are exploring partnerships with local courier services to make this process easier in future updates.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    title: "How does the chat feature work?",
    subTitle: "The in-app chat allows users to communicate with each other regarding book exchanges, donations, or educational questions. It is a simple, safe messaging system where you can see user profiles, message them directly, and even create group chats for schools or study topics.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    title: "Can schools or teachers use this platform?",
    subTitle: "Yes, schools and teachers can create accounts to request resources for their students, offer extra materials, or coordinate donation drives. It’s a great tool for educational institutions to directly engage with the community and help those in need.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    title: "Are there any limits on the number of books I can list or request?",
    subTitle: "There is no hard limit on the number of listings. However, to keep the platform useful and organized, we encourage users to update or remove listings when items are no longer available. This helps others find accurate and up-to-date information.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    title: "Can I post study notes or educational resources?",
    subTitle: "At the moment, the app focuses on physical resource sharing like books and uniforms. But we plan to include a feature in future updates where students and teachers can upload study notes, past exam papers, and learning videos to support peer-to-peer education.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    title: "What if I want to offer private tutoring through the app?",
    subTitle: "We are working on adding a tutoring feature where users can register as volunteer or paid tutors. For now, you can use the chat or profile description to let others know you are available to help with certain subjects or grades.",
    isRead: false,
  ),

  FAQ(
    questionType: "Services",
    title: "Do you plan to expand services beyond Gilgit-Baltistan?",
    subTitle: "Our current focus is Gilgit-Baltistan to ensure quality and local impact. However, if the platform proves successful, we aim to expand to other underserved regions in Pakistan to support education across the country.",
    isRead: false,
  ),
  FAQ(
    questionType: "Account",
    title: "How do I create an account?",
    subTitle: "You can create an account by signing up with your mobile number or email address. Once you verify your information through a code, you can set up your profile with your name, role (student, parent, teacher, donor), and location. This helps us connect you with the right community.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    title: "Do I need to verify my identity?",
    subTitle: "Yes, a basic verification using a phone number or email is required to ensure trust and security among users. We may introduce ID or school card verification in the future for added credibility, especially for tutors and teachers.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    title: "Can I use the same account on multiple devices?",
    subTitle: "Yes, you can log in to your account from multiple devices using the same credentials. However, for your security, we recommend logging out from shared or public devices after use.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    title: "How can I update my profile information?",
    subTitle: "Go to the profile section in the app, where you can update your name, profile photo, contact details, role, and address. Keeping your information accurate helps other users reach out to you easily for exchanges or donations.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    title: "What if I forget my password?",
    subTitle: "If you forget your password, just tap on 'Forgot Password' during login. You’ll receive a reset link or code via your registered phone number or email, allowing you to set a new password safely.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    title: "Can I delete my account?",
    subTitle: "Yes, you can request to delete your account at any time from the Settings section. All your personal data, listings, and chats will be permanently removed to respect your privacy.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    title: "Can I change my user role later (e.g., from student to teacher)?",
    subTitle: "Yes, you can change your user role by editing your profile. This helps us tailor your experience based on your needs—whether you're a student, teacher, donor, or volunteer.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    title: "Is my location visible to other users?",
    subTitle: "Only an approximate location (like your city or village) is shown to others, just to help with nearby exchanges or donations. Your exact address is always kept private unless you choose to share it during communication.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    title: "Can I report a problem with my account?",
    subTitle: "Yes, you can report any issue through the 'Help & Support' section in the app. Our support team will review your problem and respond as quickly as possible to assist you.",
    isRead: false,
  ),

  FAQ(
    questionType: "Account",
    title: "Can I use the app without creating an account?",
    subTitle: "You can browse public listings without logging in, but to contact users, post donations, or exchange books, you’ll need to sign up. This helps maintain a safe and reliable community.",
    isRead: false,
  ),
  FAQ(
    questionType: "Safety",
    title: "How is my personal data protected?",
    subTitle: "We use secure encryption and database protection methods to store your personal data safely. Your private details like phone number and address are never shared without your permission. Only limited profile information is shown publicly to support secure exchanges. We strictly follow data protection standards to ensure your privacy.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    title: "Is chatting with other users safe?",
    subTitle: "Yes, the chat system is monitored for abusive or suspicious behavior. We encourage respectful communication and provide reporting tools within every chat. If someone makes you uncomfortable, you can block and report them easily. Our team reviews reports to take immediate action when needed.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    title: "What should I do if someone is misusing the platform?",
    subTitle: "If you see any user behaving inappropriately or posting false information, report them through the app. Use the 'Report User' option on their profile or listings. We take every report seriously and investigate to maintain a safe space. Offenders may be warned, suspended, or banned permanently.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    title: "Are donations screened before being listed?",
    subTitle: "All donations are user-generated, so we rely on community trust and reporting. Users are encouraged to post clear, honest photos and descriptions. If a donation is misleading or unsafe, it can be reported and removed. We’re working on adding community review features in future versions.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    title: "Is it safe to meet someone for book or item exchange?",
    subTitle: "We recommend meeting in public places like schools, libraries, or community centers during the daytime. Always inform someone you trust before meeting another user. Avoid sharing your full address with strangers until you're sure of their intent. Safety is a shared responsibility.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    title: "Can children use the app safely?",
    subTitle: "Yes, but we encourage children under 16 to use the app under adult supervision. Parents or guardians should help manage accounts and exchanges. This ensures a safe environment for younger users while they benefit from the platform. Our goal is to support families together.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    title: "What happens to my data if I delete my account?",
    subTitle: "When you delete your account, all your personal data, chats, and listings are permanently removed from our servers. This helps protect your privacy and ensures your information isn't accessible to anyone else. We do not keep backup copies of deleted user data.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    title: "Are there moderators in the app?",
    subTitle: "Yes, we have a team of moderators who monitor flagged content, user reports, and suspicious activity. Their job is to keep the community safe, respectful, and helpful. We’re also working on AI-based moderation to quickly detect harmful or inappropriate content.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    title: "Can someone misuse my listings or photos?",
    subTitle: "Listings are public, so avoid sharing personal or sensitive photos. If you feel your images or descriptions are being misused, you can report it immediately. We review every report and take necessary action to remove content or ban repeat offenders. Your safety is our priority.",
    isRead: false,
  ),

  FAQ(
    questionType: "Safety",
    title: "What measures are in place to prevent scams?",
    subTitle: "We verify accounts through phone or email and monitor activity for signs of scams. Users can report suspicious listings or messages at any time. Our moderation team investigates and removes scams quickly. We also educate users about safe communication and exchange practices.",
    isRead: false,
  ),

];