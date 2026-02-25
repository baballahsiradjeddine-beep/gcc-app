import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/environment_config.dart';
import 'package:tayssir/providers/divisions/division_model.dart';
import 'package:tayssir/providers/user/subscription_model.dart';

import 'badge_model.dart';
import 'commune.dart';
import 'wilaya.dart';

class UserModel extends Equatable {
  final int id;
  final String email;
  final String name;
  final String? profilePicture;
  final String? phoneNumber;
  final Wilaya? wilaya;
  final Commune? commune;
  final DivisionModel? division;
  final int points;
  final List<SubscriptionModel> subscriptions;
  final bool isEmailVerified;
  final int age;
  final bool hasNewNotifications;
  final int newNotificationsCount;
  final BadgeModel? badge;
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.subscriptions,
    required this.age,
    required this.points,
    this.division,
    this.profilePicture,
    this.phoneNumber,
    this.wilaya,
    this.commune,
    required this.isEmailVerified,
    required this.hasNewNotifications,
    required this.newNotificationsCount,
    this.badge,
    // this.userProgress,
  });

  factory UserModel.empty() {
    return const UserModel(
      id: 0,
      email: '',
      name: '',
      age: 0,
      points: 0,
      subscriptions: [],
      isEmailVerified: false,
      hasNewNotifications: false,
      newNotificationsCount: 0,
    );
  }

  UserModel addPoints(int points) {
    return copyWith(
      points: this.points + points,
    );
  }

  UserModel verifyEmail() {
    return copyWith(isEmailVerified: true);
  }

  UserModel addSubscription(SubscriptionModel newSub) {
    final updatedSubs = List<SubscriptionModel>.from(subscriptions);
    updatedSubs.insert(0, newSub);
    return copyWith(subscriptions: updatedSubs);
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profilePicture,
    Wilaya? wilaya,
    int? age,
    Commune? commune,
    DivisionModel? division,
    String? localProfilePicture,
    List<SubscriptionModel>? subscriptions,
    int? points,
    bool? isEmailVerified,
    bool? hasNewNotifications,
    int? newNotificationsCount,
    BadgeModel? badge,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      wilaya: wilaya ?? this.wilaya,
      commune: commune ?? this.commune,
      division: division ?? this.division,
      age: age ?? this.age,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      subscriptions: subscriptions ?? this.subscriptions,
      points: points ?? this.points,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      hasNewNotifications: hasNewNotifications ?? this.hasNewNotifications,
      newNotificationsCount:
          newNotificationsCount ?? this.newNotificationsCount,
      badge: badge ?? this.badge,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (email.isNotEmpty) 'email': email,
      if (name.isNotEmpty) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      // if (profilePicture != null) 'image_url': profilePicture,
      if (age != 0) 'age': age,
      if (wilaya != null) 'wilaya': wilaya!.toMap(),
      if (commune != null) 'commune': commune!.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: (map['id'] as int?) ?? 0,
      email: (map['email'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      phoneNumber: map['phone_number'] as String?,
      profilePicture: map['image_url'] as String?,
      wilaya: map['wilaya'] == null
          ? null
          : Wilaya.fromMap(map['wilaya'] as Map<String, dynamic>),
      commune: map['commune'] == null
          ? null
          : Commune.fromMap(map['commune'] as Map<String, dynamic>),
      subscriptions: (map['subscriptions'] as List?)
              ?.map((e) => SubscriptionModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      division: map['division'] == null
          ? null
          : DivisionModel.fromMap(map['division'] as Map<String, dynamic>),
      age: map['age'] == null
          ? 0
          : map['age'] is String
              ? int.tryParse(map['age'] as String) ?? 0
              : map['age'] as int,
      points: map['points'] == null ? 0 : int.parse(map['points'].toString()),
      isEmailVerified: map['email_verified'] as bool? ?? false,
      hasNewNotifications: map['has_new_notifications'] as bool? ?? false,
      newNotificationsCount: map['new_notifications_count'] as int? ?? 0,
      badge: map['badge'] == null
          ? null
          : BadgeModel.fromMap(map['badge'] as Map<String, dynamic>),
    );
  }

  bool get isEmpty => email.isEmpty;

  bool get isSub =>
      subscriptions.isNotEmpty &&
      subscriptions.any((sub) =>
          sub.endingDate != null && DateTime.now().isBefore(sub.endingDate!));

  String get completeProfilePic {
    if (profilePicture == null ||
        profilePicture == EnvironmentConfig.imagesBaseUrl) {
      return AppConsts.defaultImageUrl;
    }
    return profilePicture!;
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        age,
        profilePicture,
        wilaya,
        commune,
        subscriptions,
        division,
        points,
        isEmailVerified,
        hasNewNotifications,
        newNotificationsCount,
        badge,
        // userProgress
      ];
}
