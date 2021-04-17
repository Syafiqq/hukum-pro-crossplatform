abstract class JsonRequest {
  T request<T>(
    String endpoint,
    Map<String, String> param,
    Map<String, String> header,
  );
}
