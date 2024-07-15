import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_pilot_client/features/home/home.dart';
import 'package:slide_pilot_client/theme/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../intro_pages/intro_page_0.dart';
import '../intro_pages/intro_page_1.dart';
import '../intro_pages/intro_page_2.dart';
import '../intro_pages/intro_page_3.dart';
import '../intro_pages/intro_page_4.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              onPageChanged: (index) {
                setState(() {
                  onLastPage = (index == 4);
                });
              },
              controller: _controller,
              children: const [
                IntroPage0(),
                IntroPage1(),
                IntroPage2(),
                IntroPage3(),
                IntroPage4(),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 140,
          color: theme.primaryColor,
          child: Column(
            children: [
              CustomTextGuideButton(
                icon: onLastPage
                    ? CupertinoIcons.checkmark_alt_circle_fill
                    : CupertinoIcons.chevron_compact_right,
                title: onLastPage ? 'Done' : 'Next',
                onTap: onLastPage
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    : () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
              ),
              const SizedBox(height: 32),
              SmoothPageIndicator(
                effect: const ExpandingDotsEffect(
                  spacing: 8.0,
                  dotColor: Colors.white,
                  activeDotColor: Colors.white,
                ),
                controller: _controller,
                count: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CustomTextGuideButton widget for navigation
class CustomTextGuideButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final IconData icon;

  const CustomTextGuideButton({
    super.key,
    required this.title,
    this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 68,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppPresets().whiteShadow],
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'RedHatDisplayRegular',
                    fontSize: 16,
                    color: theme.primaryColor,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  icon,
                  color: theme.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
