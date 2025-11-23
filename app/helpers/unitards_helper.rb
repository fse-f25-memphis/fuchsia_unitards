module UnitardsHelper
    def unitard_image(unitard)
      case unitard.graphic
      when "He-Man"
        "unitards/unitard_battlecat_green.jpg"        # or .jpg if that's what you have
      when "Skeletor"
        "unitards/unitard_battlecat_green.jpg"
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
  