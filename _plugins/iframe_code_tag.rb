module Jekyll
    class IframeCodeTag < Liquid::Tag
      def initialize(tag_name, text, tokens)
        super
        @url = text.strip
      end
  
      def render(context)
        "<iframe src=\"#{@url}\" frameborder=\"0\" width=\"100%\" height=\"400\"></iframe>"
      end
    end
  end
  
  Liquid::Template.register_tag('iframe_code', Jekyll::IframeCodeTag)
  