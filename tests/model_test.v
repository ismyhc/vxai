import vxai

fn test_vxai_models() {
	api_key := vxai.get_api_key_from_env('XAI_API_KEY') or { panic('Failed to get API key') }
	client := vxai.XAIClient.new(vxai.XAIClientParams{
		api_key: api_key
	})
	models := client.get_models() or { panic('Failed to get models') }
}

fn test_vxai_model() {
	api_key := vxai.get_api_key_from_env('XAI_API_KEY') or { panic('Failed to get API key') }
	client := vxai.XAIClient.new(vxai.XAIClientParams{
		api_key: api_key
	})
	model := client.get_model('grok-beta') or { panic('Failed to get model') }
	assert model.id == 'grok-beta'
}
