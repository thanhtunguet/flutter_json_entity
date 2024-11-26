import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import "../filters/filters.dart";

extension AppendPagingController<T> on PagingController<int, T> {
  set newItemList(List<T> list) {
    value = PagingState<int, T>(
      error: error,
      itemList: list,
      nextPageKey: list.length,
    );
  }

  set totalItemList(List<T> list) {
    value = PagingState<int, T>(
      error: error,
      itemList: list,
      nextPageKey: null,
    );
  }

  void append(List<T> itemList, int count) {
    if (itemList.length == count) {
      totalItemList = itemList;
      return;
    }
    newItemList = itemList;
  }

  bool isLastPage(DataFilter filter, List list, int count) {
    if (list.length == count) {
      return true;
    }
    return ((itemList?.length ?? 0) + list.length == count);
  }
}
