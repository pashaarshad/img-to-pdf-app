import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/brand_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: const Text('About & Privacy'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Logo & Title
          Center(
            child: Column(
              children: [
                const BrandLogo(size: 72),
                const SizedBox(height: 14),
                const Text(
                  'Image to PDF Converter',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textMain,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your images. One perfect PDF.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryRed,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Version 1.0.0 · Free & Open Source',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 14),
                const TrustBadgesRow(),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Overview description
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceGrey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: const Text(
              'Image to PDF Converter is a simple, powerful and privacy-focused application designed to convert images into high-quality PDF documents.\n\n'
              'Create, organize, customize and manage your PDF documents easily, directly on your device.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: AppTheme.textMain,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Developed By Card (Trademark: AP Programming Tech)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primaryRed.withValues(alpha: 0.35), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryRed.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRedLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: AppTheme.primaryRed,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'DEVELOPED BY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryRed,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'AP Programming Tech™',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textMain,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Created with care by AP Programming Tech.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Our Mission Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceGrey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.flag_outlined, size: 18, color: AppTheme.primaryRed),
                    SizedBox(width: 8),
                    Text(
                      'Our Mission',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textMain,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'To provide everyone with a simple, reliable and completely free PDF conversion experience.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppTheme.textMain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Product Highlights
          const Text(
            'Product Highlights',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 12),
          _HighlightItem(text: 'Completely free to use.'),
          _HighlightItem(text: 'No advertisements.'),
          _HighlightItem(text: 'No subscription fees.'),
          _HighlightItem(text: 'No mandatory registration.'),
          _HighlightItem(text: 'Offline image-to-PDF conversion.'),
          _HighlightItem(text: 'Your documents stay on your device.'),
          _HighlightItem(text: 'Open-source software.'),

          const SizedBox(height: 24),

          // Technical Privacy Notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceGrey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 18, color: AppTheme.primaryRed),
                    SizedBox(width: 8),
                    Text(
                      'Privacy & Security Guarantee',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textMain,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• No internet permission is declared in this application.\n'
                  '• No user accounts, registration, or logins are required.\n'
                  '• No analytics, telemetry, or behavioral tracking SDKs exist in this app.\n'
                  '• All PDF generation is handled by pure offline local code.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: AppTheme.textMain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Open Source License Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Open Source Project – MIT License',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMain,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Permission is hereby granted, free of charge, to any person obtaining a copy '
                  'of this software and associated documentation files, to deal in the Software '
                  'without restriction, including the rights to use, copy, modify, merge, '
                  'publish, distribute, sublicense, and/or sell copies.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.45,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Trademark and Copyright footer
          Center(
            child: Column(
              children: const [
                Text(
                  '© 2026 AP Programming Tech. All rights reserved.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMain,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Open Source Project – MIT License.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _HighlightItem extends StatelessWidget {
  final String text;

  const _HighlightItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: AppTheme.primaryRed,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textMain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
