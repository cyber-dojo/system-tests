require_relative 'cyber_dojo_test'

class CreatingAKataIndividualTest < CyberDojoTest

  def test_Creating_a_kata_individual
    individual_create_and_join_kata
  end

  def test_Creating_a_kata_group
    group_create_a_kata
  end

end

