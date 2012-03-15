require 'spec_helper'
require 'genspec'

describe 'with_filters:theme' do
  with_args :foo do
    it 'generates app/views/with_filters/foo/ with all files' do
      subject.should generate('app/views/with_filters/foo')
      subject.should generate('app/views/with_filters/foo/_filter_form.html.erb')
      subject.should generate('app/views/with_filters/foo/filter/_text.html.erb')
    end
  end

  with_args :foo, 'filter_form' do
    it 'generates a single file in app/views/with_filters/foo/' do
      subject.should generate('app/views/with_filters/foo')
      subject.should generate('app/views/with_filters/foo/_filter_form.html.erb')
    end
  end

  with_args :foo, 'filter/text' do
    it 'generates a single file in app/views/with_filters/foo/filters' do
      subject.should generate('app/views/with_filters/foo/filter')
      subject.should generate('app/views/with_filters/foo/filter/_text.html.erb')
    end
  end

  with_args :foo, 'filter/text_as_email' do
    it 'generates a file in app/views/with_filters/foo/filters based on text to support "email" types' do
      subject.should generate('app/views/with_filters/foo/filter')
      subject.should generate('app/views/with_filters/foo/filter/_text_as_email.html.erb')
    end
  end
end
