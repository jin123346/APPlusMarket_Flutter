import 'package:riverpod/riverpod.dart';

import '../../_core/utils/logger.dart';

enum SearchAction {
  none,
  isLoading,
  completed,
}

class SearchEventNotifier extends Notifier<SearchAction> {
  @override
  SearchAction build() {
    return SearchAction.none;
  }

  void searching() {
    logger.i(' SearchAction isLoading 로 변경');

    state = SearchAction.isLoading;
  }

  void completed() {
    logger.i('SearchAction completed 로 변경');
    state = SearchAction.completed;
  }

  void reset() {
    logger.i('SearchAction none 로 변경');

    state = SearchAction.none;
  }
}

final searchEventProvider = NotifierProvider<SearchEventNotifier, SearchAction>(
    () => SearchEventNotifier());
