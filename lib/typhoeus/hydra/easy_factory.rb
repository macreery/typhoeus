module Typhoeus
  class Hydra

    # This is a Factory for easies to be used in the hydra.
    # Before an easy is ready to be added to a multi, it needs
    # to be prepared and the on_complete callback to be set.
    # This is done by this class.
    class EasyFactory
      attr_reader :request, :hydra

      # Create an easy factory.
      #
      # @example Create easy factory.
      #   Typhoeus::Hydra::EasyFactory.new(request, hydra)
      #
      # @param [ Request ] request The request to build an easy for.
      # @param [ Hydra ] hydra The hydra to build an easy for.
      def initialize(request, hydra)
        @request = request
        @hydra = hydra
      end

      # Return the easy in question.
      #
      # @example Return easy.
      #   easy_factory.easy
      #
      # @return [ Ethon::Easy ] The easy.
      def easy
        @easy ||= hydra.get_easy
      end

      # Fabricated and prepared easy.
      #
      # @example Prepared easy.
      #   easy_factory.get
      #
      # @return [ Ethon::Easy ] The prepared easy.
      def get
        easy.http_request(
          request.url,
          request.options.fetch(:method, :get),
          request.options.reject{|k,_| k==:method}
        )
        easy.prepare
        set_callback
        easy
      end

      # Sets on_complete callback on easy in order to be able to
      # track progress.
      #
      # @example Set callback.
      #   easy_factory.set_callback
      #
      # @return [ Ethon::Easy ] The easy.
      def set_callback
        easy.on_complete do |easy|
          request.response = Response.new(easy.to_hash)
          hydra.release_easy(easy)
          hydra.queue(hydra.queued_requests.shift) unless hydra.queued_requests.empty?
          request.execute_callbacks
        end
      end
    end
  end
end
