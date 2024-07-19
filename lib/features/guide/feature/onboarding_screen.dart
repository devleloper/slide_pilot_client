import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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

  // Check if all necessary permissions are granted
  Future<bool> _areAllPermissionsGranted() async {
    final bluetoothConnectStatus = await Permission.bluetoothConnect.status;
    final locationStatus = await Permission.location.status;

    return bluetoothConnectStatus.isGranted && locationStatus.isGranted;
  }

  void _showPermissionError() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Column(
          children: [
            Icon(CupertinoIcons.exclamationmark_triangle_fill,
                size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            const Text('Permissions Required'),
          ],
        ),
        content: const Text(
            'Please grant all required permissions to ensure the app functions correctly. If you deny, some features may not work properly.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            child: const Text('Deny'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              _controller.jumpToPage(1);
            },
            child: const Text(
              'Allow',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
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
                    ? () async {
                        if (await _areAllPermissionsGranted()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        } else {
                          _showPermissionError();
                        }
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
