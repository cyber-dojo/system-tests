require 'minitest/autorun'

require_relative 'browser/browser'

class CyberDojoTest < Minitest::Test

  def setup
    @browser = CyberDojo::Browser.new(self)
  end

  attr_reader :browser

  def teardown
    if not passed?
      begin
        @browser.save_screenshot(name)
      rescue
        puts "Failed to save screenshot for '#{name}'"
      else
        puts "Save screenshot as '#{name}'"
      end
    end
    @browser.close
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def method_missing(sym, *args, &block)
    if @browser.steps.respond_to?(sym)
      @browser.steps.send(sym, *args, &block)
    else
      super(sym, *args, &block)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def respond_to?(method, include_private = false)
    super || @browser.steps.respond_to?(method, include_private)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def debug_print_timing(message)
    @browser.debug_print_timing(message)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def pages
    @browser.pages
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def assert_page_loaded(page)
    assert(@browser.wait.until_or_false{
      page.load_completed? && @browser.page == page
    }, 'Failed to load page')
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def wait_for_button_to_be_enabled(button)
    assert(@browser.wait.until_or_false{
      true if button.enabled?
      }, "'#{button.text}' button was not enabled")
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def navigate_home
    browser.navigate_home
    assert_page_loaded(pages.main)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def individual_create_and_join_kata(args = {})
    navigate_home
    im_on_my_own_button.click

    assert_page_loaded(pages.individual)
    create_a_new_session_button.click

    create_a_default_kata(args)

    assert_page_loaded(pages.kata_individual)
    ok_button.click
    switch_to_editor_window

    assert_page_loaded(pages.kata_edit)
    assert_avatar(avatar)
    [kata_id,avatar]
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def group_create_kata(args = {})
    navigate_home
    were_in_a_group_button.click

    assert_page_loaded(pages.group)
    create_a_new_session_button.click

    create_a_default_kata(args)

    assert_page_loaded(pages.kata_group)
    ok_button.click

    assert_page_loaded(pages.dashboard_show)
    # http://.../dashboard/show/B5D987CA59
    id = @browser.page_url[2]
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def create_a_default_kata(args = {})
    assert_page_loaded(pages.setup_default_start_point_show)
    args[:display_name] ||= 'C (gcc), assert'
    args[:exercise] ||= '(Verbal)'
    select_display_name(args[:display_name])
    select_exercise(args[:exercise])
    ok_button.click
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def switch_to_editor_window(index = 1)
    @browser.switch_to_window(index)
    assert_page_loaded(pages.kata_edit)
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def assert_avatar(name)
    assert avatar_names.include?(name)
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def avatar_names
    %w(alligator antelope     bat       bear
       bee       beetle       buffalo   butterfly
       cheetah   crab         deer      dolphin
       eagle     elephant     flamingo  fox
       frog      gopher       gorilla   heron
       hippo     hummingbird  hyena     jellyfish
       kangaroo  kingfisher   koala     leopard
       lion      lizard       lobster   moose
       mouse     ostrich      owl       panda
       parrot    peacock      penguin   porcupine
       puffin    rabbit       raccoon   ray
       rhino     salmon       seal      shark
       skunk     snake        spider    squid
       squirrel  starfish     swan      tiger
       toucan    tuna         turtle    vulture
       walrus    whale        wolf      zebra
    )
  end

end
