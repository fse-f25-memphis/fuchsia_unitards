module UnitardsHelper
    def unitard_image(unitard)
      case unitard.name
      when "He-Man Power Suit 1"
        "unitards/suit1.jpg"        # or .jpg if that's what you have
      when "He-Man Power Suit 2"
        "unitards/suit2.jpg"
      when "She-Ra"
        "unitards/unitard_battlecat_green.jpg"
      when "Battle Cat"
        "unitards/unitard_battlecat_green.jpg"  # 🔴 changed from .svg → .png
      when "Castle Grayskull"
        "unitards/unitard_battlecat_green.jpg"
      else
        "unitards/unitard_battlecat_green.jpg"
      end
    end
  end
  