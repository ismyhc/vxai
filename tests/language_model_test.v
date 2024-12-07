import vxai

fn test_vxai_language_models() {
	api_key := vxai.get_api_key_from_env('XAI_API_KEY') or { panic('Failed to get API key') }
	client := vxai.XAIClient.new(vxai.XAIClientParams{
		api_key: api_key
	})
	models := client.get_language_models() or { panic('Failed to get language models') }
}

fn test_vxai_language_model() {
	api_key := vxai.get_api_key_from_env('XAI_API_KEY') or { panic('Failed to get API key') }
	client := vxai.XAIClient.new(vxai.XAIClientParams{
		api_key: api_key
	})
	model := client.get_language_model('grok-beta') or { panic('Failed to get language model') }
	assert model.id == 'grok-beta'
}
