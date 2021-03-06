module Typhoeus
  class Response

    # This module contains logic about the http
    # status.
    module Status

      # Return the status message if present.
      #
      # @example Return status message.
      #   reesponse.status_message
      #
      # @return [ String ] The message.
      def status_message
        return @status_message if defined?(@status_message) && @status_message
        return options[:status_message] unless options[:status_message].nil?

        # HTTP servers can choose not to include the explanation to HTTP codes. The RFC
        # states this (http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.4):
        # Except when responding to a HEAD request, the server SHOULD include an entity containing
        # an explanation of the error situation [...]
        # This means 'HTTP/1.1 404' is as valid as 'HTTP/1.1 404 Not Found' and we have to handle it.

        # Regexp doc: http://rubular.com/r/eAr1oVYsVa
        if first_header_line != nil and first_header_line[/\d{3} (.*)$/, 1] != nil
          @status_message = first_header_line[/\d{3} (.*)$/, 1].chomp
        else
          @status_message = nil
        end
      end

      # Return the http version.
      #
      # @example Return http version.
      #  response.http_version
      #
      # @return [ String ] The http version.
      def http_version
        @http_version ||= first_header_line ? first_header_line[/HTTP\/(\S+)/, 1] : nil
      end

      # Return wether the response is a success.
      #
      # @example Return if the response was successful.
      #  response.success?
      #
      # @return [ Boolean ] Return true if successful, false else.
      def success?
        return_code == :ok && response_code >= 200 && response_code < 300
      end

      # Return wether the response is modified.
      #
      # @example Return if the response was modified.
      #  response.modified?
      #
      # @return [ Boolean ] Return true if modified, false else.
      def modified?
        return_code == :ok && response_code != 304
      end

      # Return wether the response is timed out.
      #
      # @example Return if the response timed out..
      #  response.time_out?
      #
      # @return [ Boolean ] Return true if timed out, false else.
      def timed_out?
        return_code == 28
      end

      # :nodoc:
      def first_header_line
        @first_header_line ||= response_header.to_s.split("\n").first
      end
    end
  end
end
