import vxai
import os

fn test_vxai_chat_completion() {
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
	res := client.get_chat_completion(input) or { panic('Failed to get chat completion') }
}
