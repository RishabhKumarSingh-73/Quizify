// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questions_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(questionsRepository)
const questionsRepositoryProvider = QuestionsRepositoryProvider._();

final class QuestionsRepositoryProvider
    extends $FunctionalProvider<QuestionsRepository, QuestionsRepository>
    with $Provider<QuestionsRepository> {
  const QuestionsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questionsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questionsRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuestionsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  QuestionsRepository create(Ref ref) {
    return questionsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuestionsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<QuestionsRepository>(value),
    );
  }
}

String _$questionsRepositoryHash() =>
    r'd8467f89ffaa5d5066de064a9691fc6b4d41e6a4';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
