import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/core/presentation/widgets/initials_avatar.dart';

void main() {
  test('initials are up to two letters', () {
    expect(InitialsAvatar.initialsOf('asha rao kumar'), 'AR');
    expect(InitialsAvatar.initialsOf('Asha'), 'A');
    expect(InitialsAvatar.initialsOf('  '), '?');
  });

  testWidgets('the colour comes from the name, not hashCode', (tester) async {
    Color colorFor(String name) {
      final box = tester.widget<Container>(
        find.descendant(
          of: find.byType(InitialsAvatar),
          matching: find.byType(Container),
        ),
      );
      return (box.decoration! as BoxDecoration).color!;
    }

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: InitialsAvatar(name: 'Asha Rao'),
      ),
    );
    // 'Asha Rao' code units sum to 703; 703 % 5 = 3 → the fourth colour.
    expect(colorFor('Asha Rao'), const Color(0xFF1C9C90));
  });
}
