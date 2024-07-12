import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_pilot_client/features/onboarding/intro_pages/intro_page_3.dart';
import 'package:slide_pilot_client/features/onboarding/intro_pages/intro_page_4.dart';
import 'package:slide_pilot_client/theme/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../widgets/components/custom_text_button.dart';
import '../../home/home.dart';
import '../intro_pages/intro_page_1.dart';
import '../intro_pages/intro_page_2.dart';
import '../intro_pages/intro_page_5.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  void initState() {
    super.initState();
    _checkIfSeen();
  }

  Future<void> _checkIfSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seen') ?? false;

    if (seen) {
      _navigateToHome();
    } else {
      prefs.setBool('seen', true);
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

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
                IntroPage1(),
                IntroPage2(),
                IntroPage3(),
                IntroPage4(),
                IntroPage5(),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 140,
          color: theme.primaryColor,
          child: Column(
            children: [
              CustomTextButton(
                title: onLastPage ? 'Done' : 'Next',
                onTap: onLastPage
                    ? () {
                        _navigateToHome();
                      }
                    : () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                buttonShadow: AppPresets().whiteShadow,
                buttonColor: Colors.white,
                textColor: theme.primaryColor,
              ),
              const SizedBox(height: 16),
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
