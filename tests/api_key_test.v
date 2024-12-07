import vxai

fn test_vxai() {
	api_key := vxai.get_api_key_from_env('XAI_API_KEY') or { panic('Failed to get API key') }
	client := vxai.XAIClient.new(vxai.XAIClientParams{
		api_key: api_key
	})
	res := client.get_api_key_info() or { panic('Failed to get API key info') }
}
