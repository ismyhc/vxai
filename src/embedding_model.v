module vxai

import json

// The API path for embedding models.
pub const embedding_model_path = 'embedding-models'

// EmbeddingModel represents a specific embedding model available in the X.AI API.
// It includes details about the model's ID, creation time, input capabilities, and pricing.
pub struct EmbeddingModel {
	// created is the Unix timestamp indicating when the model was created.
	created i64

	// id is the unique identifier for the embedding model.
	id string

	// input_modalities is a list of supported input types for the model, such as "text" or "image".
	input_modalities []string

	// object specifies the type of object represented, typically "model".
	object string

	// owned_by indicates the owner of the model, usually the organization or team responsible for it.
	owned_by string

	// prompt_image_token_price specifies the token price for image-based inputs.
	prompt_image_token_price i64

	// prompt_text_token_price specifies the token price for text-based inputs.
	prompt_text_token_price i64

	// version specifies the version of the embedding model, such as "1.0.0".
	version string
}

// EmbeddingModelsResponse represents the response from the API when querying for all available embedding models.
// It contains a list of EmbeddingModel objects.
pub struct EmbeddingModelsResponse {
pub:
	// models is the list of embedding models available in the API.
	models []EmbeddingModel
}

// get_embedding_models retrieves all available embedding models from the X.AI API.
//
// Returns:
// - An EmbeddingModelsResponse struct containing a list of all available embedding models.
// - An error if the request fails or if the response cannot be decoded.
pub fn (c XAIClient) get_embedding_models() !EmbeddingModelsResponse {
	res := c.get(vxai.embedding_model_path) or { return error('Failed to get embedding models') }
	dump(res.body)
	return json.decode(EmbeddingModelsResponse, res.body) or {
		return error('Failed to decode response')
	}
}

// get_embedding_model retrieves details about a specific embedding model by its ID.
//
// Parameters:
// - id: The unique identifier of the embedding model to retrieve.
//
// Returns:
// - An EmbeddingModel struct containing details about the requested model.
// - An error if the request fails or if the response cannot be decoded.
pub fn (c XAIClient) get_embedding_model(id string) !EmbeddingModel {
	res := c.get(vxai.embedding_model_path + '/' + id) or { return error('Failed to get embedding model') }
	return json.decode(EmbeddingModel, res.body) or { return error('Failed to decode response') }
}
