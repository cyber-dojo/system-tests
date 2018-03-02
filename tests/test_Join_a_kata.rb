require_relative 'cyber_dojo_test'

class JoinAKataTest < CyberDojoTest

  # These tests in unreliable. I'm frequently getting
  # Selenium::WebDriver::Error::ScriptTimeOutError: timeout: cannot determine loading status
  # from timeout: Timed out receiving message from renderer: -0.004

  def test_An_individual_kata_can_be_joined_from_the_homepage
    individual_create_and_join_kata
    id = kata_id
    first_avatar = avatar
    assert_avatar(first_avatar)
    browser.restart

    second_avatar = navigate_to_the_join_page_and_join(id)

    assert_avatar(second_avatar)
    refute_equal first_avatar, second_avatar
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def test_A_group_kata_can_be_joined_from_the_homepage
    group_create_a_kata
    # http://.../dashboard/show/B5D987CA59
    id = @browser.page_url[2]
    navigate_home
    avatar = navigate_to_the_join_page_and_join(id)
    assert_avatar(avatar)
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def navigate_to_the_join_page_and_join(id)
    navigate_home
    were_in_a_group_button.click

    assert_page_loaded(pages.group)
    join_button.click

    assert_page_loaded(pages.id_join_show)
    enter_kata_id(id[0..5])
    ok_button.click
    switch_to_editor_window
    avatar
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