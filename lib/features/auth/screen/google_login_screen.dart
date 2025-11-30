import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:projek_akhir_edukasi/features/auth/service/google_auth_service.dart';
import 'package:projek_akhir_edukasi/features/dashboard/screen/app_main_screen.dart';

class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen>
    with SingleTickerProviderStateMixin {
  final GoogleAuthService _authService = GoogleAuthService();
  bool _isLoading = false;
  late AnimationController _blobController;

  @override
  void initState() {
    super.initState();
    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _blobController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential? userCredential = await _authService.signInWithGoogle();

      if (userCredential != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppMainScreen()),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login dibatalkan atau gagal.')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background Blobs
          AnimatedBuilder(
            animation: _blobController,
            builder: (context, child) {
              return CustomPaint(
                painter: BlobPainter(_blobController.value, isDark),
                size: Size.infinite,
              );
            },
          ),

          // Glassmorphism Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.2)
                            : Colors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo with animation
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF6366F1),
                                const Color(0xFF8B5CF6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.school,
                            size: 60,
                            color: Colors.white,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .scale(delay: 200.ms, duration: 500.ms),

                        const SizedBox(height: 32),

                        // Title with animation
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            fontSize: 20,
                            color: isDark
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),

                        const SizedBox(height: 8),

                        Text(
                          'Edu Call',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 500.ms, duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),

                        const SizedBox(height: 48),

                        // Sign In Button with animation
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _handleSignIn,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.login, size: 24),
                            label: Text(
                              _isLoading ? 'Signing in...' : 'Sign in with Google',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              shadowColor: const Color(0xFF6366F1).withOpacity(0.4),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 700.ms, duration: 600.ms)
                            .slideY(begin: 0.5, end: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for animated gradient blobs
class BlobPainter extends CustomPainter {
  final double animationValue;
  final bool isDark;

  BlobPainter(this.animationValue, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..shader = LinearGradient(
        colors: isDark
            ? [
                const Color(0xFF6366F1).withOpacity(0.3),
                const Color(0xFF8B5CF6).withOpacity(0.2),
              ]
            : [
                const Color(0xFF6366F1).withOpacity(0.2),
                const Color(0xFF8B5CF6).withOpacity(0.15),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint2 = Paint()
      ..shader = LinearGradient(
        colors: isDark
            ? [
                const Color(0xFF8B5CF6).withOpacity(0.25),
                const Color(0xFFEC4899).withOpacity(0.15),
              ]
            : [
                const Color(0xFF8B5CF6).withOpacity(0.15),
                const Color(0xFFEC4899).withOpacity(0.1),
              ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Animated blob 1
    final path1 = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(
            size.width * 0.2 + (animationValue * 50),
            size.height * 0.3 + (animationValue * 30),
          ),
          radius: size.width * 0.3,
        ),
      );
    canvas.drawPath(path1, paint1);

    // Animated blob 2
    final path2 = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(
            size.width * 0.8 - (animationValue * 40),
            size.height * 0.7 - (animationValue * 50),
          ),
          radius: size.width * 0.35,
        ),
      );
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(BlobPainter oldDelegate) => true;
}
