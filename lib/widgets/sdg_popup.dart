import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// SDG informational popup with scrollable content
class SDGPopup extends StatelessWidget {
  const SDGPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/img/sdg_logo.png',
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.eco,
                          color: Colors.white,
                          size: 20,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Sustainable Development Goals',
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Introduction
                    const Text(
                      'Flavorful contributes meaningfully to several United Nations Sustainable Development Goals (SDGs) by promoting health, education, and responsible consumption through its digital culinary platform. By integrating verified content, nutritional guidance, and culturally diverse recipes, the application extends its impact beyond a simple recipe-sharing tool, positioning itself as a socially responsible and educational resource.',
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // SDG 3
                    _buildSDGSection(
                      number: '3',
                      title: 'Good Health and Well-Being',
                      content:
                      'Flavorful directly addresses health and wellness by incorporating nutritious recipe options alongside culturally authentic dishes. Users are guided in selecting balanced meals, understanding ingredient choices, and adopting healthier cooking methods. By providing structured instructions and portion recommendations, the application empowers individuals to make informed dietary decisions, ultimately fostering healthier lifestyles and contributing to the prevention of diet-related illnesses.',
                      color: const Color(0xFF4C9F38),
                    ),

                    const SizedBox(height: 20),

                    // SDG 4
                    _buildSDGSection(
                      number: '4',
                      title: 'Quality Education',
                      content:
                      'The platform serves as an informal educational resource by offering users access to culinary knowledge and skills development. Through detailed step-by-step instructions, ingredient explanations, and chef-provided insights, Flavorful promotes lifelong learning in the culinary domain. Users gain both practical cooking skills and cultural literacy, enhancing their appreciation of global cuisines while encouraging self-directed, experiential learning.',
                      color: const Color(0xFFC5192D),
                    ),

                    const SizedBox(height: 20),

                    // SDG 12
                    _buildSDGSection(
                      number: '12',
                      title: 'Responsible Consumption and Production',
                      content:
                      'Flavorful encourages sustainable culinary practices by promoting mindful use of ingredients, proper portion control, and reduced food waste. Each recipe includes precise measurements and clear instructions, enabling users to plan meals efficiently and minimize unnecessary consumption. By fostering awareness of responsible food production and preparation, the application supports environmentally conscious behaviors and encourages users to adopt practices that contribute to global sustainability.',
                      color: const Color(0xFFBF8B2E),
                    ),

                    const SizedBox(height: 24),

                    // Closing statement
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8A00).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF8A00).withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'Through these SDG-aligned features, Flavorful demonstrates that technology-driven culinary platforms can simultaneously educate, promote health, and encourage sustainability, creating a holistic impact on both individual users and broader societal practices.',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSDGSection({
    required String number,
    required String title,
    required String content,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'SDG $number - $title',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 14,
            color: AppColors.textPrimary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}