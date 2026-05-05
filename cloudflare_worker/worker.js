export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    // Supabase URL
    const supabaseUrl = "supabase_url_placeholder";
    const targetUrl = supabaseUrl + url.pathname + url.search;

    // create a new request with the original headers
    const newRequest = new Request(targetUrl, request);

    return fetch(newRequest);
  }
}