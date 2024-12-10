module vxai

import os

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
