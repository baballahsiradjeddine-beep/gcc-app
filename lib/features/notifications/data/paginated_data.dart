class PaginatedData<T> {
  PaginatedData({
    required this.data,
    required this.page,
    required this.totalPages,
  });

  final List<T> data;
  final int page;
  final int totalPages;
}
