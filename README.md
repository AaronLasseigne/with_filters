# with_filters

Add filtering to tables, lists, etc.

This project follows [Semantic Versioning](http://semver.org/).

## Installation

    $ gem install with_filters

If you're using Bundler, add this to your Gemfile:

    gem 'with_filters', '~> 0.1.0'

## Support

<table>
  <tr>
    <td><strong>Ruby</strong></td>
    <td>1.9</td>
  </tr>
  <tr>
    <td><strong>Rails</strong></td>
    <td>3.1</td>
  </tr>
  <tr>
    <td><strong>Database Framework</strong></td>
    <td>ActiveRecord</td>
  </tr>
</table>

## Usage

In your controller:

    @data = Data.with_filters(params, fields: {
      email_address: {match: :contains},
      full_name:     ->(value, scope) {
        first_word, second_word = value.strip.split(/\s+/)

        if second_word
          scope.where(['first_name LIKE ? OR last_name LIKE ?', first_word, first_word])
        else
          scope.where(['first_name LIKE ? AND last_name LIKE ?', first_word, second_word])
        end
      }
    }).order('created_at DESC').page(params[:page] || 1)

In your view:

    <%= filter_form_for(@data) do |f| %>
      <%# pass through variables needed in the form but not associated with filtering %>
      <% if params[:order] %>
        <% f.hidden(:order, name: 'order', value: params[:order]) %>
      <% end %>

      <% f.input(:id) %>
      <% f.input_range(:created_at, label: 'Account Created On') %> <%# creates a filter to search a range %>
      <% f.input(:full_name) %>
      <% f.input(:email_address) %>

      <% f.action(:submit, label: 'Filter') %>
    <% end %>
