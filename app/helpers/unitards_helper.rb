module UnitardsHelper
    def unitard_image(unitard)
      case unitard.name
      when "Battle Cat Power Suit 1"
        "unitards/suit1.jpg"        
      when "Battle Cat Power Suit 2"
        "unitards/suit2.jpg"
      when "Skeletor Power Suit 3"
        "unitards/suit3.jpg"
      when "Man-At-Arms Power Suit 4"
        "unitards/suit4.jpg"  
      when "Man-At-Arms Power Suit 5"
        "unitards/suit5.jpg"
      when "Battle Cat Power Suit 6"
        "unitards/suit6.jpg"
      when "She-Ra Power Suit 7"
        "unitards/suit7.jpg"
      when "Castle Grayskull Power Suit 8"
        "unitards/suit8.jpg"
      when "Castle Grayskull Power Suit 9"
        "unitards/suit9.jpg"
      when "Skeletor Power Suit 10"
        "unitards/suit10.jpg"
      when "She-Ra Power Suit 11"
        "unitards/suit11.jpg"
      when "Man-At-Arms Power Suit 12"
        "unitards/suit12.jpg"
      else
        "unitards/unitard_battlecat_green.jpg"
      end
    end
  end
  