module vxai

import json

// Model represents a model in the X.AI API.
// It includes details such as the creation time, ID, ownership, and object type.
pub struct Model {
pub:
	// created is the Unix timestamp indicating when the model was created.
	created i64

	// id is the unique identifier for the model.
	id string

	// object specifies the type of object represented, typically "model".
	object string

	// owned_by indicates the owner of the model, usually the organization or team responsible for it.
	owned_by string
}

// ModelsResponse represents the response from the API when querying for all models.
// It contains a list of Model objects.
//
// The `@json: data` attribute maps the "data" key in the JSON response to the `models` field.
pub struct ModelsResponse {
pub:
	// models is the list of models available in the API.
	models []Model @[json: data]
}

// get_models retrieves all available models from the X.AI API.
//
// Returns:
// - A ModelsResponse struct containing a list of all available models.
// - An error if the request fails or if the response cannot be decoded.
pub fn (c XAIClient) get_models() !ModelsResponse {
	res := c.get('models') or { return error('Failed to get models') }
	return json.decode(ModelsResponse, res.body) or { return error('Failed to decode response') }
}

// get_model retrieves details about a specific model by its ID.
//
// Parameters:
// - id: The unique identifier of the model to retrieve.
//
// Returns:
// - A Model struct containing details about the requested model.
// - An error if the request fails or if the response cannot be decoded.
pub fn (c XAIClient) get_model(id string) !Model {
	res := c.get('models/' + id) or { return error('Failed to get model') }
	return json.decode(Model, res.body) or { return error('Failed to decode response') }
}
