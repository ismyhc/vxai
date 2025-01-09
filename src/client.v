module vxai

import net.http
import json

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
@[params]
pub struct XAIClientParams {
pub:
	// api_key is the API key required for authentication.
	api_key string

	// base_url is the base URL for API requests.
	// If not provided, it defaults to `https://api.x.ai/v1/`.
	base_url string = base_url
}

// new creates a new instance of the XAIClient using the provided parameters.
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
fn (c XAIClient) post(path string, data string) !http.Response {
	mut req := http.Request{
		method:           .post
		url:              c.base_url + path
		data:             data
		on_progress_body: fn (r &http.Request, c []u8, b u64, d u64, e int) ! {
			println(c.bytestr())
		}
	}
	req.add_header(.authorization, 'Bearer ' + c.api_key)
	req.add_header(.content_type, 'application/json')
	return req.do()
}

type StreamOnMessageFn = StreamChatCompletionChunk | StreamCompletionChunk

// stream initiates a streaming POST request to the specified API path with the given JSON data.
// As the response body arrives, it is incrementally decoded into `StreamChatCompletionChunk` objects.
// Each chunk is passed to `on_message` for immediate processing, allowing you to handle output in real-time.
// Once the entire response stream finishes, the `on_finish` callback is invoked.
//
// Parameters:
// - path: The relative path to the API endpoint (e.g., `chat/completions`).
// - data: A JSON-encoded string containing the request payload.
// - on_message: A callback function that is triggered for each decoded `StreamChatCompletionChunk`.
// - on_finish: A callback function that is called once the entire stream has completed.
//
// Returns:
// - An `http.Response` containing metadata of the completed request.
// - An error if the request fails or if there's an issue during streaming.
fn (c XAIClient) stream(path string, data string, on_message fn (StreamOnMessageFn), on_finish fn ()) !http.Response {
	mut req := http.Request{
		method:           .post
		url:              c.base_url + path
		data:             data
		on_progress_body: fn [on_message] (request &http.Request, chunk []u8, body_read_so_far u64, body_expected_size u64, status_code int) ! {
			mut chunk_str := chunk.bytestr()
			// Cleanup chunk for JSON decoding
			// Remove data: prefix
			idx := chunk_str.index('{"id') or { -1 }
			if idx >= 0 {
				chunk_str = chunk_str[idx..]
			}

			decoded_chunk := json.decode(StreamChatCompletionChunk, chunk_str) or { return }

			if decoded_chunk.id == '' {
				return
			}

			on_message(decoded_chunk)
		}
		on_finish:        fn [on_finish] (request &http.Request, final_size u64) ! {
			on_finish()
		}
	}
	req.add_header(.authorization, 'Bearer ' + c.api_key)
	req.add_header(.content_type, 'application/json')
	return req.do()
}
