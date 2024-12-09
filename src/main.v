module main

import vxai

fn main() {
	api_key := vxai.get_api_key_from_env('XAI_API_KEY') or { panic('Failed to get API key') }
	client := vxai.XAIClient.new(vxai.XAIClientParams{
		api_key: api_key
	})
	messages := [
		vxai.ChatCompletionMessage{
			role:    'system'
			content: 'You are a test assitatant.'
		},
		vxai.ChatCompletionMessage{
			role:    'user'
			content: 'What has the weather been like over the past 20 years?'
		},
	]
	input := vxai.ChatCompletionInput.new(messages, 'grok-beta')
	_ := client.stream_chat_completion(input, fn (message vxai.StreamChatCompletionChunk) {
		dump(message)
	}) or { panic(err) }
}
