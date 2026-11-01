module MoviehouseUk
  # Internal utility classes: Do not use
  # @api private
  module Internal
    # Sanitize and standardize film titles
    class TitleSanitizer < Cinebase::TitleSanitizer
      # @!method initialize(title)
      #   Constructor
      #   @param [String] title a film title
      #   @return [MoviehouseUk::Internal::TitleSanitizer]

      # @!method sanitized
      #   sanitized and standardized title
      #   @return [String] sanitised title

      private

      # strings and regex to be removed
      def remove
        [
          /\AEvent:\s*/i # event prefix
        ] + COMMON_REMOVE
      end

      # regexes and their replacements
      def replace
        {
          /\ANTL (.*)/                            => 'National Theatre Live: ',
          /\ARBO (?!20\d{2}-)(.*?)(?: 20\d{2})?\z/ => 'Royal Ballet and Opera: '
        }.merge(COMMON_REPLACE)
      end
    end
  end
end
