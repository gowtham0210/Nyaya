import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';

void main() {
  test('AC-003 exposes a traceable feature baseline', () {
    const viewModel = HomeViewModel();

    expect(viewModel.featureId, '001-home-shell');
    expect(viewModel.steps, hasLength(3));
    expect(
      viewModel.steps.map((step) => step.title),
      containsAll(const [
        'Write the spec first',
        'Record design decisions',
        'Trace every criterion to tests',
      ]),
    );
  });
}
