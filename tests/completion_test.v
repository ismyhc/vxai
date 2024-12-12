import vxai

fn test_vxai_completion() {
	api_key := vxai.get_api_key_from_env('XAI_API_KEY') or { panic('Failed to get API key') }
	client := vxai.XAIClient.new(vxai.XAIClientParams{
		api_key: api_key
	})
	input := vxai.CompletionInput.new('How are you today?', 'grok-beta')
	res := client.get_completion(input) or { panic(err) }
}

fn test_vxai_completion_stream() {
	api_key := vxai.get_api_key_from_env('XAI_API_KEY') or { panic('Failed to get API key') }
	client := vxai.XAIClient.new(vxai.XAIClientParams{
		api_key: api_key
	})
	mut input := vxai.CompletionInput.new('How are you?', 'grok-beta')
	res := client.stream_completion(mut input, fn (message vxai.StreamOnMessageFn) {
	}, fn () {
		println('Done')
	}) or {
		println(err)
		return
	}
}
