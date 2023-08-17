module ChatGPT
  class Client
    def initialize(api_key)
      @api_key = api_key
    end

    def headers
      [
        "Content-Type: application/json",
        "api-key: #{@api_key}"
      ]
    end

    def completions(args, prompt, params = {})
      # Set default parameters
      max_tokens = params[:max_tokens] || 50
      temperature = params[:temperature] || 1.5
      top_p = params[:top_p] || 1.0
      n = params[:n] || 1

      # Construct the URL for the completion request
      url = "https://clio-hackathon.openai.azure.com/openai/deployments/clio-gpt-35-turbo-16k/chat/completions?api-version=2023-03-15-preview"
      # POST https://{your-resource-name}.openai.azure.com/openai/deployments/{deployment-id}/chat/completions?api-version={api-version}

      # Prepare the data for the request
      max_length_warning = "Ensure the response is less than #{(max_tokens/10) * 9} characters."
      data = {
        messages: [{role: "system", content: "#{prompt} #{max_length_warning}"}],
        max_tokens: max_tokens,
        temperature: temperature,
        top_p: top_p,
        n: n
      }

      args.gtk.http_post_body(url, json_to_string(data), headers)
    end

    def json_to_string(data)
      if data.is_a?(Hash)
        "{\n" + data.map do |k, v|
          "  \"#{k}\": #{json_to_string(v)}"
        end.join(",\n") + "\n}"
      elsif data.is_a?(Array)
        "[\n" + data.map do |v|
          "  " + json_to_string(v)
        end.join(",") + "\n]"
      elsif data.is_a?(String)
        value = data.gsub("\"", "\\\"").gsub("\n", "\\n")
        "\"#{value}\""
      else
        "#{data}"
      end
    end
  end
end
