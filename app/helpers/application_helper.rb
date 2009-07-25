module ApplicationHelper
  include TagsHelper

  def sidebar(&block)
    content_for(:sidebar) { capture(&block) }
  end
  
  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def rss(url, options = {})
    content_for(:head) { auto_discovery_link_tag :rss, url, options }
  end

  def title(page_title)
    content_for(:title) { page_title }
    page_title
  end

  def button(text, options = {})
    content_tag :button, text, options.reverse_merge(:type => :submit)
  end

  def link_button_to(text, url, options = {})
    link_to text, url, options.merge(:class => "button #{options.delete(:class)}")
  end

  def icon(file, options = {})
    extension = options.delete(:extension) || 'png'
    path = options.delete(:path) || 'icons'
    image_tag("#{path}/#{file}.#{extension}", options)
  end

  def abbr_time_ago(time, format = :default)
    content_tag :abbr, time_ago_in_words(time), :title => l(time, :format => format)
  end

  def gravatar(email, options = {}, tag_options = {})
    hashed_email = Digest::MD5.hexdigest(email)
    options.reverse_merge!(:r => :g, :s => 80, :d => 'wavatar')
    image_tag url = "http://www.gravatar.com/avatar/#{hashed_email}.jpg?#{options.to_param}",
      tag_options.reverse_merge(:alt => 'gravatar', :class => 'gravatar')
  end

  def owner(user, &block)
    if logged_in? && (current_user == user || current_user.admin?)
      block.call
    end
  end

  def admin(&block)
    if logged_in? && current_user.admin?
      block.call
    end
  end

  def pagination(collection, options = {})
    content_tag :div, :class => 'pagination' do
      will_paginate collection, options.reverse_merge(
        :previous_label => '&laquo; Anterior',
        :next_label => 'Siguiente &raquo;',
        :container => false
      )
    end
  end

  def link_to_remote_if(condition, string, options, &block)
    condition ? link_to_remote(string, options) : (block_given? ? block.call : string)
  end

  def link_to_remote_unless(condition, string, options, &block)
    link_to_remote_if !condition, string, options, &block
  end
end
