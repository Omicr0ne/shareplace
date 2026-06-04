// Repository interfaces mirror the app data layer even when they expose one use
// case today.
// ignore_for_file: one_member_abstracts

abstract interface class DealTagRepository {
  Future<void> setTagsForDeal(String dealId, List<String> tags);
}
