class DealSearchFilters {
  const DealSearchFilters({
    this.query,
    this.postalCode,
    this.isFoodSupply,
    this.tags = const [],
  });

  final String? query;
  final String? postalCode;
  final bool? isFoodSupply;
  final List<String> tags;
}
