import 'dart:io';

import 'package:cosmetica_project/core/error/failures.dart';
import 'package:cosmetica_project/core/network/api_constants.dart';
import 'package:cosmetica_project/features/account_info_feature/data/models/account_info_model.dart';
import 'package:cosmetica_project/features/account_info_feature/data/models/account_update_model.dart';
import 'package:cosmetica_project/features/account_info_feature/domain/entities/account_info_entity.dart';
import 'package:cosmetica_project/features/account_info_feature/domain/entities/account_update_entity.dart';
import 'package:cosmetica_project/features/account_info_feature/domain/repositories/account_info_repository.dart';
import 'package:cosmetica_project/features/account_info_feature/domain/usecases/account_info_usecases.dart';
import 'package:cosmetica_project/features/profile_feature/data/models/profile_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepository implements AccountInfoRepository {
  final List<AccountUpdateEntity> updates = [];

  @override
  Future<Either<Failure, AccountInfoEntity>> getAccountInfo() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, AccountInfoEntity>> updateAccountInfo(
    AccountUpdateEntity update,
  ) async {
    updates.add(update);
    return const Right(_current);
  }
}

const _current = AccountInfoEntity(
  id: 'id-1',
  fullName: 'Lina Saad',
  phone: '+963944000104',
  initials: 'LS',
  email: 'lina@example.com',
);

void main() {
  group('UpdateAccountInfoUseCase', () {
    late _FakeRepository repository;
    late UpdateAccountInfoUseCase useCase;

    setUp(() {
      repository = _FakeRepository();
      useCase = UpdateAccountInfoUseCase(repository);
    });

    test('sends only the fields that changed', () async {
      await useCase(
        current: _current,
        fullName: 'Lina S.',
        email: 'lina@example.com',
      );

      expect(
        repository.updates.single,
        const AccountUpdateEntity(fullName: 'Lina S.'),
      );
    });

    test('no change: no request', () async {
      final result = await useCase(
        current: _current,
        fullName: 'Lina Saad',
        email: 'lina@example.com',
      );

      expect(repository.updates, isEmpty);
      expect(result, const Right<Failure, AccountInfoEntity>(_current));
    });

    test('clearing the email sends an empty string', () async {
      await useCase(current: _current, fullName: 'Lina Saad', email: '');

      expect(repository.updates.single, const AccountUpdateEntity(email: ''));
    });
  });

  group('AccountUpdateModel', () {
    test('without a photo is JSON with only the changed fields', () async {
      final data =
          await const AccountUpdateModel(fullName: 'Lina').toRequestData();

      expect(data, {'full_name': 'Lina'});
    });

    test('with a photo is multipart with the file', () async {
      final dir = Directory.systemTemp.createTempSync('account_test');
      final photo = File('${dir.path}/me.png')..writeAsBytesSync([1, 2, 3]);
      addTearDown(() => dir.deleteSync(recursive: true));

      final data =
          await AccountUpdateModel(photoPath: photo.path).toRequestData();

      expect(data, isA<FormData>());
      final form = data as FormData;
      expect(form.files.single.key, 'photo');
      expect(form.fields, isEmpty);
    });
  });

  group('photo URLs', () {
    final json = {
      'id': 'id-1',
      'full_name': 'Lina Saad',
      'phone': '+963944000104',
      'initials': 'LS',
      'email': null,
      'photo': '/media/accounts/photo.jpg',
    };

    test('a relative photo path is made absolute', () {
      expect(
        AccountInfoModel.fromJson(json).photoUrl,
        '${ApiConstants.baseUrl}/media/accounts/photo.jpg',
      );
    });

    test('the profile shows the phone when there is no email', () {
      final profile = ProfileModel.fromJson(json);

      expect(profile.contact, '+963944000104');
      expect(profile.photoUrl, startsWith('http'));
    });
  });
}
