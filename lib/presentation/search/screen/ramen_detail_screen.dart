import 'package:flutter/material.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/common/custom_button.dart';
import 'package:noodle_timer/presentation/common/ramen_card_image.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/search/widget/spicy_tag.dart';

class RamenDetailScreen extends StatelessWidget {
  final RamenEntity ramen;

  const RamenDetailScreen({
    required this.ramen,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ramen.name,
          style: NoodleTextStyles.titleSmBold.copyWith(
            color: NoodleColors.neutral1000,
          ),
        ),
        backgroundColor: NoodleColors.neutral100,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: RamenCardImage(
                    imageUrl: ramen.imageUrl,
                    width: 220,
                    height: 220,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    ramen.name,
                    style: NoodleTextStyles.titleSmBold.copyWith(
                      color: NoodleColors.neutral1000,
                    ),
                  ),
                  const Spacer(),
                  SpicyTag(label: ramen.spicyLevel),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ramen.description,
                style: NoodleTextStyles.titleSm.copyWith(
                  color: NoodleColors.neutral800,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '조리방법',
                style: NoodleTextStyles.titleXSmBold.copyWith(
                  color: NoodleColors.neutral1000,
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                ramen.recipe,
                style: NoodleTextStyles.titleSm.copyWith(
                  color: NoodleColors.neutral1000,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton(
                  buttonText: '조리하기',
                  onPressed: () {},
                  isEnabled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
