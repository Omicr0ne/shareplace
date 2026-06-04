abstract interface class DealTagRepository {
  Future<List<String>> getAvailableTags();
  Future<void> setTagsForDeal(String dealId, List<String> tags);
}
