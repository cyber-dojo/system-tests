require 'selenium-webdriver'

class CyberDojoPage
  def initialize(driver, wait)
    @driver = driver
    @wait = wait
  end

end

def find_item_in_cyber_dojo_list(driver, listId, itemText)
  list = driver.find_element :id => listId

  listItems = list.find_elements :class => "filename"

  for item in listItems
    if item.text == itemText
      return item
    end
  end

  return nil
end