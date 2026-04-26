import '../domain/home_step.dart';

class HomeViewModel {
  const HomeViewModel();

  String get featureId => '001-home-shell';

  String get appTitle => 'Nyaya';

  String get headline => 'Spec-driven Flutter baseline';

  String get summary =>
      'Define intent in specs, decisions, and tests before code changes.';

  List<HomeStep> get steps => const [
    HomeStep(
      id: '01',
      title: 'Write the spec first',
      description:
          'Capture the problem, goals, EARS-style requirements, and measurable '
          'acceptance criteria before code.',
    ),
    HomeStep(
      id: '02',
      title: 'Record design decisions',
      description:
          'Move architecture choices into ADRs so the team keeps the rationale '
          'with the repository.',
    ),
    HomeStep(
      id: '03',
      title: 'Trace every criterion to tests',
      description:
          'Map each acceptance criterion to unit, widget, or integration tests '
          'before release.',
    ),
  ];
}
