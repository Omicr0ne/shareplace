abstract interface class DealTagRepository {
  Future<List<String>> getAvailableTags();
  Future<String> createTag({
    required String label,
    required String createdByProfileId,
  });
  Future<void> setTagsForDeal(String dealId, List<String> tags);
}
