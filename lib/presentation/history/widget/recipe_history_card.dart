import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_text_styles.dart';
import 'package:noodle_timer/presentation/common/widget/ramen_card_image.dart';
import 'package:noodle_timer/presentation/history/widget/tag.dart';

class RecipeHistoryCard extends StatelessWidget {
  final String date;
  final String imageUrl;
  final String name;
  final String cookedTime;
  final String noodleState;
  final String eggState;
  final VoidCallback onCookAgain;
  final VoidCallback onDelete;

  const RecipeHistoryCard({
    required this.date,
    required this.imageUrl,
    required this.name,
    required this.cookedTime,
    required this.noodleState,
    required this.eggState,
    required this.onCookAgain,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          date,
          style: NoodleTextStyles.titleSm.copyWith(
            color: NoodleColors.neutral900,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: RamenCardImage(
                      imageUrl: imageUrl,
                      width: 90,
                      height: 90,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: NoodleTextStyles.titleXSmBold),
                        const SizedBox(height: 4),
                        Text(
                          cookedTime,
                          style: NoodleTextStyles.titleSm.copyWith(
                            color: NoodleColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Tag(noodleState),
                            const SizedBox(width: 8),
                            Tag(eggState),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: NoodleColors.neutral900,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: onCookAgain,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: NoodleColors.neutral900,
                    side: BorderSide(color: NoodleColors.neutral400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: NoodleTextStyles.titleXSmBold,
                  ),
                  child: const Text('다시 조리 하기'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
