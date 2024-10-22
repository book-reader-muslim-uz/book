import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:book/features/presentation/home/widgets/bottom_overlay_widget.dart';
import 'package:book/features/presentation/home/widgets/top_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookReaderScreen extends StatefulWidget {
  final String url;
  const BookReaderScreen({super.key, required this.url});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen>
    with SingleTickerProviderStateMixin {
  bool _isOverlayVisible = true;
  int _currentPage = 0;
  int _initial = 0;
  int _totalPages = 0;
  bool horizontal = false;
  late PDFViewController _pdfViewController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadPage();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
    });
  }

  void _onSliderChange(double value) {
    setState(() {
      _currentPage = value.toInt();
    });
    _pdfViewController.setPage(_currentPage);
    _savePage();
  }

  Future<void> _savePage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(widget.url, _currentPage);
  }

  Future<void> _loadPage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _initial = prefs.getInt(widget.url) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PDF(
            fitEachPage: true,
            defaultPage: _initial,
            swipeHorizontal: horizontal,
            nightMode: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark,
            fitPolicy: FitPolicy.BOTH,
            onViewCreated: (controller) async {
              _pdfViewController = controller;
              _pdfViewController.setPage(5);
            },
            onPageChanged: (page, total) {
              _savePage();
              setState(() {
                _currentPage = page!;
                _totalPages = total!;
              });
            },
          ).cachedFromUrl(
            widget.url,
            placeholder: (progress) => Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(20),
                          value: progress / 100,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.lerp(
                              Colors.green,
                              Colors.blue,
                              _animation.value,
                            )!,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          progress.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            errorWidget: (error) => Center(child: Text(error.toString())),
          ),
          if (_isOverlayVisible) TopOverlay(context: context),
          if (_isOverlayVisible)
            BottomOverlay(
                currentPage: _currentPage,
                totalPages: _totalPages,
                onSliderChange: _onSliderChange),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 90),
            child: GestureDetector(
              onTap: _toggleOverlay,
            ),
          ),
        ],
      ),
    );
  }
}
