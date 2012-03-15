module WithFilters
  class ThemeGenerator < Rails::Generators::NamedBase
    desc('Create a new theme.')

    VIEW_PATH = 'app/views/with_filters'

    source_root File.expand_path("../../../../../#{VIEW_PATH}", __FILE__)

    argument :partial, required: false

    def create_theme
      empty_directory(VIEW_PATH)

      if partial
        if partial.index('/')
          (extra_dirs, partial_name) = partial.match(/^(.*)\/(.*)$/).captures

          empty_directory("#{VIEW_PATH}/#{file_name}/#{extra_dirs}")

          copy_file(
            "#{extra_dirs}/_#{partial_name.match(/^text_as_/) ? 'text' : partial_name}.html.erb",
            "#{VIEW_PATH}/#{file_name}/#{extra_dirs}/_#{partial_name}.html.erb"
          )
        else
          copy_file("_#{partial}.html.erb", "#{VIEW_PATH}/#{file_name}/_#{partial}.html.erb")
        end
      else
        directory('', "#{VIEW_PATH}/#{file_name}")
      end
    end
  end
end
