import '../../domain/entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ProfileEntity> getProfile() async {
    return const ProfileEntity(
      name: 'سارة أحمد',
      email: 'sarah.ahmed@example.com',
    );
  }
}
