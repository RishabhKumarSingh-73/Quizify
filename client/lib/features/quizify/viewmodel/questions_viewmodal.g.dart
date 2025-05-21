// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questions_viewmodal.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(QuestionsViewmodel)
const questionsViewmodelProvider = QuestionsViewmodelProvider._();

final class QuestionsViewmodelProvider
    extends $NotifierProvider<QuestionsViewmodel, AsyncValue<Questions>?> {
  const QuestionsViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questionsViewmodelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questionsViewmodelHash();

  @$internal
  @override
  QuestionsViewmodel create() => QuestionsViewmodel();

  @$internal
  @override
  $NotifierProviderElement<QuestionsViewmodel, AsyncValue<Questions>?>
  $createElement($ProviderPointer pointer) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Questions>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AsyncValue<Questions>?>(value),
    );
  }
}

String _$questionsViewmodelHash() =>
    r'bf25aac0280ff50da3a0a682f8c8ba7206d4c19e';

abstract class _$QuestionsViewmodel extends $Notifier<AsyncValue<Questions>?> {
  AsyncValue<Questions>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Questions>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Questions>?>,
              AsyncValue<Questions>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
