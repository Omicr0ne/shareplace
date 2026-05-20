// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'email': instance.email,
    };
