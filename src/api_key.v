module vxai

import json
import os

// APIKeyInfo represents detailed information about an API key,
// including its status, associated user, and access controls.
pub struct APIKeyInfo {
pub:
	// acls is a list of access control rules associated with the API key.
	// Examples include "api-key:model:*" or "api-key:endpoint:*".
	acls []string

	// api_key_blocked indicates whether the API key is currently blocked.
	api_key_blocked bool

	// api_key_disabled indicates whether the API key is currently disabled.
	api_key_disabled bool

	// api_key_id is the unique identifier for the API key.
	api_key_id string

	// create_time is the ISO 8601 timestamp indicating when the API key was created.
	create_time string

	// modified_by is the unique identifier of the user who last modified the API key.
	modified_by string

	// modify_time is the ISO 8601 timestamp indicating when the API key was last modified.
	modify_time string

	// name is the user-defined name of the API key.
	name string

	// redacted_api_key is a partially hidden representation of the API key for display purposes.
	redacted_api_key string

	// team_blocked indicates whether the team associated with the API key is blocked.
	team_blocked bool

	// team_id is the unique identifier for the team associated with the API key.
	team_id string

	// user_id is the unique identifier for the user associated with the API key.
	user_id string
}

// get_api_key_info retrieves information about the current API key being used by the client.
// It sends a GET request to the "api-key" endpoint and parses the response into an APIKeyInfo struct.
//
// Returns:
// - An APIKeyInfo struct containing detailed API key information if successful.
// - An error if the request or JSON decoding fails.
pub fn (c XAIClient) get_api_key_info() !APIKeyInfo {
	res := c.get('api-key') or { return error('Failed to get API key info') }
	return json.decode(APIKeyInfo, res.body) or { return error('Failed to decode response') }
}

// get_api_key_from_env retrieves an API key from the specified environment variable.
//
// Parameters:
// - env: The name of the environment variable containing the API key.
//
// Returns:
// - The API key as a string if the environment variable is set.
// - An error if the environment variable is not set or is empty.
pub fn get_api_key_from_env(env string) !string {
	api_key := os.getenv(env)
	if api_key == '' {
		panic('${env} not set. Please set your environment variables')
	}
	return api_key
}
