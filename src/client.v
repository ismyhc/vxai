module vxai

import net.http

// base_url defines the default base URL for the X.AI API.
pub const base_url = 'https://api.x.ai/v1/'

// XAIClient is a client for interacting with the X.AI API.
// It provides methods for making authenticated GET and POST requests.
pub struct XAIClient {
pub:
	// api_key is the API key used for authentication.
	api_key string

	// base_url is the base URL for API requests.
	// Defaults to `https://api.x.ai/v1/` but can be customized.
	base_url string
}

// XAIClientParams is used to initialize an XAIClient instance.
// It supports optional customization of the base URL.
//
// Example:
// ```v
// client := XAIClient.new(XAIClientParams{
//     api_key: 'your_api_key'
// })
// ```
@[params]
pub struct XAIClientParams {
pub:
	// api_key is the API key required for authentication.
	api_key string

	// base_url is the base URL for API requests.
	// If not provided, it defaults to `https://api.x.ai/v1/`.
	base_url string = vxai.base_url
}

// new creates a new instance of the XAIClient using the provided parameters.
//
// Example:
// ```v
// client := XAIClient.new(XAIClientParams{
//     api_key: 'your_api_key'
// })
// ```
pub fn XAIClient.new(p XAIClientParams) XAIClient {
	return XAIClient{
		api_key:  p.api_key
		base_url: p.base_url
	}
}

// get performs an authenticated GET request to the specified API path.
//
// Parameters:
// - path: The relative path to the API endpoint (e.g., `api-key`).
//
// Returns:
// - An http.Response object containing the server's response.
// - An error if the request fails.
//
// Example:
// ```v
// res := client.get('api-key') or { panic(err) }
// println(res.body)
// ```
fn (c XAIClient) get(path string) !http.Response {
	mut req := http.Request{
		url: c.base_url + path
	}
	req.add_header(.authorization, 'Bearer ' + c.api_key)
	return req.do()
}

// post performs an authenticated POST request to the specified API path with the given data.
//
// Parameters:
// - path: The relative path to the API endpoint (e.g., `chat`).
// - data: The request body as a JSON string.
//
// Returns:
// - An http.Response object containing the server's response.
// - An error if the request fails.
//
// Example:
// ```v
// res := client.post('chat', '{"message": "Hello"}') or { panic(err) }
// println(res.body)
// ```
fn (c XAIClient) post(path string, data string) !http.Response {
	mut req := http.Request{
		method: .post
		url:    c.base_url + path
		data:   data
	}
	req.add_header(.authorization, 'Bearer ' + c.api_key)
	req.add_header(.content_type, 'application/json')
	return req.do()
}
