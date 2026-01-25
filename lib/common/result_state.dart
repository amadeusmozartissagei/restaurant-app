/// Sealed class for representing the result/state of API calls
/// This provides type-safe state management for loading, success, and error states
sealed class ResultState<T> {
  const ResultState();
}

/// Loading state - represents when data is being fetched
class LoadingState<T> extends ResultState<T> {
  const LoadingState();
}

/// Success state - contains the successfully loaded data
class SuccessState<T> extends ResultState<T> {
  final T data;
  const SuccessState(this.data);
}

/// Error state - contains error message when something goes wrong
class ErrorState<T> extends ResultState<T> {
  final String message;
  const ErrorState(this.message);
}

/// No Data state - for when there's no data but no error either
class NoDataState<T> extends ResultState<T> {
  final String message;
  const NoDataState([this.message = 'No data available']);
}
