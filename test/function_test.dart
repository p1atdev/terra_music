import 'package:flutter_test/flutter_test.dart';
import 'package:monster_siren/monster_siren.dart';

void main() {
  test('monster_siren lib', () async {
    final client = MonsterSiren();

    final a = await client.getAlbums();

    print(a);

    expect(a, isNotEmpty);
  });
}
