// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:skeletonizer/skeletonizer.dart';

// Project imports:
import 'package:notredame/data/services/navigation_service.dart';
import 'package:notredame/data/services/signets-api/models/course.dart';
import 'package:notredame/domain/constants/router_paths.dart';
import 'package:notredame/l10n/app_localizations.dart';
import 'package:notredame/locator.dart';
import 'package:notredame/ui/core/themes/app_palette.dart';
import 'package:notredame/ui/core/themes/app_theme.dart';

class GradeButton extends StatelessWidget {
  final Course course;
  final Color? color;

  /// Used to redirect on the dashboard.
  final NavigationService _navigationService = locator<NavigationService>();

  GradeButton(this.course, {super.key, this.color});

  @override
  Widget build(BuildContext context) => Card(
    color: color,
    child: InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _navigationService.pushNamed(RouterPaths.gradeDetails, arguments: course),
      child: _buildGradeButton(context),
    ),
  );

  /// Build the grade string based on the available information. By default
  /// will return [grades_not_available].
  String gradeString(AppIntl intl) {
    if (course.grade != null) {
      return course.grade!;
    } else if (course.summary != null &&
        course.summary!.markOutOf > 0 &&
        !(course.inReviewPeriod && !(course.allReviewsCompleted ?? false))) {
      if (course.summary!.currentMarkInPercent != null) {
        return intl.grades_grade_in_percentage(course.summary!.currentMarkInPercent!.round());
      }
    }

    return intl.grades_not_available;
  }

  SizedBox _buildGradeButton(BuildContext context) {
    return SizedBox(
      height: 68,
      width: 68,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Hero(
                  tag: 'course_acronym_${course.acronym}_${course.session}',
                  child: Material(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppPalette.etsLightRed,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(2.5), topRight: Radius.circular(2.5)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Skeleton.keep(
                              child: Text(
                                course.acronym,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppPalette.grey.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Text(
                gradeString(AppIntl.of(context)!),
                style: TextStyle(fontSize: 22, color: context.theme.appColors.fadedText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
