import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/models/chest_type.dart';

void main() {
  group('ChestType', () {
    group('gemColor', () {
      test('bronze returns amber', () {
        final result = ChestType.bronze.gemColor;
        expect(result.toARGB32(), 0xFFFF8F00);
      });

      test('silver returns light teal', () {
        final result = ChestType.silver.gemColor;
        expect(result.toARGB32(), 0xFF80DEEA);
      });

      test('gold returns gold', () {
        final result = ChestType.gold.gemColor;
        expect(result.toARGB32(), 0xFFFFD700);
      });

      test('legendary returns light purple', () {
        final result = ChestType.legendary.gemColor;
        expect(result.toARGB32(), 0xFFCE93D8);
      });
    });

    group('color', () {
      test('bronze returns brown', () {
        final result = ChestType.bronze.color;
        expect(result.toARGB32(), 0xFF8D6E63);
      });

      test('silver returns gray', () {
        final result = ChestType.silver.color;
        expect(result.toARGB32(), 0xFF9E9E9E);
      });

      test('gold returns amber', () {
        final result = ChestType.gold.color;
        expect(result.toARGB32(), 0xFFFFB300);
      });

      test('legendary returns purple', () {
        final result = ChestType.legendary.color;
        expect(result.toARGB32(), 0xFF7C4DFF);
      });
    });

    group('glowColor', () {
      test('bronze returns brown', () {
        final result = ChestType.bronze.glowColor;
        expect(result.toARGB32(), 0xFF8D6E63);
      });
    });

    group('label', () {
      test('bronze returns Bronce', () {
        expect(ChestType.bronze.label, 'Bronce');
      });

      test('silver returns Plata', () {
        expect(ChestType.silver.label, 'Plata');
      });

      test('gold returns Oro', () {
        expect(ChestType.gold.label, 'Oro');
      });

      test('legendary returns Legendario', () {
        expect(ChestType.legendary.label, 'Legendario');
      });
    });
  });
}
