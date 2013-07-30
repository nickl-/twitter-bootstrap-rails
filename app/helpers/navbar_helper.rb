#Credit for this goes to https://github.com/julescopeland/Rails-Bootstrap-Navbar
module NavbarHelper
  def nav_bar(options={}, &block)
    nav_bar_div(options) do
      navbar_inner_div do
        container_div(options[:brand], options[:brand_link], options[:responsive], options[:fluid]) do
          yield if block_given?
        end
      end
    end
  end

  def menu_group(options={}, &block)
    pull_class = "pull-#{options[:pull].to_s}" if options[:pull].present?
    content_tag(:ul, :class => "nav navbar-nav #{pull_class}", &block)
  end

  def menu_item(name = nil, path="#", *args, &block)
    options = args.extract_options!
    content_tag :li, :class => is_active?(path) do
			if (name.nil?) then
				content_tag :a, href: path do
					yield
				end
			else 
				link_to(name, path, options)
			end
    end
  end

  def menu_dropdown(name)
    content_tag :li, :class => "dropdown" do
      dropdown_link(name) + dropdown_list { yield }
    end
  end

  def dropdown_divider
    content_tag :li, "", :class => "divider"
  end

  def dropdown_header(text)
    content_tag :li, text, :class => "nav-header"
  end

  def menu_divider
    content_tag :li, "", :class => "divider-vertical"
  end

  def menu_text(text=nil, options={}, &block)
    pull       = options.delete(:pull)
    pull_class = pull.present? ? "pull-#{pull.to_s}" : nil
    options.append_merge!(:class, pull_class)
    options.append_merge!(:class, "navbar-text")
    content_tag :p, options do
      text || yield
    end
  end

  def menu_button(text=nil, path="#", options={}, &block)
    pull       = options.delete(:pull)
		style			 = options.delete(:style)
    pull_class = pull.present? ? "pull-#{pull.to_s}" : nil
    style_class = style.present? ? "btn-#{style.to_s}" : "btn-default"
		javascript_path = "window.location='#{path}'"
    options.append_merge!(:type, "button")
    options.append_merge!(:class, style_class)
    options.append_merge!(:class, pull_class)
    options.append_merge!(:class, "btn navbar-btn")
    options.append_merge!(:onclick, javascript_path)
    content_tag :li, :class => is_active?(path) do
			content_tag :button, options do
				text || yield
			end
		end
  end

  def menu_form(action=nil, options={}, &block)
    pull_class = "pull-#{options[:pull].to_s}" if options[:pull].present?
    content_tag(:form, {:class => "navbar-form #{pull_class}", :action => action}, &block)
  end

  def input_text(text=nil, options={})
    pull       = options.delete(:pull)
    pull_class = pull.present? ? "pull-#{pull.to_s}" : nil

    options.append_merge!(:type, "text")
    options.append_merge!(:class, pull_class)
    options.append_merge!(:class, "form-control col-lg-8")
    options.append_merge!(:placeholder, text)
    content_tag :input, options
  end

  private

  def nav_bar_div(options, &block)

    position = "static-#{options[:static].to_s}" if options[:static]
    position = "fixed-#{options[:fixed].to_s}" if options[:fixed]
    inverse = (options[:inverse].present? && options[:inverse] == true) ? true : false

    content_tag :div, :class => nav_bar_css_class(position, inverse) do
      yield
    end
  end

  def navbar_inner_div(&block)
    content_tag :div, :class => "navbar-inner" do
      yield
    end
  end

  def container_div(brand, brand_link, responsive, fluid, &block)
    content_tag :div, :class => "container#{"-fluid" if fluid}" do
      container_div_with_block(brand, brand_link, responsive, &block)
    end
  end

  def container_div_with_block(brand, brand_link, responsive, &block)
    output = []
    if responsive == true
      output << responsive_button
      output << brand_link(brand, brand_link)
      output << responsive_div { capture(&block) }
    else
      output << brand_link(brand, brand_link)
      output << capture(&block)
    end
    output.join("\n").html_safe
  end

  def nav_bar_css_class(position, inverse = false)
    css_class = ["navbar"]
    css_class << "navbar-#{position}" if position.present?
    css_class << "navbar-inverse" if inverse
    css_class.join(" ")
  end

  def brand_link(name, url)
    return "" if name.blank?
    url ||= root_url
    link_to(name, url, :class => "navbar-brand")
  end

  def responsive_button
    %{<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-responsive-collapse">
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	      </button>}
  end

  def responsive_div(&block)
    content_tag(:div, :class => "nav-collapse collapse navbar-responsive-collapse", &block)
  end

  def is_active?(path, options={})
    "active" if uri_state(path, options).in?([:active, :chosen])
  end

  def name_and_caret(name)
    "#{name} #{content_tag(:b, :class => "caret") {}}".html_safe
  end

  def dropdown_link(name)
    link_to(name_and_caret(name), "#", :class => "dropdown-toggle", "data-toggle" => "dropdown")
  end

  def dropdown_list(&block)
    content_tag :ul, :class => "dropdown-menu", &block
  end
end

class Hash
  # appends a string to a hash key's value after a space character (Good for merging CSS classes in options hashes)
  def append_merge!(key, value)
    # just return self if value is blank
    return self if value.blank?

    current_value = self[key]
    # just merge if it doesn't already have that key
    self[key] = value and return if current_value.blank?
    # raise error if we're trying to merge into something that isn't a string
    raise ArgumentError, "Can only merge strings" unless current_value.is_a?(String)
    self[key] = [current_value, value].compact.join(" ")
  end
end
