import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:supa_architecture/supa_architecture.dart';
import 'package:supa_carbon_icons/supa_carbon_icons.dart';

// v5: Extension for PagingController to handle last page detection
extension AppendPagingController<T> on PagingController<int, T> {
  bool isLastPage(DataFilter filter, List list, int count) {
    if (list.length == count) {
      return true;
    }
    return ((items?.length ?? 0) + list.length == count);
  }
}

abstract class InfiniteListState<T extends JsonModel, TF extends DataFilter,
    TW extends StatefulWidget> extends State<TW> {
  final searchFocus = FocusNode();

  final searchController = TextEditingController();

  // v5: PagingController now takes getNextPageKey and fetchPage parameters
  late final PagingController<int, T> pagingController =
      PagingController<int, T>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => handlePageRequest(pageKey),
  );

  abstract TF filter;

  String get title;

  BaseRepository<T, TF> get repository;

  Future<void> showFilterForm() async {
    throw UnimplementedError();
  }

  bool isSearching = false;

  int total = 0;

  bool isForbidden = false;

  Widget itemRender(BuildContext context, T item, int index);

  Widget filterRender() {
    return const SizedBox.shrink();
  }

  Widget countRender(num count) {
    return const SizedBox.shrink();
  }

  void onIndexChange() {
    throw UnimplementedError();
  }

  @override
  void initState() {
    super.initState();
    // v5: No need to add listeners, fetchPage is handled in constructor
  }

  Future<void> reset() async {
    filter.skip = 0;
    // v5: Use refresh() method instead of manual state manipulation
    pagingController.refresh();
  }

  @override
  void dispose() {
    pagingController.dispose();
    searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  List<T> get list {
    // v5: Use the items extension getter to flatten pages
    return pagingController.items ?? [];
  }

  void clearFilter() {
    pagingController.refresh();
  }

  void reloadUI() {
    setState(() {});
  }

  void onSearch(String query) {
    if (query != '') {
      setState(() {
        filter.skip = 0;
        filter.search = query;
      });
      pagingController.refresh();
    }
  }

  void toggleSearch() {
    if (isSearching) {
      searchController.text = '';

      isSearching = false;
      filter.search = '';
      filter.skip = 0;

      pagingController.refresh();
      return;
    }

    setState(() {
      isSearching = true;
      searchFocus.requestFocus();
    });
  }

  Future<List<T>> handlePageRequest(int pageKey) async {
    filter.skip = pageKey;

    try {
      final results = await Future.wait([
        repository.list(filter),
        repository.count(filter),
      ]);

      final list = results[0] as List<T>;
      final count = results[1] as int;

      if (mounted) {
        setState(() {
          total = count;
        });
      }

      // v5: Return the list directly, PagingController handles state management
      return list;
    } catch (error) {
      debugPrint('Có lỗi xảy ra');

      if (mounted && error is DioException) {
        if (error.response?.statusCode == 403) {
          setState(() {
            isForbidden = true;
          });
        }
      }

      // v5: Re-throw the error for PagingController to handle
      rethrow;
    }
  }

  Future<void> refresh() async {
    filter.skip = 0;
    pagingController.refresh();
  }

  bool get shouldShowFilterButton => true;

  bool get shouldShowCreateButton => false;

  FutureOr<void> onCreate() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isForbidden) {
      return const PageForbidden();
    }

    final searchAction = Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 16,
      ),
      child: IconButton(
        onPressed: toggleSearch,
        icon: Icon(isSearching ? CarbonIcons.close : CarbonIcons.search),
      ),
    );

    final searchTitle = SearchableAppBarTitle(
      searchHint: 'Tìm kiếm...',
      isSearching: isSearching,
      onSubmitted: onSearch,
      searchController: searchController,
      searchFocus: searchFocus,
      title: title,
    );

    final backButton = Navigator.canPop(context) ? const GoBackButton() : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: backButton,
        title: searchTitle,
        actions: [
          if (!isSearching && shouldShowFilterButton)
            IconButton(
              icon: const Icon(CarbonIcons.filter),
              onPressed: () async {
                showFilterForm();
              },
            ),
          searchAction,
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: Container(
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.symmetric(
              vertical: 4,
            ),
            child: Column(
              children: [
                filterRender(),
                countRender(total),
                Expanded(
                  // v5: Use PagingListener to connect controller to PagedListView
                  child: PagingListener<int, T>(
                    controller: pagingController,
                    builder: (context, state, fetchNextPage) =>
                        PagedListView<int, T>(
                      state: state,
                      fetchNextPage: fetchNextPage,
                      builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder: itemRender,
                        firstPageProgressIndicatorBuilder:
                            buildFirstPageProgressIndicator,
                        newPageProgressIndicatorBuilder:
                            buildNewPageProgressIndicator,
                        noItemsFoundIndicatorBuilder: buildEmptyListIndicator,
                        newPageErrorIndicatorBuilder:
                            buildNextPageErrorPageIndicator,
                        firstPageErrorIndicatorBuilder:
                            buildFirstPageErrorPageIndicator,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: shouldShowCreateButton
          ? FloatingActionButton(
              onPressed: onCreate,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              child: const Icon(CarbonIcons.add),
            )
          : null,
    );
  }

  Widget buildFirstPageProgressIndicator(BuildContext context) {
    return const LoadingIndicator();
  }

  Widget buildNewPageProgressIndicator(BuildContext context) {
    return const LoadingIndicator();
  }

  Widget buildEmptyListIndicator(BuildContext context) {
    return const EmptyComponent(
      title: 'Chưa có dữ liệu',
    );
  }

  Widget buildNextPageErrorPageIndicator(BuildContext context) {
    return const Center(
      child: Text('Có lỗi xảy ra'),
    );
  }

  Widget buildFirstPageErrorPageIndicator(BuildContext context) {
    return const Center(
      child: Text('Có lỗi xảy ra'),
    );
  }

  Widget noItemsFoundIndicatorBuilder(BuildContext context) {
    return const EmptyComponent(
      title: 'Không có dữ liệu',
    );
  }

  void showSearchBar() => setState(() => isSearching = true);

  void cancelSearchBar() {
    searchController.clear();
    setState(() {
      isSearching = false;
      filter.search = '';
      filter.skip = 0;
    });
    pagingController.refresh();
  }
}
