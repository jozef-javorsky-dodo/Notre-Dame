// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:notredame/data/repositories/settings_repository.dart';
import 'package:notredame/data/services/navigation_service.dart';
import 'package:notredame/data/services/signets-api/models/course.dart';
import 'package:notredame/data/services/signets-api/models/course_summary.dart';
import 'package:notredame/domain/constants/router_paths.dart';
import 'package:notredame/l10n/app_localizations.dart';
import 'package:notredame/ui/student/grades/widgets/grade_button.dart';
import '../../../../data/mocks/services/navigation_service_mock.dart';
import '../../../../helpers.dart';

void main() {
  late AppIntl intl;
  late NavigationServiceMock navigationServiceMock;

  final Course courseWithGrade = Course(
    acronym: 'GEN101',
    group: '02',
    session: 'H2020',
    programCode: '999',
    grade: 'C+',
    numberOfCredits: 3,
    title: 'Cours générique',
  );

  final Course courseWithGrade2 = Course(
    acronym: 'GEN102',
    group: '02',
    session: 'H2020',
    programCode: '999',
    grade: 'B+',
    numberOfCredits: 3,
    title: 'Cours générique',
  );

  final Course courseWithSummary = Course(
    acronym: 'GEN101',
    group: '02',
    session: 'H2020',
    programCode: '999',
    numberOfCredits: 3,
    title: 'Cours générique',
    summary: CourseSummary(
      currentMark: 5,
      currentMarkInPercent: 50,
      markOutOf: 10,
      passMark: 6,
      standardDeviation: 2.3,
      median: 4.5,
      percentileRank: 99,
      evaluations: [],
    ),
  );

  final Course courseWithSummary2 = Course(
    acronym: 'GEN102',
    group: '02',
    session: 'H2020',
    programCode: '999',
    numberOfCredits: 3,
    title: 'Cours générique',
    summary: CourseSummary(
      currentMark: null,
      currentMarkInPercent: null,
      markOutOf: 100,
      passMark: 60,
      standardDeviation: 2.3,
      median: 4.5,
      percentileRank: 99,
      evaluations: [],
    ),
  );

  final Course gradesNotAvailable = Course(
    acronym: 'GEN101',
    group: '02',
    session: 'H2020',
    programCode: '999',
    numberOfCredits: 3,
    title: 'Cours générique',
  );

  group("GradeButton -", () {
    setUp(() async {
      intl = await setupAppIntl();
      setupNavigationServiceMock();
      navigationServiceMock = setupNavigationServiceMock();
    });

    tearDown(() {
      unregister<SettingsRepository>();
      unregister<NavigationService>();
    });

    group("UI -", () {
      testWidgets("Display acronym of the course and the current grade", (WidgetTester tester) async {
        await tester.pumpWidget(localizedWidget(child: GradeButton(courseWithGrade)));
        await tester.pumpAndSettle();

        expect(find.text(courseWithGrade.acronym), findsOneWidget);
        expect(find.text(courseWithGrade.grade!), findsOneWidget);
      });

      testWidgets("Grade not available and summary is loaded.", (WidgetTester tester) async {
        await tester.pumpWidget(localizedWidget(child: GradeButton(courseWithSummary)));
        await tester.pumpAndSettle();

        expect(find.text(courseWithGrade.acronym), findsOneWidget);
        expect(
          find.text(intl.grades_grade_in_percentage(courseWithSummary.summary!.currentMarkInPercent!.round())),
          findsOneWidget,
          reason:
              'There is no grade available and the course summary exists so the '
              'current mark in percentage should be displayed',
        );
      });

      testWidgets("Grade not available (currentMarkInPercent == null) and summary is loaded.", (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(localizedWidget(child: GradeButton(courseWithSummary2)));
        await tester.pumpAndSettle();

        expect(find.text(courseWithGrade2.acronym), findsOneWidget);
        expect(
          find.text(intl.grades_not_available),
          findsOneWidget,
          reason:
              'The course summary exists but the current mark in percentage is null so '
              'N/A should be displayed',
        );
      });

      testWidgets("Grade and summary not available.", (WidgetTester tester) async {
        await tester.pumpWidget(localizedWidget(child: GradeButton(gradesNotAvailable)));
        await tester.pumpAndSettle();

        expect(find.text(courseWithGrade.acronym), findsOneWidget);
        expect(
          find.text(intl.grades_not_available),
          findsOneWidget,
          reason:
              'There is no grade available and the course summary doesn\'t exist '
              'so "N/A" should be displayed',
        );
      });
    });

    group('Interactions - ', () {
      testWidgets('Grade button redirects to grades view when tapped ', (WidgetTester tester) async {
        await tester.pumpWidget(localizedWidget(child: GradeButton(courseWithGrade)));
        await tester.pumpAndSettle();

        await tester.tap(find.text(courseWithGrade.acronym));

        verify(navigationServiceMock.pushNamed(RouterPaths.gradeDetails, arguments: courseWithGrade));
      });
    });
  });
}
